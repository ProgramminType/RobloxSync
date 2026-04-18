local Config = require(script.Parent.Config)
local Serializer = require(script.Parent.Serializer)

local DuplicateSiblingWatcher = {}
DuplicateSiblingWatcher.__index = DuplicateSiblingWatcher

local function ensureUniqueAmongSiblings(instance)
	if not instance or not instance.Parent then
		return
	end
	local baseName = instance.Name
	local hasDupe = false
	for _, sibling in ipairs(instance.Parent:GetChildren()) do
		if sibling ~= instance and sibling.Name == baseName then
			hasDupe = true
			break
		end
	end
	if not hasDupe then
		return
	end
	local occupied = {}
	for _, sibling in ipairs(instance.Parent:GetChildren()) do
		if sibling ~= instance then
			occupied[sibling.Name] = true
		end
	end
	local candidate = Serializer.nextUniqueSiblingName(instance.Name, occupied)
	pcall(function()
		instance.Name = candidate
	end)
end

--- Used by ChangeDetector while syncing so the same rule applies whether or not VS Code is connected.
DuplicateSiblingWatcher.ensureUniqueAmongSiblings = ensureUniqueAmongSiblings

function DuplicateSiblingWatcher.new()
	local self = setmetatable({}, DuplicateSiblingWatcher)
	self._connections = {}
	self._nameConnections = {}
	self._tracking = false
	return self
end

function DuplicateSiblingWatcher:_trackNameCollision(instance)
	if Config.NON_SERIALIZABLE_CLASSES[instance.ClassName] then
		return
	end
	if self._nameConnections[instance] ~= nil then
		return
	end
	local conn = instance.Changed:Connect(function(property)
		if not self._tracking or property ~= "Name" then
			return
		end
		ensureUniqueAmongSiblings(instance)
	end)
	self._nameConnections[instance] = conn
end

function DuplicateSiblingWatcher:_untrackNameCollision(instance)
	local conn = self._nameConnections[instance]
	if conn then
		conn:Disconnect()
		self._nameConnections[instance] = nil
	end
end

--- Runs for the lifetime of the plugin (not tied to VS Code connection).
function DuplicateSiblingWatcher:start()
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
			self:_trackNameCollision(descendant)
		end

		local addedConn = service.DescendantAdded:Connect(function(descendant)
			if not self._tracking then
				return
			end
			ensureUniqueAmongSiblings(descendant)
			self:_trackNameCollision(descendant)
		end)
		table.insert(self._connections, addedConn)

		local removingConn = service.DescendantRemoving:Connect(function(descendant)
			self:_untrackNameCollision(descendant)
		end)
		table.insert(self._connections, removingConn)
	end
end

function DuplicateSiblingWatcher:stop()
	self._tracking = false
	for _, conn in ipairs(self._connections) do
		conn:Disconnect()
	end
	self._connections = {}
	for _, conn in pairs(self._nameConnections) do
		conn:Disconnect()
	end
	self._nameConnections = {}
end

return DuplicateSiblingWatcher
