import * as fs from "fs";
import * as path from "path";
import * as vscode from "vscode";
import { InstanceData, Change, META_FILENAME, SCRIPT_EXTENSIONS, SYNCED_SERVICES } from "../types";
import { InstanceMapper } from "./instanceMapper";
import { serializeMetaContent } from "../serialization/serializer";
import { loadApiDump, isScriptClass, resolveClassName } from "../serialization/apiDump";

export class FileManager {
  private mapper: InstanceMapper;
  private lastTree: InstanceData[] = [];
  /**
   * Cursor mode: instance paths (normalized) for scripts created from VS Code via init.meta.json only —
   * suppress Studio→disk init.*.lua writes until the user adds the script file locally.
   */
  private vscodeMetaScriptNoInitPaths = new Set<string>();

  constructor(
    private projectRoot: string,
    private extensionPath: string
  ) {
    this.mapper = new InstanceMapper(projectRoot);
    loadApiDump(extensionPath);
  }

  getMapper(): InstanceMapper {
    return this.mapper;
  }

  /** Dot path without leading `game.` (e.g. Workspace.Foo.Bar). */
  static normalizeInstancePathKey(instancePath: string): string {
    const parts = instancePath.split(".").filter(Boolean);
    if (parts.length > 0 && parts[0].toLowerCase() === "game") {
      parts.shift();
    }
    return parts.join(".");
  }

  markMetaScriptAwaitingUserInit(instancePath: string): void {
    this.vscodeMetaScriptNoInitPaths.add(FileManager.normalizeInstancePathKey(instancePath));
  }

  clearMetaScriptAwaitingUserInit(instancePath: string): void {
    this.vscodeMetaScriptNoInitPaths.delete(FileManager.normalizeInstancePathKey(instancePath));
  }

  private scriptSourceMeaningful(instance: InstanceData): boolean {
    const s = instance.properties["Source"];
    return typeof s === "string" && s.trim().length > 0;
  }

  /**
   * When to write init.*.lua from Studio-applied data (cursor mode nuances).
   */
  private shouldWriteInitLuaFromStudio(
    instanceDotPath: string,
    instance: InstanceData,
    fullTree: boolean
  ): boolean {
    if (!isScriptClass(instance.className)) {
      return false;
    }
    const key = FileManager.normalizeInstancePathKey(instanceDotPath);
    // Meta-only VS Code scripts: defer init until Source is non-empty (Studio edit or template filled)
    if (this.vscodeMetaScriptNoInitPaths.has(key)) {
      if (this.scriptSourceMeaningful(instance)) {
        this.vscodeMetaScriptNoInitPaths.delete(key);
      } else {
        return false;
      }
    }
    const cursorMode = vscode.workspace.getConfiguration("robloxSync").get<boolean>("cursorMode", false);
    if (!cursorMode) {
      return true;
    }
    if (fullTree) {
      return true;
    }
    // Incremental Studio apply: always write init.*.lua (empty Source ok); meta-only bypass handled above
    return true;
  }

  /** init.server.lua / init.client.lua / init.lua path from init.meta.json className, or null. */
  private resolveScriptInitPathFromMeta(dirPath: string): string | null {
    const metaPath = path.join(dirPath, META_FILENAME);
    if (!fs.existsSync(metaPath)) {
      return null;
    }
    try {
      const json = JSON.parse(fs.readFileSync(metaPath, "utf-8")) as { className?: unknown };
      if (json.className === undefined || json.className === null || String(json.className).trim() === "") {
        return null;
      }
      const cn = resolveClassName(String(json.className));
      if (!isScriptClass(cn)) {
        return null;
      }
      const ext = SCRIPT_EXTENSIONS[cn];
      if (!ext) {
        return null;
      }
      return path.join(dirPath, "init" + ext);
    } catch {
      return null;
    }
  }

  async writeFullTree(tree: InstanceData[]): Promise<void> {
    this.lastTree = tree;

    for (const serviceName of SYNCED_SERVICES) {
      const serviceDir = path.join(this.projectRoot, serviceName);
      if (fs.existsSync(serviceDir)) {
        fs.rmSync(serviceDir, { recursive: true, force: true });
      }
    }

    for (const serviceData of tree) {
      this.writeInstance(serviceData, this.projectRoot, serviceData.name, true);
    }
  }

  /** Start a chunked full sync: wipe synced service dirs and reset the in-memory tree cache. */
  beginFullSync(): void {
    this.lastTree = [];
    for (const serviceName of SYNCED_SERVICES) {
      const serviceDir = path.join(this.projectRoot, serviceName);
      if (fs.existsSync(serviceDir)) {
        fs.rmSync(serviceDir, { recursive: true, force: true });
      }
    }
  }

