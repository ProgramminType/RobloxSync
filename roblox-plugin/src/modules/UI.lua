local UI = {}

local StarterGui = game:GetService("StarterGui")

function UI.showNotification(text, isWarning)
	-- Output logging is handled in init.server.lua (consistent [Roblox Sync] lines).
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "Roblox Studio Sync",
			Text = text,
			Duration = 4,
		})
	end)
end

return UI
