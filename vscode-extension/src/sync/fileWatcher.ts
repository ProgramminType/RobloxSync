import * as vscode from "vscode";
import * as path from "path";
import * as fs from "fs";
import { ChangeQueue } from "./changeQueue";
import { FileManager } from "./fileManager";
import { Change, SYNCED_SERVICES, META_FILENAME } from "../types";
import { fileToChange, directoryToInstanceData } from "../serialization/deserializer";

export class FileWatcher {
  private watchers: vscode.FileSystemWatcher[] = [];
  private paused = false;
  private debounceTimers: Map<string, NodeJS.Timeout> = new Map();

  constructor(
    private projectRoot: string,
    private changeQueue: ChangeQueue,
    private fileManager: FileManager
  ) {}

  start(): void {
    const pattern = new vscode.RelativePattern(this.projectRoot, "**/*");

    const createWatcher = vscode.workspace.createFileSystemWatcher(pattern, false, false, false);

    createWatcher.onDidCreate((uri) => this.onFileEvent(uri, "create"));
    createWatcher.onDidChange((uri) => this.onFileEvent(uri, "update"));
    createWatcher.onDidDelete((uri) => this.onFileEvent(uri, "delete"));

    this.watchers.push(createWatcher);
    console.log(`[RobloxSync] File watcher started on ${this.projectRoot}`);
  }

  stop(): void {
    for (const watcher of this.watchers) {
      watcher.dispose();
    }
    this.watchers = [];

    for (const timer of this.debounceTimers.values()) {
      clearTimeout(timer);
    }
    this.debounceTimers.clear();
  }

  pause(): void {
    this.paused = true;
    this.changeQueue.pause();
  }

  resume(): void {
    this.paused = false;
    this.changeQueue.resume();
  }

  private onFileEvent(uri: vscode.Uri, eventType: "create" | "update" | "delete"): void {
    if (this.paused) {
      return;
    }

    const filePath = uri.fsPath;
    const relativePath = path.relative(this.projectRoot, filePath);

    const firstSegment = relativePath.split(path.sep)[0];
    if (!SYNCED_SERVICES.includes(firstSegment)) {
      return;
    }

    if (path.basename(filePath).startsWith(".")) {
      return;
    }

    const existing = this.debounceTimers.get(filePath);
    if (existing) {
      clearTimeout(existing);
    }

    this.debounceTimers.set(
      filePath,
      setTimeout(() => {
        this.debounceTimers.delete(filePath);
        this.processFileEvent(filePath, eventType);
      }, 200)
    );
  }

  private isProtectedServicePath(filePath: string): string | null {
    const rel = path.relative(this.projectRoot, filePath);
    const segments = rel.split(path.sep);
    if (segments.length === 1 && SYNCED_SERVICES.includes(segments[0])) {
      return segments[0];
    }
    return null;
  }

  private processFileEvent(filePath: string, eventType: "create" | "update" | "delete"): void {
    if (this.paused) {
      return;
    }

    const mapper = this.fileManager.getMapper();
    const basename = path.basename(filePath);

    try {
      // Directory events
      if (eventType === "create" && fs.existsSync(filePath) && fs.statSync(filePath).isDirectory()) {
        // New directory = potential new instance; read its contents
        const instanceData = directoryToInstanceData(filePath, mapper);
        if (instanceData) {
          const instancePath = mapper.filePathToInstancePath(filePath);
          const change: Change = {
            type: "create",
            instancePath,
            instanceData,
            timestamp: Date.now(),
          };
          this.changeQueue.enqueue(change);
        }
        return;
      }

      if (eventType === "delete") {
        // Block deletion of protected service roots (Workspace, Players, etc.)
        const protectedService = this.isProtectedServicePath(filePath);
        if (protectedService) {
          this.paused = true;
          const restored = this.fileManager.restoreService(protectedService);
          if (restored) {
            console.log(`[RobloxSync] Restored protected service: ${protectedService}`);
          } else {
            fs.mkdirSync(filePath, { recursive: true });
            fs.writeFileSync(
              path.join(filePath, META_FILENAME),
              JSON.stringify({ className: protectedService, properties: {} }, null, 2) + "\n",
              "utf-8"
            );
          }
          vscode.window.showWarningMessage(
            `Cannot delete "${protectedService}" — it's a protected Roblox service and has been restored.`
          );
          setTimeout(() => {
            this.paused = false;
          }, 500);
          return;
        }

        const parsed = mapper.filePathToInstance(filePath);
        if (parsed) {
          // Deleting init.meta.json or init.*.lua deletes the entire object
          const instancePath = mapper.filePathToInstancePath(filePath);
          const change: Change = {
            type: "delete",
            instancePath,
            timestamp: Date.now(),
          };
          this.changeQueue.enqueue(change);
          return;
        }

        // Directory deletion
        const instancePath = mapper.filePathToInstancePath(filePath);
        const change: Change = {
          type: "delete",
          instancePath,
          timestamp: Date.now(),
        };
        this.changeQueue.enqueue(change);
        return;
      }

      // File create or update (init.meta.json or init.*.lua)
      const change = fileToChange(filePath, eventType, mapper);
      if (change) {
        this.changeQueue.enqueue(change);
      }
    } catch (err) {
      console.error(`[RobloxSync] Error processing file event: ${err}`);
    }
  }
}
