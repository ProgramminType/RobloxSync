local HttpService = game:GetService("HttpService")
local Config = require(script.Parent.Config)

local HttpClient = {}

function HttpClient.getBaseUrl()
	return Config.HOST .. ":" .. tostring(Config.PORT) .. "/api"
end

function HttpClient.get(endpoint)
	local url = HttpClient.getBaseUrl() .. endpoint
	local success, response = pcall(function()
		return HttpService:GetAsync(url, true)
	end)
	if success then
		return true, HttpService:JSONDecode(response)
	end
	return false, response
end

function HttpClient.post(endpoint, data)
	local url = HttpClient.getBaseUrl() .. endpoint
	local body = HttpService:JSONEncode(data)
	local success, response = pcall(function()
		return HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
	end)
	if success then
		local decodeSuccess, decoded = pcall(function()
			return HttpService:JSONDecode(response)
		end)
		if decodeSuccess then
			return true, decoded
		end
		return true, response
	end
	return false, response
end

return HttpClient
