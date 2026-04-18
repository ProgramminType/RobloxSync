import * as vscode from "vscode";
import * as path from "path";
import * as fs from "fs";
import * as os from "os";
import { SyncServer } from "./server/index";
import { StatusBarManager } from "./ui/statusBar";
import { UI } from "./ui/messages";
import * as syncLog from "./syncLog";
import { FileManager } from "./sync/fileManager";
import { FileWatcher } from "./sync/fileWatcher";
import { ChangeQueue } from "./sync/changeQueue";
import { DEFAULT_PORT } from "./types";

const MARKER_FILE = ".roblox-sync-workspace";
const WORKSPACE_FILE = "RobloxSync.code-workspace";
const CURSORRULES_SOURCE = "cursorrules";
/** One-shot: set right before vscode.openFolder so the reloaded window can restart the HTTP server (deactivate always stops it). */
const RESUME_SERVER_PROJECT_KEY = "robloxSync.resumeServerProjectPath";

let server: SyncServer | null = null;
let statusBar: StatusBarManager | null = null;
let processShutdownHooksRegistered = false;
let resumeServerInFlight = false;
let resumeWaitLogThrottle = 0;

function pathsEqualFs(a: string, b: string): boolean {
  const na = path.normalize(path.resolve(a));
  const nb = path.normalize(path.resolve(b));
  if (process.platform === "win32") {
    return na.toLowerCase() === nb.toLowerCase();
  }
  return na === nb;
}

/** Folder URI and parent of .code-workspace file (they can differ briefly while the window reloads). */
function getWorkspaceRootCandidates(): string[] {
  const folder = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
  const wf = vscode.workspace.workspaceFile?.fsPath;
  const wfDir = wf ? path.dirname(wf) : undefined;
  const out: string[] = [];
  if (folder) {
    out.push(folder);
  }
  if (wfDir && !out.some((p) => pathsEqualFs(p, wfDir))) {
    out.push(wfDir);
  }
  return out;
}

function workspaceMatchesResumeProject(resumePath: string): boolean {
  const candidates = getWorkspaceRootCandidates();
  return candidates.some((p) => pathsEqualFs(p, resumePath));
}

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
          ".cursorrules": true,
        },
      },
    },
    null,
    2
  );
  fs.writeFileSync(workspacePath, content, "utf-8");
  return workspacePath;
}

function copyCursorrulesToWorkspace(extensionPath: string, workspaceDir: string): void {
  const source = path.join(extensionPath, "resources", CURSORRULES_SOURCE);
  const dest = path.join(workspaceDir, ".cursorrules");
  if (fs.existsSync(source)) {
    fs.copyFileSync(source, dest);
  }
}

function refreshCursorModeContext(): void {
  const on = vscode.workspace.getConfiguration("robloxSync").get<boolean>("cursorMode", false);
  void vscode.commands.executeCommand("setContext", "robloxSync.cursorModeOn", on);
}

function registerProcessShutdownHooks(): void {
  if (processShutdownHooksRegistered) {
    return;
  }
  processShutdownHooksRegistered = true;

  const shutdown = () => {
    void stopAndCleanup({ suppressUserMessage: true });
  };

  process.on("SIGTERM", shutdown);
  process.on("SIGINT", shutdown);
  process.on("SIGHUP", shutdown);
  process.on("disconnect", shutdown);

  process.on("exit", () => {
    server?.forceCloseHttpSync();
  });
}

