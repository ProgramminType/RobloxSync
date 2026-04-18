local Config = require(script.modules.Config)

local Serializer = require(script.modules.Serializer)
local Deserializer = require(script.modules.Deserializer)
local ChangeDetector = require(script.modules.ChangeDetector)
local UI = require(script.modules.UI)

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- DescendantAdded (and script follow-up) can run deferred; keep suppression through a few frames
-- so echoed creates are not flushed on the next poll as Studio ---> VS Code.
local HEARTBEATS_BEFORE_UNSUPPRESS = 3

local connected = false
local polling = false
local pingAlive = false
local sessionId = nil
local changeDetector = nil
local watcherAlive = true
-- After a successful full sync; used to hide disconnect/poll noise during the brief VS Code reload window.
local lastFullySyncedAt = 0
local HANDOFF_GRACE_SEC = 8
-- Suppress duplicate "Connecting" / "Connected" Studio output when VS Code reloads and we reconnect (~10–30s later).
local lastStudioConnectBannerAt = 0
local STUDIO_CONNECT_BANNER_COOLDOWN_SEC = 90
-- Paths for which we echoed an Update after a VS Code create; filter duplicate ChangeDetector creates (incl. deferred scripts).
local suppressedVscodeCreatePaths = {}
-- Label for Studio output: matches API experience name when available (game.Name is often "Place 1").
local lastConnectDisplayName = nil

local function withinHandoffGrace(): boolean
	return (os.clock() - lastFullySyncedAt) < HANDOFF_GRACE_SEC
end

local function getBaseUrl()
	return Config.HOST .. ":" .. tostring(Config.PORT) .. "/api"
end

local LOG_PREFIX = "[Roblox Sync]"

local function logLine(msg)
	print(LOG_PREFIX .. " " .. msg)
end

local function actionLabel(t)
	local m = {
		create = "Create",
		delete = "Delete",
		update = "Update",
		rename = "Rename",
	}
	if type(t) == "string" and m[t] then
		return m[t]
	end
	if type(t) == "string" and #t > 0 then
		return t:sub(1, 1):upper() .. t:sub(2)
	end
	return "?"
end

local function formatChangeSummary(change)
	local p = change.instancePath or "?"
	local act = actionLabel(change.type)
	if change.type == "rename" and change.oldName and change.newName then
		return string.format("%s %s (%s -> %s)", act, p, change.oldName, change.newName)
	end
	-- Updates: instance path only; ".Property" looks like hierarchy (e.g. LocalScript.Source).
	return string.format("%s %s", act, p)
end

local function filterFlushCreates(studioChanges, suppressed)
	if not studioChanges or #studioChanges == 0 then
		return studioChanges
	end
	if not suppressed or next(suppressed) == nil then
		return studioChanges
	end
	local out = {}
	for _, c in ipairs(studioChanges) do
		if not (c.type == "create" and suppressed[c.instancePath]) then
			table.insert(out, c)
		end
	end
	return out
end

--- Strip leading "game." for path matching (VS Code paths omit it).
local function normalizeInstancePathKey(p)
	if type(p) ~= "string" or p == "" then
		return nil
	end
	if string.sub(p, 1, 5) == "game." then
		return string.sub(p, 6)
	end
	return p
end

--- Same poll batch can include create (full snapshot) plus Changed updates for defaults (Source, Enabled, …). Drop redundant property-only updates.
local function dedupeUpdatesShadowedByCreatesInBatch(studioChanges)
	if not studioChanges or #studioChanges == 0 then
		return studioChanges
	end
	local created = {}
	for _, c in ipairs(studioChanges) do
		if c.type == "create" and type(c.instancePath) == "string" then
			created[c.instancePath] = true
			local n = normalizeInstancePathKey(c.instancePath)
			if n then
				created[n] = true
			end
		end
	end
	if next(created) == nil then
		return studioChanges
	end
	local out = {}
	for _, c in ipairs(studioChanges) do
		local drop = false
		if c.type == "update" and type(c.instancePath) == "string" and not c.instanceData then
			local p = c.instancePath
			local n = normalizeInstancePathKey(p)
			if created[p] or (n and created[n]) then
				drop = true
			end
		end
		if not drop then
			table.insert(out, c)
		end
	end
	return out
end

local function doFullSync()
	Serializer.renameLiveInstancesForDuplicateNames = false

	local tree = {}
	for _, serviceName in ipairs(Config.SYNCED_SERVICES) do
		local service = game:FindService(serviceName)
		if service then
			table.insert(tree, Serializer.serializeInstance(service))
		end
	end

	Serializer.renameLiveInstancesForDuplicateNames = true

	local body = HttpService:JSONEncode({ tree = tree })
	local success, err = pcall(function()
		HttpService:PostAsync(getBaseUrl() .. "/full-sync", body, Enum.HttpContentType.ApplicationJson)
	end)

	if not success then
		warn(LOG_PREFIX .. " error: full sync failed: " .. tostring(err))
		return false
	end
	return true
end

