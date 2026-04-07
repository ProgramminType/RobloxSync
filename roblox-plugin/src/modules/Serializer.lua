local Config = require(script.Parent.Config)
local PropertyHandler = require(script.Parent.PropertyHandler)
local PropertyDatabase = require(script.Parent.PropertyDatabase)

local Serializer = {}
Serializer.skipDuplicates = false

local _propCache = {}

local function getPropertyList(className)
	if _propCache[className] then
		return _propCache[className]
	end

	local props = {}
	local seen = {}
	local current = className

	while current do
		local entry = PropertyDatabase.data[current]
		if not entry then
			break
		end
		for _, prop in ipairs(entry.props) do
			if not seen[prop] then
				seen[prop] = true
				table.insert(props, prop)
			end
		end
		current = entry.super
	end

	_propCache[className] = props
	return props
end

--- Dot path from game child through instance (e.g. Workspace.Part), matching VS Code folder paths.
function Serializer.getInstanceDotPath(instance)
	if not instance then
		return "?"
	end
	local segments = {}
	local current = instance
	while current and current ~= game do
		table.insert(segments, 1, current.Name)
		current = current.Parent
	end
	return table.concat(segments, ".")
end

function Serializer.serializeInstance(instance)
	if Config.NON_SERIALIZABLE_CLASSES[instance.ClassName] then
		return nil
	end

	local data = {
		id = tostring(instance:GetDebugId()),
		className = instance.ClassName,
		name = instance.Name,
		properties = {},
		children = {},
	}

	local propList = getPropertyList(instance.ClassName)
	for _, propName in ipairs(propList) do
		if Config.IGNORED_PROPERTIES[propName] then
			continue
		end
		if propName == "Source" then
			if instance.ClassName == "Script" or instance.ClassName == "LocalScript" or instance.ClassName == "ModuleScript" then
				data.properties["Source"] = instance.Source
			end
			continue
		end
		local success, value = pcall(function()
			return (instance :: any)[propName]
		end)
		if success and value ~= nil then
			local serialized = PropertyHandler.serializeValue(value)
			if serialized ~= nil then
				data.properties[propName] = serialized
			end
		end
	end

	if Serializer.skipDuplicates then
		local nameCounts = {}
		for _, child in ipairs(instance:GetChildren()) do
			if not Config.NON_SERIALIZABLE_CLASSES[child.ClassName] then
				nameCounts[child.Name] = (nameCounts[child.Name] or 0) + 1
			end
		end

		for _, child in ipairs(instance:GetChildren()) do
			if nameCounts[child.Name] and nameCounts[child.Name] > 1 then
				warn("[Roblox Sync] error: skipping duplicate " .. child:GetFullName())
			else
				local childData = Serializer.serializeInstance(child)
				if childData then
					table.insert(data.children, childData)
				end
			end
		end
	else
		local usedNames = {}
		for _, child in ipairs(instance:GetChildren()) do
			local childData = Serializer.serializeInstance(child)
			if childData then
				local baseName = childData.name
				if usedNames[baseName] then
					local n = usedNames[baseName] + 1
					usedNames[baseName] = n
					local newName = baseName .. "_" .. tostring(n)
					childData.name = newName
					pcall(function() child.Name = newName end)
				else
					usedNames[baseName] = 1
				end
				table.insert(data.children, childData)
			end
		end
	end

	return data
end

function Serializer.serializeChange(changeType, instance, property, oldValue)
	local change = {
		type = changeType,
		instancePath = Serializer.getInstanceDotPath(instance),
		timestamp = os.clock(),
	}

	if changeType == "create" then
		change.instanceData = Serializer.serializeInstance(instance)
	elseif changeType == "update" and property then
		change.property = property
		local success, value = pcall(function()
			return (instance :: any)[property]
		end)
		if success then
			change.value = PropertyHandler.serializeValue(value)
		end
	elseif changeType == "delete" then
		-- Only need the path
	end

	return change
end

return Serializer
