import { IncomingMessage, ServerResponse } from "http";
import * as vscode from "vscode";
import { FileManager } from "../sync/fileManager";
import { ChangeQueue } from "../sync/changeQueue";
import { FileWatcher } from "../sync/fileWatcher";
import { SessionState, InstanceData, Change } from "../types";
import { randomUUID } from "crypto";
import * as syncLog from "../syncLog";
import { UI } from "../ui/messages";

/** Avoid spamming the banner on back-to-back full syncs (e.g. reconnect after editor reload). */
let lastWorkspaceReadyBannerAt = 0;
const WORKSPACE_READY_BANNER_DEBOUNCE_MS = 25000;

export class RouteHandler {
  private session: SessionState = {
    connected: false,
    sessionId: null,
    lastFullSync: null,
  };

  private lastStudioLivenessAt = 0;
  private inactivityTimer: ReturnType<typeof setInterval> | null = null;

  constructor(
    private fileManager: FileManager,
    private changeQueue: ChangeQueue,
    private fileWatcher: FileWatcher,
    private onPluginConnected?: (placeId: number, placeName: string, experienceName: string, structureHash: string) => void,
    private onPluginDisconnected?: () => void
  ) {}

  async handle(req: IncomingMessage, res: ServerResponse): Promise<void> {
    const url = req.url ?? "";
    const method = req.method ?? "GET";

    res.setHeader("Content-Type", "application/json");
    res.setHeader("Access-Control-Allow-Origin", "*");

    if (method === "OPTIONS") {
      res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
      res.setHeader("Access-Control-Allow-Headers", "Content-Type");
      res.writeHead(204);
      res.end();
      return;
    }

    try {
      if (method === "GET" && url === "/api/status") {
        this.handleStatus(res);
      } else if (method === "GET" && url === "/api/ping") {
        this.handlePing(res);
      } else if (method === "POST" && url === "/api/connect") {
        await this.handleConnect(req, res);
      } else if (method === "POST" && url === "/api/disconnect") {
        await this.handleDisconnect(req, res);
      } else if (method === "POST" && url === "/api/full-sync") {
        await this.handleFullSync(req, res);
      } else if (method === "POST" && url === "/api/studio-changes") {
        await this.handleStudioChanges(req, res);
      } else if (method === "GET" && url === "/api/vscode-changes") {
        this.handleVscodeChanges(res);
      } else {
        res.writeHead(404);
        res.end(JSON.stringify({ error: "Not found" }));
      }
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : String(err);
      syncLog.errorLine(`request: ${msg}`);
      res.writeHead(500);
      res.end(JSON.stringify({ error: msg }));
    }
  }

  private handleStatus(res: ServerResponse): void {
    const cfg = vscode.workspace.getConfiguration("robloxSync");
    res.writeHead(200);
    res.end(
      JSON.stringify({
        connected: this.session.connected,
        version: "1.4.0",
        sessionId: this.session.sessionId,
        studioInactivityTimeoutSec: cfg.get<number>("studioInactivityTimeoutSec", 45),
        studioPingIntervalSec: cfg.get<number>("studioPingIntervalSec", 8),
      })
    );
  }

  private handlePing(res: ServerResponse): void {
    if (this.session.connected) {
      this.touchStudioLiveness();
    }
    res.writeHead(200);
    res.end(JSON.stringify({ ok: true, connected: this.session.connected }));
  }

  private touchStudioLiveness(): void {
    this.lastStudioLivenessAt = Date.now();
  }

  private startStudioInactivityWatcher(): void {
    this.stopStudioInactivityWatcher();
    this.touchStudioLiveness();
    this.inactivityTimer = setInterval(() => {
      if (!this.session.connected) {
        this.stopStudioInactivityWatcher();
        return;
      }
      const cfg = vscode.workspace.getConfiguration("robloxSync");
      const sec = Math.max(15, cfg.get<number>("studioInactivityTimeoutSec", 45));
      if (Date.now() - this.lastStudioLivenessAt > sec * 1000) {
        this.stopStudioInactivityWatcher();
        this.session = {
          connected: false,
          sessionId: null,
          lastFullSync: null,
        };
        const cb = this.onPluginDisconnected;
        if (cb) {
          setImmediate(() => cb());
        }
      }
    }, 3000);
  }

  private stopStudioInactivityWatcher(): void {
    if (this.inactivityTimer) {
      clearInterval(this.inactivityTimer);
      this.inactivityTimer = null;
    }
  }

