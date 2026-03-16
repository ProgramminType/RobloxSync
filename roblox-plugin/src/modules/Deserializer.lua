local Config = require(script.Parent.Config)
local PropertyHandler = require(script.Parent.PropertyHandler)

local Deserializer = {}

local function resolveInstancePath(path)
	local parts = string.split(path, ".")
	if #parts == 0 then
		return nil
	end

	local current = game
	for _, part in ipairs(parts) do
		local child = current:FindFirstChild(part)
		if not child then
			return nil
		end
		current = child
	end
	return current
end

local function getParentFromPath(path)
	local parts = string.split(path, ".")
	if #parts <= 1 then
		return nil, nil
	end

	local parentParts = {}
	for i = 1, #parts - 1 do
		table.insert(parentParts, parts[i])
	end

	local parentPath = table.concat(parentParts, ".")
	local childName = parts[#parts]
	return resolveInstancePath(parentPath), childName
end

local SCRIPT_CLASSES = {
	Script = true,
	LocalScript = true,
	ModuleScript = true,
}

-- Convert a raw JSON value to the correct Roblox type by inspecting
-- the instance's current property type or the value format
local function convertValue(instance, propName, rawValue)
	if rawValue == nil then
		return nil
	end

	-- Strings that look like enum values: "Enum.Material.Plastic" or just "Plastic"
	if type(rawValue) == "string" then
		-- Full enum path: "Enum.Material.Plastic"
		if string.find(rawValue, "^Enum%.") then
			local parts = string.split(rawValue, ".")
			if #parts == 3 then
				local enumType = (Enum :: any)[parts[2]]
				if enumType then
					local item = (enumType :: any)[parts[3]]
					if item then
						return item
					end
				end
			end
		end

		-- Try to match against the current property's enum type
		local ok, currentVal = pcall(function()
			return (instance :: any)[propName]
		end)
		if ok and typeof(currentVal) == "EnumItem" then
			local enumTypeName = tostring(currentVal.EnumType)
			local enumType = (Enum :: any)[enumTypeName]
			if enumType then
				local item = (enumType :: any)[rawValue]
				if item then
					return item
				end
			end
		end

		-- BrickColor check
		if ok and typeof(currentVal) == "BrickColor" then
			return BrickColor.new(rawValue)
		end

		return rawValue
	end

	-- Tables need conversion based on the current property type
	if type(rawValue) == "table" then
		local ok, currentVal = pcall(function()
			return (instance :: any)[propName]
		end)

		if ok and currentVal ~= nil then
			local currentType = typeof(currentVal)

			if currentType == "Vector3" then
				return Vector3.new(rawValue[1] or 0, rawValue[2] or 0, rawValue[3] or 0)
			elseif currentType == "Vector2" then
				return Vector2.new(rawValue[1] or 0, rawValue[2] or 0)
			elseif currentType == "Color3" then
				return Color3.new(rawValue[1] or 0, rawValue[2] or 0, rawValue[3] or 0)
			elseif currentType == "CFrame" then
				if rawValue.pos and rawValue.rot then
					local p = rawValue.pos
					local r = rawValue.rot
					return CFrame.new(
						p[1], p[2], p[3],
						r[1], r[2], r[3],
						r[4], r[5], r[6],
						r[7], r[8], r[9]
					)
				end
			elseif currentType == "UDim" then
				return UDim.new(rawValue[1] or 0, rawValue[2] or 0)
			elseif currentType == "UDim2" then
				return UDim2.new(
					rawValue[1][1] or 0, rawValue[1][2] or 0,
					rawValue[2][1] or 0, rawValue[2][2] or 0
				)
			elseif currentType == "NumberRange" then
				return NumberRange.new(rawValue[1] or 0, rawValue[2] or 0)
			elseif currentType == "Rect" then
				return Rect.new(rawValue[1] or 0, rawValue[2] or 0, rawValue[3] or 0, rawValue[4] or 0)
			elseif currentType == "NumberSequence" then
				local keypoints = {}
				for _, kp in ipairs(rawValue) do
					table.insert(keypoints, NumberSequenceKeypoint.new(kp[1], kp[2], kp[3] or 0))
				end
				return NumberSequence.new(keypoints)
			elseif currentType == "ColorSequence" then
				local keypoints = {}
				for _, kp in ipairs(rawValue) do
					table.insert(keypoints, ColorSequenceKeypoint.new(kp[1], Color3.new(kp[2], kp[3], kp[4])))
				end
				return ColorSequence.new(keypoints)
			elseif currentType == "Font" then
				if rawValue.family then
					return Font.new(
						rawValue.family,
						Enum.FontWeight[rawValue.weight or "Regular"],
						Enum.FontStyle[rawValue.style or "Normal"]
					)
				end
			elseif currentType == "Faces" then
				local faceMap = {}
				for _, f in ipairs(rawValue) do faceMap[f] = true end
				return Faces.new(
					faceMap.Right and Enum.NormalId.Right or nil,
					faceMap.Top and Enum.NormalId.Top or nil,
					faceMap.Back and Enum.NormalId.Back or nil,
					faceMap.Left and Enum.NormalId.Left or nil,
					faceMap.Bottom and Enum.NormalId.Bottom or nil,
					faceMap.Front and Enum.NormalId.Front or nil
				)
			elseif currentType == "Axes" then
				local axisMap = {}
				for _, a in ipairs(rawValue) do axisMap[a] = true end
				return Axes.new(
					axisMap.X and Enum.Axis.X or nil,
					axisMap.Y and Enum.Axis.Y or nil,
					axisMap.Z and Enum.Axis.Z or nil
				)
			elseif currentType == "PhysicalProperties" then
				return PhysicalProperties.new(
					rawValue.density, rawValue.friction, rawValue.elasticity,
					rawValue.frictionWeight, rawValue.elasticityWeight
				)
			end
		end

		-- Fallback: if it looks like a Vector3 array
		if #rawValue == 3 and type(rawValue[1]) == "number" then
			return Vector3.new(rawValue[1], rawValue[2], rawValue[3])
		end
		if #rawValue == 2 and type(rawValue[1]) == "number" then
			return Vector2.new(rawValue[1], rawValue[2])
		end
	end

	return rawValue
end

local function setProperty(instance, propName, rawValue)
	if propName == "Source" and SCRIPT_CLASSES[instance.ClassName] then
		pcall(function()
			instance.Source = rawValue
		end)
		return
	end

	local converted = convertValue(instance, propName, rawValue)
	local success, err = pcall(function()
		(instance :: any)[propName] = converted
	end)
	if not success then
		warn("[RobloxSync] Failed to set " .. propName .. " on " .. instance:GetFullName() .. ": " .. tostring(err))
	end
end

function Deserializer.applyChange(change)
	if change.type == "create" then
		Deserializer.createInstance(change)
	elseif change.type == "update" then
		Deserializer.updateInstance(change)
	elseif change.type == "delete" then
		Deserializer.deleteInstance(change)
	elseif change.type == "rename" then
		Deserializer.renameInstance(change)
	end
end

function Deserializer.createInstance(change)
	if not change.instanceData then
		warn("[RobloxSync] Create change missing instanceData")
		return
	end

	-- If the instance already exists at this path, update it instead of creating a duplicate
	local existing = resolveInstancePath(change.instancePath)
	if existing then
		if change.instanceData.properties then
			for propName, propValue in pairs(change.instanceData.properties) do
				setProperty(existing, propName, propValue)
			end
		end
		return
	end

	local parent, _ = getParentFromPath(change.instancePath)
	if not parent then
		warn("[RobloxSync] Could not find parent for: " .. change.instancePath)
		return
	end

	Deserializer.buildInstanceTree(change.instanceData, parent)
end

function Deserializer.buildInstanceTree(data, parent)
	local success, instance = pcall(function()
		return Instance.new(data.className)
	end)

	if not success then
		warn("[RobloxSync] Could not create instance of class: " .. data.className)
		return nil
	end

	instance.Name = data.name

	for propName, propValue in pairs(data.properties) do
		setProperty(instance, propName, propValue)
	end

	for _, childData in ipairs(data.children) do
		Deserializer.buildInstanceTree(childData, instance)
	end

	instance.Parent = parent
	return instance
end

function Deserializer.updateInstance(change)
	local instance = resolveInstancePath(change.instancePath)
	if not instance then
		warn("[RobloxSync] Could not find instance: " .. change.instancePath)
		return
	end

	if change.instanceData and change.instanceData.className and change.instanceData.className ~= instance.ClassName then
		-- className changed: convert object (destroy old, create new with same name, default properties)
		local parent = instance.Parent
		local preservedName = instance.Name
		instance:Destroy()

		local newClass = change.instanceData.className
		local success, newInstance = pcall(function()
			return Instance.new(newClass)
		end)
		if not success then
			warn("[RobloxSync] Could not convert to class: " .. newClass)
			return
		end

		newInstance.Name = preservedName
		newInstance.Parent = parent
		return
	end

	if change.instanceData then
		if change.instanceData.properties then
			for propName, propValue in pairs(change.instanceData.properties) do
				setProperty(instance, propName, propValue)
			end
		end
	elseif change.property and change.value ~= nil then
		setProperty(instance, change.property, change.value)
	end
end

function Deserializer.deleteInstance(change)
	local instance = resolveInstancePath(change.instancePath)
	if instance then
		instance:Destroy()
	end
end

function Deserializer.renameInstance(change)
	local instance = resolveInstancePath(change.instancePath)
	if instance and change.newName then
		instance.Name = change.newName
	end
end

return Deserializer
