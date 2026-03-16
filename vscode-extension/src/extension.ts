import * as vscode from "vscode";
import * as path from "path";
import * as fs from "fs";
import * as os from "os";
import { SyncServer } from "./server/index";
import { StatusBarManager } from "./ui/statusBar";
import { FileManager } from "./sync/fileManager";
import { FileWatcher } from "./sync/fileWatcher";
import { ChangeQueue } from "./sync/changeQueue";
import { DEFAULT_PORT } from "./types";

const MARKER_FILE = ".roblox-sync-workspace";
const WORKSPACE_FILE = "RobloxSync.code-workspace";

let server: SyncServer | null = null;
let statusBar: StatusBarManager | null = null;
let isPersistentWorkspace = false;

function getWorkspacesRoot(): string {
  const base = process.env.LOCALAPPDATA || process.env.HOME || os.tmpdir();
  return path.join(base, "RobloxStudioSync", "workspaces");
}

function getWorkspaceId(placeId: number, placeName: string, structureHash: string): string {
  if (placeId > 0) {
    return String(placeId);
  }
  return `unpublished_${structureHash || "default"}`;
}

function sanitizeForPath(name: string): string {
  return name.replace(/[<>:"/\\|?*]/g, "_").trim() || "Unnamed";
}

function ensureWorkspaceFile(workspaceDir: string): string {
  const workspacePath = path.join(workspaceDir, WORKSPACE_FILE);
  const folderName = path.basename(workspaceDir);
  const content = JSON.stringify(
    {
      folders: [{ path: ".", name: folderName }],
      name: "RobloxSync",
      settings: {
        "files.exclude": {
          [WORKSPACE_FILE]: true,
          [MARKER_FILE]: true,
        },
      },
    },
    null,
    2
  );
  fs.writeFileSync(workspacePath, content, "utf-8");
  return workspacePath;
}

export function activate(context: vscode.ExtensionContext) {
  statusBar = new StatusBarManager();
  context.subscriptions.push(statusBar);

  const currentFolder = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
  const workspaceFile = vscode.workspace.workspaceFile?.fsPath;
  const projectPath = currentFolder ?? (workspaceFile ? path.dirname(workspaceFile) : undefined);

  if (projectPath) {
    const markerPath = path.join(projectPath, MARKER_FILE);
    if (fs.existsSync(markerPath)) {
      isPersistentWorkspace = true;
      if (server) {
        return;
      }
      startServer(context, projectPath).catch((err) => {
        console.error("[RobloxSync] Auto-start failed:", err);
      });
    }
  }

  const connectCmd = vscode.commands.registerCommand("robloxSync.connect", async () => {
    if (server) {
      vscode.window.showWarningMessage("Roblox Sync server is already running.");
      return;
    }

    const workspacesRoot = getWorkspacesRoot();
    const currentFolder = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
    const projectPathForCheck =
      currentFolder ?? (vscode.workspace.workspaceFile ? path.dirname(vscode.workspace.workspaceFile.fsPath) : undefined);
    const isPersistentOpen =
      projectPathForCheck &&
      projectPathForCheck.startsWith(workspacesRoot) &&
      fs.existsSync(path.join(projectPathForCheck, MARKER_FILE));

    if (isPersistentOpen && projectPathForCheck) {
      isPersistentWorkspace = true;
      startServer(context, projectPathForCheck).catch((err) => {
        console.error("[RobloxSync] Auto-start failed:", err);
      });
      return;
    }

    const stagingDir = fs.mkdtempSync(path.join(os.tmpdir(), "roblox-sync-"));
    startServer(context, stagingDir).catch((err) => {
      console.error("[RobloxSync] Auto-start failed:", err);
    });
  });

  const disconnectCmd = vscode.commands.registerCommand("robloxSync.disconnect", async () => {
    if (!server) {
      vscode.window.showWarningMessage("No server is running.");
      return;
    }
    await stopAndCleanup();
  });

  const installPluginCmd = vscode.commands.registerCommand("robloxSync.installPlugin", async () => {
    const pluginSource = path.join(context.extensionPath, "resources", "RobloxStudioSync.server.lua");
    if (!fs.existsSync(pluginSource)) {
      vscode.window.showErrorMessage("Bundled plugin file not found. The extension may be corrupted.");
      return;
    }

    const localAppData = process.env.LOCALAPPDATA;
    if (!localAppData) {
      vscode.window.showErrorMessage("Could not find LOCALAPPDATA directory.");
      return;
    }

    const pluginsDir = path.join(localAppData, "Roblox", "Plugins");
    if (!fs.existsSync(pluginsDir)) {
      fs.mkdirSync(pluginsDir, { recursive: true });
    }

    const dest = path.join(pluginsDir, "RobloxStudioSync.server.lua");
    fs.copyFileSync(pluginSource, dest);
    vscode.window.showInformationMessage(`Studio plugin installed to ${dest}`);
  });

  const fullSyncCmd = vscode.commands.registerCommand("robloxSync.fullSync", () => {
    if (!server) {
      vscode.window.showWarningMessage("Start the server first.");
      return;
    }
    vscode.window.showInformationMessage("Full sync will occur when the plugin next connects.");
  });

  context.subscriptions.push(connectCmd, disconnectCmd, installPluginCmd, fullSyncCmd);
}

async function startServer(context: vscode.ExtensionContext, projectPath: string): Promise<void> {
  const config = vscode.workspace.getConfiguration("robloxSync");
  const port = config.get<number>("port", DEFAULT_PORT);

  if (!fs.existsSync(projectPath)) {
    fs.mkdirSync(projectPath, { recursive: true });
  }

  const changeQueue = new ChangeQueue();
  const fileManager = new FileManager(projectPath, context.extensionPath);
  const fileWatcher = new FileWatcher(projectPath, changeQueue, fileManager);

  const onPluginConnected = (
    placeId: number,
    _placeName: string,
    experienceName: string,
    structureHash: string
  ) => {
    const workspaceId = getWorkspaceId(placeId, experienceName, structureHash);
    const workspaceDir = path.join(getWorkspacesRoot(), workspaceId);
    fs.mkdirSync(workspaceDir, { recursive: true });
    fs.writeFileSync(
      path.join(workspaceDir, MARKER_FILE),
      JSON.stringify({ created: Date.now(), version: "0.1.0" })
    );
    const workspacePath = ensureWorkspaceFile(workspaceDir);

    server?.setProjectPath(workspaceDir, context.extensionPath);
    isPersistentWorkspace = true;

    const workspaceUri = vscode.Uri.file(workspacePath);
    vscode.commands.executeCommand("vscode.openFolder", workspaceUri, false);
  };

  server = new SyncServer(port, fileManager, changeQueue, fileWatcher, onPluginConnected);
  try {
    await server.start();
    statusBar!.setConnected(port);
    fileWatcher.start();
    vscode.window.showInformationMessage(`Roblox Sync server running on port ${port}. Connect from Studio to open your game.`);
  } catch (err: unknown) {
    const msg = err instanceof Error ? err.message : String(err);
    vscode.window.showErrorMessage(`Failed to start server: ${msg}`);
    server = null;
  }
}

async function stopAndCleanup(): Promise<void> {
  server?.getFileWatcher()?.stop();

  if (server) {
    await server.stop();
    server = null;
  }

  statusBar?.setDisconnected();
  isPersistentWorkspace = false;
  vscode.window.showInformationMessage("Roblox Sync server stopped.");
}

export function deactivate() {
  server?.getFileWatcher()?.stop();
  return server?.stop();
}
