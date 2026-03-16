local Config = require(script.modules.Config)

local toolbar = plugin:CreateToolbar("Roblox Sync")
local connectButton = toolbar:CreateButton(
	"Connect",
	"Connect to Roblox Sync server",
	Config.CONNECT_ICON
)
local disconnectButton = toolbar:CreateButton(
	"Disconnect",
	"Disconnect from Roblox Sync server",
	Config.DISCONNECT_ICON
)
local HttpClient = require(script.modules.HttpClient)
local Serializer = require(script.modules.Serializer)
local Deserializer = require(script.modules.Deserializer)
local ChangeDetector = require(script.modules.ChangeDetector)
local PropertyHandler = require(script.modules.PropertyHandler)
local UI = require(script.modules.UI)

local HttpService = game:GetService("HttpService")

local connected = false
local polling = false
local sessionId = nil
local changeDetector = nil

local function getBaseUrl()
	return Config.HOST .. ":" .. tostring(Config.PORT) .. "/api"
end

local function checkHttpEnabled()
	local success = pcall(function()
		HttpService:GetAsync(getBaseUrl() .. "/status")
	end)
	return success
end

local function doFullSync()
	Serializer.skipDuplicates = true

	local tree = {}
	for _, serviceName in ipairs(Config.SYNCED_SERVICES) do
		local service = game:FindService(serviceName)
		if service then
			table.insert(tree, Serializer.serializeInstance(service))
		end
	end

	Serializer.skipDuplicates = false

	local body = HttpService:JSONEncode({ tree = tree })
	local success, err = pcall(function()
		HttpService:PostAsync(getBaseUrl() .. "/full-sync", body, Enum.HttpContentType.ApplicationJson)
	end)

	if not success then
		warn("[RobloxSync] Full sync failed: " .. tostring(err))
		return false
	end
	return true
end

local function pollForChanges()
	local success, response = pcall(function()
		return HttpService:GetAsync(getBaseUrl() .. "/vscode-changes", true)
	end)

	if not success then
		return nil
	end

	local data = HttpService:JSONDecode(response)
	if data and data.changes and #data.changes > 0 then
		if changeDetector then
			changeDetector:suppress()
		end
		for _, change in ipairs(data.changes) do
			Deserializer.applyChange(change)
		end
		if changeDetector then
			changeDetector:unsuppress()
		end
	end

	return data
end

local function sendStudioChanges(changes)
	if #changes == 0 then
		return
	end

	for _, change in ipairs(changes) do
		print("[RobloxSync] Sending " .. change.type .. ": " .. (change.instancePath or "?"))
	end

	local body = HttpService:JSONEncode({ changes = changes })
	local success, err = pcall(function()
		HttpService:PostAsync(getBaseUrl() .. "/studio-changes", body, Enum.HttpContentType.ApplicationJson)
	end)
	if not success then
		warn("[RobloxSync] Failed to send changes: " .. tostring(err))
	end
end

local function startPolling()
	polling = true
	task.spawn(function()
		while polling and connected do
			pollForChanges()

			if changeDetector then
				local studioChanges = changeDetector:flushChanges()
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

local function connect()
	if connected then
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

	local success, response = pcall(function()
		return HttpService:PostAsync(
			getBaseUrl() .. "/connect",
			HttpService:JSONEncode({
				version = "0.1.0",
				placeId = placeId,
				placeName = placeName,
				experienceName = experienceName,
				structureHash = structureHash,
			}),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if not success then
		warn("[RobloxSync] Could not connect to VS Code server: " .. tostring(response))
		UI.showNotification("Connection failed. Make sure the VS Code server is running.", true)
		return
	end

	local data = HttpService:JSONDecode(response)
	sessionId = data.sessionId
	connected = true

	changeDetector = ChangeDetector.new()

	if doFullSync() then
		changeDetector:startTracking()
		startPolling()
		UI.showNotification("Connected to VS Code!")
	else
		connected = false
		sessionId = nil
		UI.showNotification("Full sync failed.", true)
	end
end

local function disconnect()
	if not connected then
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
	UI.showNotification("Disconnected from VS Code.")
end

connectButton.Click:Connect(function()
	connect()
end)

disconnectButton.Click:Connect(function()
	disconnect()
end)

plugin.Unloading:Connect(function()
	disconnect()
end)
