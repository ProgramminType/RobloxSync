import * as http from "http";
import { RouteHandler } from "./routes";
import { FileManager } from "../sync/fileManager";
import { ChangeQueue } from "../sync/changeQueue";
import { FileWatcher } from "../sync/fileWatcher";

export class SyncServer {
  private server: http.Server | null = null;
  private routeHandler: RouteHandler;

  constructor(
    private port: number,
    fileManager: FileManager,
    changeQueue: ChangeQueue,
    fileWatcher: FileWatcher,
    onPluginConnected?: (placeId: number, placeName: string, experienceName: string, structureHash: string) => void,
    onPluginDisconnected?: () => void
  ) {
    this.routeHandler = new RouteHandler(
      fileManager,
      changeQueue,
      fileWatcher,
      onPluginConnected,
      onPluginDisconnected
    );
  }

  start(): Promise<void> {
    return new Promise((resolve, reject) => {
      this.server = http.createServer((req, res) => {
        this.routeHandler.handle(req, res);
      });

      this.server.on("error", (err) => {
        reject(err);
      });

      this.server.listen(this.port, () => {
        console.log(`[RobloxSync] HTTP server listening on port ${this.port}`);
        resolve();
      });
    });
  }

  stop(): Promise<void> {
    return new Promise((resolve) => {
      if (!this.server) {
        resolve();
        return;
      }
      this.server.close(() => {
        this.server = null;
        console.log("[RobloxSync] HTTP server stopped");
        resolve();
      });
    });
  }

  isConnected(): boolean {
    return this.routeHandler.isConnected();
  }

  setProjectPath(newPath: string, extensionPath: string): FileWatcher {
    return this.routeHandler.setProjectPath(newPath, extensionPath);
  }

  getFileWatcher(): FileWatcher {
    return this.routeHandler.getFileWatcher();
  }
}