--- @param silentLog boolean if true, omit output (used for VS Code create echo — user already saw VS Code ---> Studio).
local function sendStudioChanges(changes, silentLog)
	if #changes == 0 then
		return
	end

	local url = getBaseUrl() .. "/studio-changes"
	if not silentLog then
		for _, change in ipairs(changes) do
			logLine("Studio ---> VS Code: " .. formatChangeSummary(change))
		end
	end

	local payload = { changes = changes }
	if silentLog then
		payload.silentLog = true
	end
	local body = HttpService:JSONEncode(payload)
	local success, err = pcall(function()
		HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
	end)
	if not success then
		warn(LOG_PREFIX .. " error: failed to send changes: " .. tostring(err))
	end
end

local function pollForChanges()
	local pollUrl = getBaseUrl() .. "/vscode-changes"
	local success, response = pcall(function()
		return HttpService:GetAsync(pollUrl, true)
	end)

	if not success then
		-- Normal when the VS Code server stops; avoid spam during disconnect (ConnectFail, etc.).
		return nil
	end

	local data = HttpService:JSONDecode(response)
	if data and data.cursorMode ~= nil then
		Config.CURSOR_MODE = data.cursorMode == true
	end
	if data and data.changes and #data.changes > 0 then
		if changeDetector then
			changeDetector:suppress()
		end
		for _, change in ipairs(data.changes) do
			-- Free this path for new Studio instances after VS Code delete/rename (see filterFlushCreates).
			if change.type == "delete" and type(change.instancePath) == "string" then
				suppressedVscodeCreatePaths[change.instancePath] = nil
			elseif change.type == "rename" and type(change.instancePath) == "string" then
				suppressedVscodeCreatePaths[change.instancePath] = nil
			end
			logLine("VS Code ---> Studio: " .. formatChangeSummary(change))
			Deserializer.applyChange(change)
		end
		-- Non–cursor mode: echo full instance snapshot from Studio (engine defaults) so VS Code can write init.meta.json + scripts.
		if not Config.CURSOR_MODE then
			local echoChanges = {}
			for _, change in ipairs(data.changes) do
				if change.type == "create" then
					local inst = Deserializer.resolveInstancePath(change.instancePath)
					if inst then
						local dotPath = Serializer.getInstanceDotPath(inst)
						suppressedVscodeCreatePaths[dotPath] = true
						suppressedVscodeCreatePaths[change.instancePath] = true
						local full = Serializer.serializeInstance(inst)
						if full then
							table.insert(echoChanges, {
								type = "update",
								instancePath = dotPath,
								instanceData = full,
								timestamp = os.clock(),
							})
						end
					end
				end
			end
			if #echoChanges > 0 then
				sendStudioChanges(echoChanges, true)
			end
		end
		if changeDetector then
			-- Instances created while suppressed never hit DescendantAdded; register paths for correct delete/rename paths.
			changeDetector:catchUpUntrackedDescendants()
			for _ = 1, HEARTBEATS_BEFORE_UNSUPPRESS do
				RunService.Heartbeat:Wait()
			end
			changeDetector:unsuppress()
		end
	end

	return data
end

local function startPolling()
	polling = true
	task.spawn(function()
		while polling and connected do
			pollForChanges()

			if changeDetector then
				local studioChanges = filterFlushCreates(changeDetector:flushChanges(), suppressedVscodeCreatePaths)
				studioChanges = dedupeUpdatesShadowedByCreatesInBatch(studioChanges)
				if #studioChanges > 0 then
					sendStudioChanges(studioChanges)
				end
			end

			task.wait(Config.POLL_INTERVAL)
		end
	end)
end

local function stopPolling()
	polling = false
end

local function stopPingLoop()
	pingAlive = false
end