  /** Append top-level service roots (each a full subtree, or a skeleton with empty children to be filled by appendFullSyncChildren). */
  appendFullSyncRoots(roots: InstanceData[]): void {
    for (const root of roots) {
      this.writeInstance(root, this.projectRoot, root.name, true);
      this.lastTree.push(root);
    }
  }

  /** Append instances as direct children of an existing path (dot path, e.g. Workspace or Workspace.Folder). */
  appendFullSyncChildren(parentDotPath: string, instances: InstanceData[]): void {
    if (instances.length === 0) {
      return;
    }
    const parentDir = this.mapper.instancePathToDir(parentDotPath);
    ensureDir(parentDir);
    const dotPrefix = FileManager.normalizeInstancePathKey(parentDotPath);
    for (const inst of instances) {
      this.writeInstance(inst, parentDir, `${dotPrefix}.${inst.name}`, true);
    }
    const parentNode = this.findNodeInLastTree(parentDotPath);
    if (parentNode) {
      for (const inst of instances) {
        parentNode.children.push(inst);
      }
    }
  }

  private findNodeInLastTree(dotPath: string): InstanceData | null {
    const parts = FileManager.normalizeInstancePathKey(dotPath)
      .split(".")
      .filter((p) => p.length > 0);
    if (parts.length === 0) {
      return null;
    }
    let nodes: InstanceData[] = this.lastTree;
    let current: InstanceData | null = null;
    for (const part of parts) {
      current = nodes.find((n) => n.name === part) ?? null;
      if (!current) {
        return null;
      }
      nodes = current.children;
    }
    return current;
  }

  /**
   * Restore a previously synced service from the cached full tree.
   * Returns true if the service was found and restored.
   */
  restoreService(serviceName: string): boolean {
    const serviceData = this.lastTree.find((s) => s.name === serviceName);
    if (!serviceData) {
      return false;
    }
    this.writeInstance(serviceData, this.projectRoot, serviceData.name, true);
    return true;
  }

  /**
   * Every instance is a folder. Scripts get init.*.lua for source.
   * All instances get init.meta.json for className + properties.
   */
  private writeInstance(instance: InstanceData, parentDir: string, instanceDotPath: string, fullTree: boolean): void {
    const dirPath = path.join(parentDir, instance.name);
    ensureDir(dirPath);

    const script = isScriptClass(instance.className);

    if (script && this.shouldWriteInitLuaFromStudio(instanceDotPath, instance, fullTree)) {
      const ext = SCRIPT_EXTENSIONS[instance.className];
      const initPath = path.join(dirPath, "init" + ext);
      const source = (instance.properties["Source"] as string) ?? "";
      fs.writeFileSync(initPath, source, "utf-8");
    }

    // Always write init.meta.json with className + non-Source properties
    const metaPath = path.join(dirPath, META_FILENAME);
    fs.writeFileSync(metaPath, serializeMetaContent(instance), "utf-8");

    // Recurse children with name dedup (rename both folder and data to match)
    const usedNames = new Map<string, number>();
    for (const child of instance.children) {
      const baseName = child.name;
      const count = usedNames.get(baseName) ?? 0;
      usedNames.set(baseName, count + 1);

      if (count > 0) {
        child.name = `${baseName}_${count + 1}`;
      }

      this.writeInstance(child, dirPath, `${instanceDotPath}.${child.name}`, fullTree);
    }
  }

  async applyStudioChange(change: Change): Promise<void> {
    switch (change.type) {
      case "create":
        this.handleStudioCreate(change);
        break;
      case "update":
        this.handleStudioUpdate(change);
        break;
      case "delete":
        this.handleStudioDelete(change);
        break;
      case "rename":
        this.handleStudioRename(change);
        break;
    }
  }

  private handleStudioCreate(change: Change): void {
    if (!change.instanceData) {
      return;
    }

    const parentPath = this.getParentDirFromInstancePath(change.instancePath);
    if (!parentPath) {
      return;
    }

    ensureDir(parentPath);
    const dotPath = FileManager.normalizeInstancePathKey(change.instancePath);
    this.writeInstance(change.instanceData, parentPath, dotPath, false);
  }

