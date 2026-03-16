local Config = require(script.Parent.Config)
local Serializer = require(script.Parent.Serializer)

local ChangeDetector = {}
ChangeDetector.__index = ChangeDetector

function ChangeDetector.new()
	local self = setmetatable({}, ChangeDetector)
	self._connections = {}
	self._tracking = false
	self._pathCache = {}
	self._structureChanges = {}
	self._pendingUpdates = {}
	-- When true, property changes are ignored (used while applying VS Code changes)
	self._suppressed = false
	return self
end

function ChangeDetector:suppress()
	self._suppressed = true
end

function ChangeDetector:unsuppress()
	self._suppressed = false
end

function ChangeDetector:startTracking()
	if self._tracking then
		return
	end
	self._tracking = true

	for _, serviceName in ipairs(Config.SYNCED_SERVICES) do
		local service = game:FindService(serviceName)
		if not service then
			continue
		end

		for _, descendant in ipairs(service:GetDescendants()) do
			self:_trackInstance(descendant)
		end

		local addedConn = service.DescendantAdded:Connect(function(descendant)
			if not self._tracking then
				return
			end

			-- Dedup: rename if a sibling with the same name already exists
			if descendant.Parent then
				local baseName = descendant.Name
				local hasDupe = false
				for _, sibling in ipairs(descendant.Parent:GetChildren()) do
					if sibling ~= descendant and sibling.Name == baseName then
						hasDupe = true
						break
					end
				end
				if hasDupe then
					local n = 2
					while true do
						local candidate = baseName .. "_" .. tostring(n)
						local taken = false
						for _, sibling in ipairs(descendant.Parent:GetChildren()) do
							if sibling ~= descendant and sibling.Name == candidate then
								taken = true
								break
							end
						end
						if not taken then
							pcall(function() descendant.Name = candidate end)
							break
						end
						n = n + 1
					end
				end
			end

			self:_trackInstance(descendant)

			local change = Serializer.serializeChange("create", descendant)
			table.insert(self._structureChanges, change)
		end)
		table.insert(self._connections, addedConn)

		local removingConn = service.DescendantRemoving:Connect(function(descendant)
			if not self._tracking then
				return
			end

			local cachedPath = self._pathCache[descendant]
			if not cachedPath then
				cachedPath = descendant:GetFullName()
			end

			self:_untrackInstance(descendant)

			local change = {
				type = "delete",
				instancePath = cachedPath,
				timestamp = os.clock(),
			}
			table.insert(self._structureChanges, change)
		end)
		table.insert(self._connections, removingConn)
	end
end

function ChangeDetector:stopTracking()
	self._tracking = false
	for _, conn in ipairs(self._connections) do
		conn:Disconnect()
	end
	self._connections = {}
	self._pathCache = {}
	self._pendingUpdates = {}
	self._structureChanges = {}
end

function ChangeDetector:flushChanges()
	local changes = self._structureChanges
	self._structureChanges = {}

	for _, change in pairs(self._pendingUpdates) do
		table.insert(changes, change)
	end
	self._pendingUpdates = {}

	return changes
end

function ChangeDetector:_trackInstance(instance)
	if Config.NON_SERIALIZABLE_CLASSES[instance.ClassName] then
		return
	end

	self._pathCache[instance] = instance:GetFullName()

	local instanceId = tostring(instance:GetDebugId())

	local conn = instance.Changed:Connect(function(property)
		if not self._tracking or self._suppressed then
			return
		end

		-- Handle renames before IGNORED_PROPERTIES check
		if property == "Name" then
			-- Dedup: check if new name collides with a sibling
			if instance.Parent then
				local newName = instance.Name
				local hasDupe = false
				for _, sibling in ipairs(instance.Parent:GetChildren()) do
					if sibling ~= instance and sibling.Name == newName then
						hasDupe = true
						break
					end
				end
				if hasDupe then
					local baseName = newName
					local n = 2
					while true do
						local candidate = baseName .. "_" .. tostring(n)
						local taken = false
						for _, sibling in ipairs(instance.Parent:GetChildren()) do
							if sibling ~= instance and sibling.Name == candidate then
								taken = true
								break
							end
						end
						if not taken then
							pcall(function() instance.Name = candidate end)
							return
						end
						n = n + 1
					end
				end
			end

			local oldPath = self._pathCache[instance]
			local finalName = instance.Name
			if instance.Parent then
				self._pathCache[instance] = instance:GetFullName()
			end
			if oldPath then
				local change = {
					type = "rename",
					instancePath = oldPath,
					newName = finalName,
					oldName = string.match(oldPath, "[^%.]+$"),
					timestamp = os.clock(),
				}
				table.insert(self._structureChanges, change)
			end
			return
		end

		-- Handle reparenting before IGNORED_PROPERTIES check
		if property == "Parent" then
			local oldPath = self._pathCache[instance]
			if instance.Parent then
				self._pathCache[instance] = instance:GetFullName()
				if oldPath then
					local deleteChange = {
						type = "delete",
						instancePath = oldPath,
						timestamp = os.clock(),
					}
					table.insert(self._structureChanges, deleteChange)
					local createChange = Serializer.serializeChange("create", instance)
					table.insert(self._structureChanges, createChange)
				end
			end
			return
		end

		if Config.IGNORED_PROPERTIES[property] then
			return
		end

		local debounceKey = instanceId .. "." .. property
		local change = Serializer.serializeChange("update", instance, property)
		self._pendingUpdates[debounceKey] = change
	end)

	table.insert(self._connections, conn)
end

function ChangeDetector:_untrackInstance(instance)
	self._pathCache[instance] = nil
end

return ChangeDetector