--- @param silent boolean if true, omit user-visible errors for failed connect (background retries)
--- @param quietLog boolean if true, omit the disconnect print (workspace reload / session reset handoff)
local function disconnect(silent, quietLog)
	stopPingLoop()
	if not connected then
		stopPolling()
		if changeDetector then
			changeDetector:stopTracking()
			changeDetector = nil
		end
		return
	end

	stopPolling()

	if changeDetector then
		changeDetector:stopTracking()
		changeDetector = nil
	end

	pcall(function()
		HttpService:PostAsync(
			getBaseUrl() .. "/disconnect",
			HttpService:JSONEncode({ sessionId = sessionId }),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	connected = false
	sessionId = nil
	suppressedVscodeCreatePaths = {}
	if quietLog ~= true then
		local label = lastConnectDisplayName or (game.Name or "Unnamed")
		lastConnectDisplayName = nil
		logLine("Disconnected (" .. label .. ")")
	end
	if not silent then
		UI.showNotification("Disconnected from VS Code.")
	end
end

--- End Play Mode without tearing down the VS Code HTTP server (soft disconnect).
local function disconnectPlayMode()
	stopPingLoop()
	stopPolling()
	if changeDetector then
		changeDetector:stopTracking()
		changeDetector = nil
	end
	if connected and sessionId then
		pcall(function()
			HttpService:PostAsync(
				getBaseUrl() .. "/disconnect",
				HttpService:JSONEncode({ sessionId = sessionId, soft = true }),
				Enum.HttpContentType.ApplicationJson
			)
		end)
	end
	connected = false
	sessionId = nil
	suppressedVscodeCreatePaths = {}
	logLine("Sync paused (Play Mode). VS Code keeps running; will resume when you stop play.")
end

local function startPingLoop()
	stopPingLoop()
	pingAlive = true
	task.spawn(function()
		while pingAlive and connected and watcherAlive do
			local ok = pcall(function()
				HttpService:GetAsync(getBaseUrl() .. "/ping", true)
			end)
			if not ok then
				if connected and pingAlive then
					disconnect(true, withinHandoffGrace())
				end
				break
			end
			task.wait(Config.STUDIO_PING_INTERVAL)
		end
	end)
end

--- @param silent boolean if true, omit connection-failed toast (used while polling until server is up)
local function connect(silent)
	if connected then
		return
	end
	if RunService:IsRunning() then
		return
	end

	local placeId = game.PlaceId or 0
	local placeName = game.Name or "Unnamed"
	local experienceName = placeName
	local structureHash = ""
	if placeId == 0 then
		local parts = {}
		for _, serviceName in ipairs(Config.SYNCED_SERVICES) do
			local service = game:FindService(serviceName)
			if service then
				table.insert(parts, serviceName .. ":" .. tostring(#service:GetChildren()))
			end
		end
		local str = table.concat(parts, "|")
		local h = 0
		for i = 1, #str do
			h = (h * 31 + string.byte(str, i)) % 2147483647
		end
		structureHash = tostring(math.abs(h))
	else
		local ok, uniResp = pcall(function()
			return HttpService:GetAsync("https://apis.roblox.com/universes/v1/places/" .. tostring(placeId) .. "/universe")
		end)
		if ok and uniResp then
			local uniData = HttpService:JSONDecode(uniResp)
			if uniData and uniData.universeId then
				local ok2, gameResp = pcall(function()
					return HttpService:GetAsync("https://games.roblox.com/v1/games?universeIds=" .. tostring(uniData.universeId))
				end)
				if ok2 and gameResp then
					local gameData = HttpService:JSONDecode(gameResp)
					if gameData and gameData.data and gameData.data[1] and gameData.data[1].name then
						experienceName = gameData.data[1].name
					end
				end
			end
		end
	end

	local connectUrl = getBaseUrl() .. "/connect"
	local connectStartedAt = os.clock()
	local allowConnectBanner = lastStudioConnectBannerAt == 0
		or (connectStartedAt - lastStudioConnectBannerAt) >= STUDIO_CONNECT_BANNER_COOLDOWN_SEC
	local success, response = pcall(function()
		return HttpService:PostAsync(
			connectUrl,
			HttpService:JSONEncode({
				version = "1.4.0",
				placeId = placeId,
				placeName = placeName,
				experienceName = experienceName,
				structureHash = structureHash,
			}),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if not success then
		if not silent then
			warn(LOG_PREFIX .. " error: could not connect: " .. tostring(response))
			UI.showNotification("Connection failed. In VS Code run Roblox Sync: Connect to Studio.", true)
		end
		return
	end

	local data = HttpService:JSONDecode(response)
	sessionId = data.sessionId
	connected = true

	changeDetector = ChangeDetector.new()

	if doFullSync() then
		lastFullySyncedAt = os.clock()
		changeDetector:startTracking()
		startPolling()
		startPingLoop()
		if allowConnectBanner then
			lastConnectDisplayName = experienceName
			logLine("Connected (" .. experienceName .. ")")
			lastStudioConnectBannerAt = os.clock()
		end
	else
		connected = false
		sessionId = nil
		changeDetector = nil
		UI.showNotification("Full sync failed.", true)
	end
end

plugin.Unloading:Connect(function()
	watcherAlive = false
	disconnect(true)
end)

-- Poll for VS Code server; auto-connect when it appears; disconnect locally when server stops.
task.spawn(function()
	while watcherAlive do
		if RunService:IsRunning() then
			if connected then
				disconnectPlayMode()
			end
			task.wait(Config.POLL_INTERVAL)
			continue
		end

		local ok, response = pcall(function()
			return HttpService:GetAsync(getBaseUrl() .. "/status", true)
		end)

		if ok and type(response) == "string" and response ~= "" then
			local decOk, data = pcall(function()
				return HttpService:JSONDecode(response)
			end)
			if decOk and type(data) == "table" then
				if type(data.studioPingIntervalSec) == "number" and data.studioPingIntervalSec > 0 then
					Config.STUDIO_PING_INTERVAL = math.clamp(data.studioPingIntervalSec, 3, 30)
				end
				-- After a Cursor/VS Code window reload, the HTTP server comes back with connected=false
				-- while we still have connected=true; reconnect in the same poll cycle.
				-- Only skip the Disconnected log during handoff grace (same as ping / status loss).
				if data.connected == false and connected then
					disconnect(true, withinHandoffGrace())
				end
				if not connected then
					connect(true)
				end
			end
		else
			if connected then
				local g = withinHandoffGrace()
				disconnect(true, g)
			end
		end

		task.wait(Config.POLL_INTERVAL)
	end
end)
