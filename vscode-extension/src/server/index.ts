import * as http from "http";
import { RouteHandler } from "./routes";
import { FileManager } from "../sync/fileManager";
import { ChangeQueue } from "../sync/changeQueue";
import { FileWatcher } from "../sync/fileWatcher";
import * as syncLog from "../syncLog";

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

      this.server.on("error", (err: NodeJS.ErrnoException) => {
        const code = err.code ? ` (${err.code})` : "";
        syncLog.errorLine(`HTTP server: ${err.message}${code}`);
        reject(err);
      });

      this.server.listen(this.port, "127.0.0.1", () => {
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
      const srv = this.server;
      // Studio polls /api/status with keep-alive; without this, .close() may never finish.
      srv.closeAllConnections();

      let done = false;
      const finish = () => {
        if (done) {
          return;
        }
        done = true;
        this.server = null;
        resolve();
      };

      srv.close(() => finish());
      setTimeout(finish, 2000);
    });
  }

  /** Used when the process is exiting; `stop()` may not run in time for `process.on("exit")`. */
  forceCloseHttpSync(): void {
    if (!this.server) {
      return;
    }
    const srv = this.server;
    this.server = null;
    srv.closeAllConnections();
    srv.close();
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