  private async handleConnect(req: IncomingMessage, res: ServerResponse): Promise<void> {
    const body = await readBody(req);
    const data = JSON.parse(body) as {
      version?: string;
      placeId?: number;
      placeName?: string;
      experienceName?: string;
      structureHash?: string;
    };

    this.session = {
      connected: true,
      sessionId: randomUUID(),
      lastFullSync: null,
    };

    const placeId = data.placeId ?? 0;
    const placeName = data.placeName ?? "Unnamed";
    const experienceName = data.experienceName ?? placeName;
    const structureHash = data.structureHash ?? "";

    this.touchStudioLiveness();
    this.startStudioInactivityWatcher();
    this.onPluginConnected?.(placeId, placeName, experienceName, structureHash);

    res.writeHead(200);
    res.end(
      JSON.stringify({
        sessionId: this.session.sessionId,
        status: "connected",
      })
    );
  }

  private async handleDisconnect(req: IncomingMessage, res: ServerResponse): Promise<void> {
    let soft = false;
    try {
      const body = await readBody(req);
      if (body) {
        const data = JSON.parse(body) as { sessionId?: string; soft?: boolean };
        soft = data.soft === true;
      }
    } catch {
      // Legacy clients: empty or non-JSON body
    }

    this.stopStudioInactivityWatcher();
    this.session = {
      connected: false,
      sessionId: null,
      lastFullSync: null,
    };

    res.writeHead(200);
    res.end(JSON.stringify({ status: "disconnected" }));

    if (soft) {
      syncLog.line("Studio paused sync (e.g. Play Mode). Server still running; connect again when you return to Edit.");
    } else {
      const onDisconnect = this.onPluginDisconnected;
      if (onDisconnect) {
        setImmediate(() => onDisconnect());
      }
    }
  }

  private async handleFullSync(req: IncomingMessage, res: ServerResponse): Promise<void> {
    const body = await readBody(req);
    const data = JSON.parse(body) as { tree: InstanceData[] };

    if (this.session.connected) {
      this.touchStudioLiveness();
    }

    // Pause file watcher while writing to avoid echo
    this.fileWatcher.pause();
    try {
      await this.fileManager.writeFullTree(data.tree);
      this.session.lastFullSync = Date.now();
    } finally {
      // Small delay before resuming to let FS events settle
      setTimeout(() => this.fileWatcher.resume(), 500);
    }

    const now = Date.now();
    if (now - lastWorkspaceReadyBannerAt >= WORKSPACE_READY_BANNER_DEBOUNCE_MS) {
      lastWorkspaceReadyBannerAt = now;
      void vscode.window.showInformationMessage(UI.workspaceReadyToEdit);
    }

    res.writeHead(200);
    res.end(JSON.stringify({ status: "ok", timestamp: Date.now() }));
  }

  private async handleStudioChanges(req: IncomingMessage, res: ServerResponse): Promise<void> {
    const body = await readBody(req);
    const data = JSON.parse(body) as { changes: Change[]; silentLog?: boolean };

    if (this.session.connected) {
      this.touchStudioLiveness();
    }

    this.fileWatcher.pause();
    let applied = 0;
    try {
      for (const change of data.changes) {
        try {
          await this.fileManager.applyStudioChange(change);
          if (!data.silentLog) {
            syncLog.change("Studio ---> VS Code", syncLog.formatChangeSummary(change));
          }
          applied++;
        } catch (err: unknown) {
          const msg = err instanceof Error ? err.message : String(err);
          syncLog.errorLine(`Studio ---> VS Code (${syncLog.formatChangeSummary(change)}): ${msg}`);
        }
      }
    } finally {
      setTimeout(() => this.fileWatcher.resume(), 300);
    }

    res.writeHead(200);
    res.end(JSON.stringify({ status: "ok", applied }));
  }

  private handleVscodeChanges(res: ServerResponse): void {
    const changes = this.changeQueue.drain();
    for (const c of changes) {
      syncLog.change("VS Code ---> Studio", syncLog.formatChangeSummary(c));
    }
    const cursorMode = vscode.workspace.getConfiguration("robloxSync").get<boolean>("cursorMode", false);
    res.writeHead(200);
    res.end(JSON.stringify({ changes, cursorMode }));
  }

  isConnected(): boolean {
    return this.session.connected;
  }

  setProjectPath(newPath: string, extensionPath: string): FileWatcher {
    this.fileWatcher.pause();
    this.fileWatcher.stop();
    const newFileManager = new FileManager(newPath, extensionPath);
    const newFileWatcher = new FileWatcher(newPath, this.changeQueue, newFileManager);
    (this as { fileManager: FileManager }).fileManager = newFileManager;
    (this as { fileWatcher: FileWatcher }).fileWatcher = newFileWatcher;
    newFileWatcher.start();
    return newFileWatcher;
  }

  getFileWatcher(): FileWatcher {
    return this.fileWatcher;
  }

  getFileManager(): FileManager {
    return this.fileManager;
  }
}

function readBody(req: IncomingMessage): Promise<string> {
  return new Promise((resolve, reject) => {
    const chunks: Buffer[] = [];
    req.on("data", (chunk: Buffer) => chunks.push(chunk));
    req.on("end", () => resolve(Buffer.concat(chunks).toString("utf-8")));
    req.on("error", reject);
  });
}
