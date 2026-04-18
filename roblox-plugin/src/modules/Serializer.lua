local Config = require(script.Parent.Config)
local PropertyHandler = require(script.Parent.PropertyHandler)
local PropertyDatabase = require(script.Parent.PropertyDatabase)

local Serializer = {}
--- When false, duplicate sibling names only get unique names in the serialized tree (full sync); instances in Studio are not renamed.
Serializer.renameLiveInstancesForDuplicateNames = true

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

--- Stem + numeric suffix for sibling dedup: `Part` / `Part1` / `Part2` (compact) or legacy `Part_2`.
--- Unnumbered name counts as index 1.
function Serializer.stemAndSuffixIndex(name)
	local stemU, numStr = string.match(name, "^(.+)_([0-9]+)$")
	if stemU and numStr then
		return stemU, tonumber(numStr) or 1
	end
	local i = #name
	while i >= 1 do
		local c = string.byte(name, i)
		if c < 48 or c > 57 then
			break
		end
		i = i - 1
	end
	if i < #name and i >= 1 then
		local stem = string.sub(name, 1, i)
		local run = string.sub(name, i + 1)
		if stem ~= "" and run ~= "" then
			return stem, tonumber(run) or 1
		end
	end
	return name, 1
end

--- Next sibling name not in `occupied` (e.g. Part + Part → Part2; Part2 + Part2 → Part3). Uses Part2 not Part_2.
function Serializer.nextUniqueSiblingName(baseName, occupied)
	local stem = Serializer.stemAndSuffixIndex(baseName)
	local maxN = 0
	for occName, _ in pairs(occupied) do
		local s, idx = Serializer.stemAndSuffixIndex(occName)
		if s == stem then
			maxN = math.max(maxN, idx)
		end
	end
	local n = maxN + 1
	while true do
		local candidate = stem .. tostring(n)
		if not occupied[candidate] then
			return candidate
		end
		n = n + 1
	end
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

	local occupied: { [string]: boolean } = {}
	local renameLive = Serializer.renameLiveInstancesForDuplicateNames == true
	for _, child in ipairs(instance:GetChildren()) do
		local childData = Serializer.serializeInstance(child)
		if childData then
			local baseName = childData.name
			local finalName = baseName
			if occupied[baseName] then
				finalName = Serializer.nextUniqueSiblingName(baseName, occupied)
				childData.name = finalName
				if renameLive then
					pcall(function()
						child.Name = finalName
					end)
				end
			end
			occupied[finalName] = true
			table.insert(data.children, childData)
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
