local PropertyHandler = {}

function PropertyHandler.serializeValue(value)
	local t = typeof(value)

	if t == "string" or t == "number" or t == "boolean" then
		return value
	elseif t == "nil" then
		return nil
	elseif t == "Vector3" then
		return { value.X, value.Y, value.Z }
	elseif t == "Vector2" then
		return { value.X, value.Y }
	elseif t == "CFrame" then
		local components = { value:GetComponents() }
		return {
			pos = { components[1], components[2], components[3] },
			rot = {
				components[4], components[5], components[6],
				components[7], components[8], components[9],
				components[10], components[11], components[12],
			},
		}
	elseif t == "Color3" then
		return { value.R, value.G, value.B }
	elseif t == "BrickColor" then
		return value.Name
	elseif t == "UDim" then
		return { value.Scale, value.Offset }
	elseif t == "UDim2" then
		return {
			{ value.X.Scale, value.X.Offset },
			{ value.Y.Scale, value.Y.Offset },
		}
	elseif t == "EnumItem" then
		return tostring(value)
	elseif t == "NumberRange" then
		return { value.Min, value.Max }
	elseif t == "NumberSequence" then
		local keypoints = {}
		for _, kp in ipairs(value.Keypoints) do
			table.insert(keypoints, { kp.Time, kp.Value, kp.Envelope })
		end
		return keypoints
	elseif t == "ColorSequence" then
		local keypoints = {}
		for _, kp in ipairs(value.Keypoints) do
			table.insert(keypoints, { kp.Time, kp.Value.R, kp.Value.G, kp.Value.B })
		end
		return keypoints
	elseif t == "Rect" then
		return { value.Min.X, value.Min.Y, value.Max.X, value.Max.Y }
	elseif t == "Font" then
		return {
			family = value.Family,
			weight = value.Weight.Name,
			style = value.Style.Name,
		}
	elseif t == "Faces" then
		local faces = {}
		if value.Top then table.insert(faces, "Top") end
		if value.Bottom then table.insert(faces, "Bottom") end
		if value.Left then table.insert(faces, "Left") end
		if value.Right then table.insert(faces, "Right") end
		if value.Front then table.insert(faces, "Front") end
		if value.Back then table.insert(faces, "Back") end
		return faces
	elseif t == "Axes" then
		local axes = {}
		if value.X then table.insert(axes, "X") end
		if value.Y then table.insert(axes, "Y") end
		if value.Z then table.insert(axes, "Z") end
		return axes
	elseif t == "PhysicalProperties" then
		if value then
			return {
				density = value.Density,
				friction = value.Friction,
				elasticity = value.Elasticity,
				frictionWeight = value.FrictionWeight,
				elasticityWeight = value.ElasticityWeight,
			}
		end
		return nil
	elseif t == "Ray" then
		return {
			origin = { value.Origin.X, value.Origin.Y, value.Origin.Z },
			direction = { value.Direction.X, value.Direction.Y, value.Direction.Z },
		}
	elseif t == "Instance" then
		return { _ref = value:GetFullName() }
	else
		return nil
	end
end

function PropertyHandler.deserializeValue(value, typeName)
	if typeName == "string" or typeName == "int" or typeName == "int64"
		or typeName == "float" or typeName == "double"
		or typeName == "bool" or typeName == "boolean" then
		return value
	end

	if typeName == "Vector3" and type(value) == "table" then
		return Vector3.new(value[1], value[2], value[3])
	elseif typeName == "Vector2" and type(value) == "table" then
		return Vector2.new(value[1], value[2])
	elseif typeName == "CFrame" and type(value) == "table" then
		local p = value.pos
		local r = value.rot
		return CFrame.new(p[1], p[2], p[3], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9])
	elseif typeName == "Color3" and type(value) == "table" then
		return Color3.new(value[1], value[2], value[3])
	elseif typeName == "BrickColor" and type(value) == "string" then
		return BrickColor.new(value)
	elseif typeName == "UDim" and type(value) == "table" then
		return UDim.new(value[1], value[2])
	elseif typeName == "UDim2" and type(value) == "table" then
		return UDim2.new(value[1][1], value[1][2], value[2][1], value[2][2])
	elseif typeName == "NumberRange" and type(value) == "table" then
		return NumberRange.new(value[1], value[2])
	elseif typeName == "NumberSequence" and type(value) == "table" then
		local keypoints = {}
		for _, kp in ipairs(value) do
			table.insert(keypoints, NumberSequenceKeypoint.new(kp[1], kp[2], kp[3]))
		end
		return NumberSequence.new(keypoints)
	elseif typeName == "ColorSequence" and type(value) == "table" then
		local keypoints = {}
		for _, kp in ipairs(value) do
			table.insert(keypoints, ColorSequenceKeypoint.new(kp[1], Color3.new(kp[2], kp[3], kp[4])))
		end
		return ColorSequence.new(keypoints)
	elseif typeName == "Rect" and type(value) == "table" then
		return Rect.new(value[1], value[2], value[3], value[4])
	elseif typeName == "Font" and type(value) == "table" then
		return Font.new(value.family, Enum.FontWeight[value.weight], Enum.FontStyle[value.style])
	elseif typeName == "Faces" and type(value) == "table" then
		local faceMap = {}
		for _, f in ipairs(value) do faceMap[f] = true end
		return Faces.new(
			faceMap.Right and Enum.NormalId.Right or nil,
			faceMap.Top and Enum.NormalId.Top or nil,
			faceMap.Back and Enum.NormalId.Back or nil,
			faceMap.Left and Enum.NormalId.Left or nil,
			faceMap.Bottom and Enum.NormalId.Bottom or nil,
			faceMap.Front and Enum.NormalId.Front or nil
		)
	elseif typeName == "Axes" and type(value) == "table" then
		local axisMap = {}
		for _, a in ipairs(value) do axisMap[a] = true end
		return Axes.new(
			axisMap.X and Enum.Axis.X or nil,
			axisMap.Y and Enum.Axis.Y or nil,
			axisMap.Z and Enum.Axis.Z or nil
		)
	elseif typeName == "PhysicalProperties" and type(value) == "table" then
		return PhysicalProperties.new(
			value.density, value.friction, value.elasticity,
			value.frictionWeight, value.elasticityWeight
		)
	end

	-- For Enum types passed as strings like "Enum.Material.Plastic"
	if type(value) == "string" and string.find(value, "^Enum%.") then
		local parts = string.split(value, ".")
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

	return value
end

function PropertyHandler.getSerializableProperties(instance)
	local Config = require(script.Parent.Config)
	local properties = {}
	local success, apiProperties = pcall(function()
		local className = instance.ClassName
		local result = {}

		-- Use pcall to safely read each property
		-- We rely on a known property list embedded in the serializer
		return result
	end)

	return properties
end

return PropertyHandler