export function activate(context: vscode.ExtensionContext) {
  registerProcessShutdownHooks();

  refreshCursorModeContext();

  statusBar = new StatusBarManager();
  context.subscriptions.push(statusBar);

  context.subscriptions.push(
    vscode.workspace.onDidChangeConfiguration((e) => {
      if (e.affectsConfiguration("robloxSync.cursorMode")) {
        refreshCursorModeContext();
      }
    })
  );

  void context.globalState.update("robloxSync.pendingWorkspaceOpen", undefined);

  const tryResumeServerAfterFolderReload = () => {
    if (resumeServerInFlight || server) {
      return;
    }
    const resumePath = context.globalState.get<string>(RESUME_SERVER_PROJECT_KEY);
    if (!resumePath) {
      return;
    }
    const candidates = getWorkspaceRootCandidates();
    if (candidates.length === 0) {
      return;
    }
    // Do not clear the resume key on mismatch: right after openFolder the window can still report
    // the *previous* workspace (e.g. temp staging) for a moment; clearing would prevent any restart.
    if (!workspaceMatchesResumeProject(resumePath)) {
      const now = Date.now();
      if (now - resumeWaitLogThrottle > 2500) {
        resumeWaitLogThrottle = now;
        syncLog.line(`resume waiting (workspace not ready yet)`);
      }
      return;
    }
    if (!fs.existsSync(path.join(resumePath, MARKER_FILE))) {
      syncLog.line(`resume abandoned (no workspace marker)`);
      void context.globalState.update(RESUME_SERVER_PROJECT_KEY, undefined);
      return;
    }

    resumeServerInFlight = true;
    void context.globalState.update(RESUME_SERVER_PROJECT_KEY, undefined);
    startServer(context, resumePath)
      .catch((err) => {
        console.error("[RobloxSync] Resume server after workspace reload failed:", err);
        syncLog.errorLine(`resume failed: ${err instanceof Error ? err.message : String(err)}`);
      })
      .finally(() => {
        resumeServerInFlight = false;
      });
  };

  tryResumeServerAfterFolderReload();
  for (const delay of [50, 150, 400, 1200, 2500]) {
    setTimeout(tryResumeServerAfterFolderReload, delay);
  }

  context.subscriptions.push(
    vscode.workspace.onDidChangeWorkspaceFolders(() => {
      if (!vscode.workspace.workspaceFolders?.length) {
        // openFolder(workspaceUri) often fires this with zero folders while the window reloads.
        // Stopping the server here shows a bogus "Workspace disconnected" toast and drops Studio.
        const pendingResume = context.globalState.get<string>(RESUME_SERVER_PROJECT_KEY);
        if (pendingResume) {
          return;
        }
        void stopAndCleanup();
        return;
      }
      tryResumeServerAfterFolderReload();
      setTimeout(tryResumeServerAfterFolderReload, 100);
      setTimeout(tryResumeServerAfterFolderReload, 500);
    })
  );

  const connectCmd = vscode.commands.registerCommand("robloxSync.connect", async () => {
    if (server) {
      vscode.window.showWarningMessage(UI.alreadyConnected);
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
      startServer(context, projectPathForCheck).catch((err) => {
        console.error("[RobloxSync] Start server failed:", err);
      });
      return;
    }

    const stagingDir = fs.mkdtempSync(path.join(os.tmpdir(), "roblox-sync-"));
    startServer(context, stagingDir).catch((err) => {
      console.error("[RobloxSync] Start server failed:", err);
    });
  });

  const installPluginCmd = vscode.commands.registerCommand("robloxSync.installPlugin", async () => {
    const pluginSource = path.join(context.extensionPath, "resources", "RobloxStudioSync.server.lua");
    if (!fs.existsSync(pluginSource)) {
      vscode.window.showErrorMessage(UI.pluginBundledMissing);
      return;
    }

    const localAppData = process.env.LOCALAPPDATA;
    if (!localAppData) {
      vscode.window.showErrorMessage(UI.localAppDataMissing);
      return;
    }

    const pluginsDir = path.join(localAppData, "Roblox", "Plugins");
    if (!fs.existsSync(pluginsDir)) {
      fs.mkdirSync(pluginsDir, { recursive: true });
    }

    const dest = path.join(pluginsDir, "RobloxStudioSync.server.lua");
    fs.copyFileSync(pluginSource, dest);
    vscode.window.showInformationMessage(UI.pluginInstalled(dest));
  });

  const runCursorModeToggle = async () => {
    const config = vscode.workspace.getConfiguration("robloxSync");
    const next = !config.get<boolean>("cursorMode", false);
    await config.update("cursorMode", next, vscode.ConfigurationTarget.Global);
    refreshCursorModeContext();
    vscode.window.showInformationMessage(next ? UI.cursorModeEnabled : UI.cursorModeDisabled);
  };

  const turnOnCursorModeCmd = vscode.commands.registerCommand("robloxSync.turnOnCursorMode", runCursorModeToggle);
  const turnOffCursorModeCmd = vscode.commands.registerCommand("robloxSync.turnOffCursorMode", runCursorModeToggle);

  context.subscriptions.push(connectCmd, installPluginCmd, turnOnCursorModeCmd, turnOffCursorModeCmd);
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
    placeName: string,
    experienceName: string,
    structureHash: string
  ) => {
    const workspaceId = getWorkspaceId(placeId, experienceName, structureHash);
    const workspaceDir = path.join(getWorkspacesRoot(), workspaceId);
    fs.mkdirSync(workspaceDir, { recursive: true });
    fs.writeFileSync(
      path.join(workspaceDir, MARKER_FILE),
      JSON.stringify({ created: Date.now(), version: "1.5.0" })
    );
    copyCursorrulesToWorkspace(context.extensionPath, workspaceDir);
    const workspacePath = ensureWorkspaceFile(workspaceDir);

    server?.setProjectPath(workspaceDir, context.extensionPath);

    const alreadyOnThisProject =
      vscode.workspace.workspaceFolders?.some((f) => pathsEqualFs(f.uri.fsPath, workspaceDir)) === true;
    if (alreadyOnThisProject) {
      void context.globalState.update(RESUME_SERVER_PROJECT_KEY, workspaceDir);
    } else {
      const workspaceUri = vscode.Uri.file(workspacePath);
      void (async () => {
        try {
          await context.globalState.update(RESUME_SERVER_PROJECT_KEY, workspaceDir);
          await vscode.commands.executeCommand("vscode.openFolder", workspaceUri, false);
        } catch (err) {
          console.error("[RobloxSync] openFolder after Studio connect failed:", err);
          void context.globalState.update(RESUME_SERVER_PROJECT_KEY, undefined);
        }
      })();
    }

    syncLog.connected();
  };

  server = new SyncServer(port, fileManager, changeQueue, fileWatcher, onPluginConnected, () => {
    void stopAndCleanup();
  });
  try {
    syncLog.showOutput();
    await server.start();
    statusBar!.setConnected(port);
    fileWatcher.start();
  } catch (err: unknown) {
    const msg = err instanceof Error ? err.message : String(err);
    vscode.window.showErrorMessage(UI.serverStartFailed(msg));
    server = null;
  }
}

async function stopAndCleanup(options?: { suppressUserMessage?: boolean }): Promise<void> {
  if (!server) {
    return;
  }

  server.getFileWatcher()?.stop();
  await server.stop();
  server = null;

  statusBar?.setDisconnected();
  // suppressUserMessage is used for extension deactivation / process shutdown (e.g. openFolder reload).
  // Do not log "Disconnected" there — it reads like Studio dropped the session even though we reconnect immediately.
  if (!options?.suppressUserMessage) {
    syncLog.disconnected();
    vscode.window.showInformationMessage(UI.disconnected);
  }
}

export function deactivate(): Thenable<void> {
  return stopAndCleanup({ suppressUserMessage: true });
}
