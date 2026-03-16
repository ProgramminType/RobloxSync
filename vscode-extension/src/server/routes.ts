import { IncomingMessage, ServerResponse } from "http";
import { FileManager } from "../sync/fileManager";
import { ChangeQueue } from "../sync/changeQueue";
import { FileWatcher } from "../sync/fileWatcher";
import { SessionState, InstanceData, Change } from "../types";
import { randomUUID } from "crypto";

export class RouteHandler {
  private session: SessionState = {
    connected: false,
    sessionId: null,
    lastFullSync: null,
  };

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
      console.error("[RobloxSync] Route error:", msg);
      res.writeHead(500);
      res.end(JSON.stringify({ error: msg }));
    }
  }

  private handleStatus(res: ServerResponse): void {
    res.writeHead(200);
    res.end(
      JSON.stringify({
        connected: this.session.connected,
        version: "0.1.0",
        sessionId: this.session.sessionId,
      })
    );
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

    console.log(`[RobloxSync] Plugin connected (v${data.version ?? "unknown"}) — ${experienceName} (${placeId || "unpublished"})`);
    this.onPluginConnected?.(placeId, placeName, experienceName, structureHash);

    res.writeHead(200);
    res.end(
      JSON.stringify({
        sessionId: this.session.sessionId,
        status: "connected",
      })
    );
  }

  private async handleDisconnect(_req: IncomingMessage, res: ServerResponse): Promise<void> {
    this.session = {
      connected: false,
      sessionId: null,
      lastFullSync: null,
    };

    console.log("[RobloxSync] Plugin disconnected");
    this.onPluginDisconnected?.();

    res.writeHead(200);
    res.end(JSON.stringify({ status: "disconnected" }));
  }

  private async handleFullSync(req: IncomingMessage, res: ServerResponse): Promise<void> {
    const body = await readBody(req);
    const data = JSON.parse(body) as { tree: InstanceData[] };

    // Pause file watcher while writing to avoid echo
    this.fileWatcher.pause();
    try {
      await this.fileManager.writeFullTree(data.tree);
      this.session.lastFullSync = Date.now();
      console.log(`[RobloxSync] Full sync complete — ${data.tree.length} services written`);
    } finally {
      // Small delay before resuming to let FS events settle
      setTimeout(() => this.fileWatcher.resume(), 500);
    }

    res.writeHead(200);
    res.end(JSON.stringify({ status: "ok", timestamp: Date.now() }));
  }

  private async handleStudioChanges(req: IncomingMessage, res: ServerResponse): Promise<void> {
    const body = await readBody(req);
    const data = JSON.parse(body) as { changes: Change[] };

    this.fileWatcher.pause();
    let applied = 0;
    try {
      for (const change of data.changes) {
        try {
          await this.fileManager.applyStudioChange(change);
          applied++;
        } catch (err: unknown) {
          const msg = err instanceof Error ? err.message : String(err);
          console.error(`[RobloxSync] Failed to apply ${change.type} for ${change.instancePath}: ${msg}`);
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
    res.writeHead(200);
    res.end(JSON.stringify({ changes }));
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
