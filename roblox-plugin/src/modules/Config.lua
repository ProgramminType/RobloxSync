local Config = {}

-- Set from VS Code poll response; defers risky class conversions in cursor mode
Config.CURSOR_MODE = false

-- Icon asset IDs for toolbar buttons (connect.png and disconnect.png uploaded to Roblox)
Config.CONNECT_ICON = "rbxassetid://70940333195048"
Config.DISCONNECT_ICON = "rbxassetid://112124618127933"

Config.PORT = 34872
Config.HOST = "http://127.0.0.1"
Config.POLL_INTERVAL = 0.3
-- How often to hit /api/ping while connected (server may suggest a value via /api/status).
Config.STUDIO_PING_INTERVAL = 8
Config.DEBOUNCE_TIME = 0.2

Config.SYNCED_SERVICES = {
	"Workspace",
	"Players",
	"Lighting",
	"MaterialService",
	"ReplicatedFirst",
	"ReplicatedStorage",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"StarterPack",
	"StarterPlayer",
	"SoundService",
	"Teams",
	"TextChatService",
}

Config.SCRIPT_EXTENSIONS = {
	Script = ".server.lua",
	LocalScript = ".client.lua",
	ModuleScript = ".lua",
}

Config.IGNORED_PROPERTIES = {
	Name = true,
	ClassName = true,
	Archivable = true,
	DataCost = true,
	RobloxLocked = true,
}

Config.NON_SERIALIZABLE_CLASSES = {
}

return Config
