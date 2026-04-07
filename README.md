# Roblox Sync

**Bidirectional real-time sync between Roblox Studio and VS Code.** Edit your entire game—scripts, instances, and properties—directly from your editor and see changes instantly in Studio. Works with VS Code and Cursor.

## Features

- **Real-time bidirectional sync** — Changes in Studio appear in VS Code; edits in VS Code update Studio
- **Full instance tree** — Scripts, Parts, UI, services, and all properties sync automatically
- **Folder-based workflow** — Every instance is a folder with `init.meta.json`; scripts use `init.server.lua`, `init.client.lua`, or `init.lua`
- **Persistent workspaces** — Workspaces are keyed by Place ID, so Cursor chat and history follow your game
- **Create from VS Code** — New folders with class names (e.g. `Part`, `LocalScript`) create instances with defaults
- **Protected services** — Cannot delete Workspace, Players, or other core services from the file explorer

## Quick Start

### 1. Install the VS Code Extension

**Easiest:** Install the pre-built `.vsix` from the [Releases](https://github.com/ProgramminType/RobloxSync/releases) page:

```bash
code --install-extension roblox-sync-0.1.0.vsix
```

Or in Cursor:

```bash
cursor --install-extension roblox-sync-0.1.0.vsix
```

Alternatively, open the Extensions view (Ctrl+Shift+X), click the **⋯** menu, choose **Install from VSIX**, and select the `.vsix` file.

### 2. Install the Studio Plugin

Run **Roblox Sync: Install Studio Plugin** from the command palette (Ctrl+Shift+P). This copies the plugin into your Roblox plugins folder.

### 3. Connect

1. Run **Roblox Sync: Connect to Studio** in VS Code or Cursor (Command Palette: Ctrl+Shift+P)
2. Open Roblox Studio and enable **Allow HTTP Requests** in Game Settings → Security
3. Click **Connect** in the Roblox Sync toolbar

Your game opens as a workspace. Edit files and folders; changes sync in real time.

The sync server stops when Studio disconnects, after Studio inactivity (see settings), or when you close the synced workspace window. There is no separate “stop server” command.

## File Format

| Roblox Instance | File System |
|-----------------|-------------|
| Any instance | `InstanceName/` (folder) |
| Properties | `InstanceName/init.meta.json` |
| Script | `InstanceName/init.server.lua` |
| LocalScript | `InstanceName/init.client.lua` |
| ModuleScript | `InstanceName/init.lua` |

Each `init.meta.json` contains `className` and `properties`. The folder name is the instance name.

## Commands

| Command | Description |
|---------|-------------|
| **Roblox Sync: Connect to Studio** | Start listening for the Studio plugin; a workspace opens after Studio connects and full sync completes |
| **Roblox Sync: Install Studio Plugin** | Copy the plugin to `%LOCALAPPDATA%\Roblox\Plugins` |
| **Roblox Sync: Enable Cursor Mode** | Shown in the palette when Cursor mode is off; use named folders plus `init.meta.json` with `className` before instances sync |
| **Roblox Sync: Disable Cursor Mode** | Shown when Cursor mode is on; toggles back to class-named folders creating instances with defaults |

Enable and Disable Cursor Mode are the same toggle; only one appears at a time in the command palette.

## Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| `robloxSync.port` | `34872` | HTTP server port |
| `robloxSync.projectPath` | `""` | Subdirectory for synced files (empty = workspace root) |
| `robloxSync.pollInterval` | `0.3` | Poll interval in seconds |

## Project Structure

```
├── vscode-extension/     # VS Code extension (TypeScript)
│   ├── src/
│   ├── media/            # Extension icon
│   └── resources/        # API dump, bundled plugin
├── roblox-plugin/        # Roblox Studio plugin (Luau)
│   ├── src/
│   └── RobloxStudioSync.server.lua
```

## Building from Source

To build the extension yourself:

```bash
cd vscode-extension
npm install
npm run build
npx @vscode/vsce package --allow-missing-repository
```

This writes `roblox-sync-0.1.0.vsix` in `vscode-extension/`. Install it from that folder, for example:

```bash
cursor --install-extension roblox-sync-0.1.0.vsix --force
```

## License

This project is licensed under the **Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)** license. You may fork, modify, and use the software for non-commercial purposes with attribution. See [LICENSE.txt](LICENSE.txt) for details.

## Contributing

Contributions are welcome. Please open an issue or pull request on GitHub.
