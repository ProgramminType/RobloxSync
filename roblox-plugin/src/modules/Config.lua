local Config = {}

-- Icon asset IDs for toolbar buttons (connect.png and disconnect.png uploaded to Roblox)
Config.CONNECT_ICON = "rbxassetid://70940333195048"
Config.DISCONNECT_ICON = "rbxassetid://112124618127933"

Config.PORT = 34872
Config.HOST = "http://127.0.0.1"
Config.POLL_INTERVAL = 0.3
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
