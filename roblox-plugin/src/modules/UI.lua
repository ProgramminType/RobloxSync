local UI = {}

local LOG_PREFIX = "[Roblox Sync]"

function UI.showNotification(text, isWarning)
	-- Plugins cannot use StarterGui:SetCore (must be a LocalScript). Use Studio output only.
	if isWarning then
		warn(LOG_PREFIX .. " " .. text)
	else
		print(LOG_PREFIX .. " " .. text)
	end
end

return UI