  private handleStudioUpdate(change: Change): void {
    const dirPath = this.findDirForInstancePath(change.instancePath);
    if (!dirPath) {
      if (change.instanceData) {
        this.handleStudioCreate(change);
      }
      return;
    }

    if (change.instanceData) {
      // Full update — rewrite meta (and script source if applicable)
      const metaPath = path.join(dirPath, META_FILENAME);
      fs.writeFileSync(metaPath, serializeMetaContent(change.instanceData), "utf-8");

      const dotPath = FileManager.normalizeInstancePathKey(change.instancePath);
      if (
        isScriptClass(change.instanceData.className) &&
        this.shouldWriteInitLuaFromStudio(dotPath, change.instanceData, false)
      ) {
        const ext = SCRIPT_EXTENSIONS[change.instanceData.className];
        const initPath = path.join(dirPath, "init" + ext);
        const source = (change.instanceData.properties["Source"] as string) ?? "";
        fs.writeFileSync(initPath, source, "utf-8");
      }
    } else if (change.property && change.value !== undefined) {
      if (change.property === "Source") {
        const cursorMode = vscode.workspace.getConfiguration("robloxSync").get<boolean>("cursorMode", false);
        const dotPath = FileManager.normalizeInstancePathKey(change.instancePath);
        const sourceText =
          typeof change.value === "string" ? change.value : String(change.value ?? "");
        if (cursorMode && this.vscodeMetaScriptNoInitPaths.has(dotPath) && sourceText.trim().length === 0) {
          return;
        }
        if (cursorMode && this.vscodeMetaScriptNoInitPaths.has(dotPath) && sourceText.trim().length > 0) {
          this.clearMetaScriptAwaitingUserInit(change.instancePath);
        }
        const luaFile = findScriptInit(dirPath);
        if (luaFile) {
          fs.writeFileSync(luaFile, sourceText, "utf-8");
        } else {
          const initPath = this.resolveScriptInitPathFromMeta(dirPath);
          if (initPath && sourceText.trim().length > 0) {
            fs.writeFileSync(initPath, sourceText, "utf-8");
          }
        }
      } else {
        // Update a single property in init.meta.json
        const metaPath = path.join(dirPath, META_FILENAME);
        this.updatePropertyInMeta(metaPath, change.property, change.value);
      }
    }
  }

  private handleStudioDelete(change: Change): void {
    const dirPath = this.findDirForInstancePath(change.instancePath);
    if (!dirPath || !fs.existsSync(dirPath)) {
      return;
    }
    try {
      fs.rmSync(dirPath, { recursive: true, force: true });
      console.log(`[RobloxSync] Deleted: ${dirPath}`);
    } catch {
      // May have already been removed by a parent delete
    }
  }

  private handleStudioRename(change: Change): void {
    if (!change.oldName || !change.newName) {
      return;
    }

    const dirPath = this.findDirForInstancePath(change.instancePath);
    if (!dirPath || !fs.existsSync(dirPath)) {
      return;
    }

    const parentDir = path.dirname(dirPath);
    const newDirPath = path.join(parentDir, change.newName);
    try {
      fs.renameSync(dirPath, newDirPath);
      console.log(`[RobloxSync] Renamed: ${dirPath} -> ${newDirPath}`);
    } catch (err) {
      console.error(`[RobloxSync] Rename failed: ${err}`);
    }
  }

  private updatePropertyInMeta(metaPath: string, property: string, value: unknown): void {
    if (!fs.existsSync(metaPath)) {
      fs.writeFileSync(
        metaPath,
        JSON.stringify({ className: "Unknown", properties: { [property]: value } }, null, 2) + "\n",
        "utf-8"
      );
      return;
    }

    try {
      const json = JSON.parse(fs.readFileSync(metaPath, "utf-8"));
      if (!json.properties) {
        json.properties = {};
      }
      json.properties[property] = value;
      fs.writeFileSync(metaPath, JSON.stringify(json, null, 2) + "\n", "utf-8");
    } catch {
      console.error(`[RobloxSync] Failed to update property in: ${metaPath}`);
    }
  }

  /**
   * In folder-only mode, every instance is a directory.
   * Walk the dot-delimited path as nested directories.
   */
  findDirForInstancePath(instancePath: string): string | null {
    const parts = instancePath.split(".");
    if (parts[0] === "game") {
      parts.shift();
    }

    let currentDir = this.projectRoot;
    for (const segment of parts) {
      const dirPath = path.join(currentDir, segment);
      if (fs.existsSync(dirPath) && fs.statSync(dirPath).isDirectory()) {
        currentDir = dirPath;
      } else {
        return null;
      }
    }

    return currentDir;
  }

  // Keep old name as alias for compatibility
  findFileForInstancePath(instancePath: string): string | null {
    return this.findDirForInstancePath(instancePath);
  }

  private getParentDirFromInstancePath(instancePath: string): string | null {
    const parts = instancePath.split(".");
    if (parts[0] === "game") {
      parts.shift();
    }

    parts.pop();

    if (parts.length === 0) {
      return this.projectRoot;
    }

    let currentDir = this.projectRoot;
    for (const segment of parts) {
      currentDir = path.join(currentDir, segment);
    }

    return currentDir;
  }
}

function ensureDir(dirPath: string): void {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
}

function findScriptInit(dirPath: string): string | null {
  for (const ext of [".server.lua", ".client.lua", ".lua"]) {
    const p = path.join(dirPath, "init" + ext);
    if (fs.existsSync(p)) {
      return p;
    }
  }
  return null;
}
