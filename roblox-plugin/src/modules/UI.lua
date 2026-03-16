local UI = {}

local StarterGui = game:GetService("StarterGui")

function UI.showNotification(text, isWarning)
	if isWarning then
		warn("[RobloxSync] " .. text)
	else
		print("[RobloxSync] " .. text)
	end

	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "Roblox Studio Sync",
			Text = text,
			Duration = 4,
		})
	end)
end

return UI
