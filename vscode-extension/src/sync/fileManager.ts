import * as fs from "fs";
import * as path from "path";
import { InstanceData, Change, META_FILENAME, SCRIPT_EXTENSIONS, SYNCED_SERVICES } from "../types";
import { InstanceMapper } from "./instanceMapper";
import { serializeMetaContent } from "../serialization/serializer";
import { loadApiDump, isScriptClass } from "../serialization/apiDump";

export class FileManager {
  private mapper: InstanceMapper;
  private lastTree: InstanceData[] = [];

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

  async writeFullTree(tree: InstanceData[]): Promise<void> {
    this.lastTree = tree;

    for (const serviceName of SYNCED_SERVICES) {
      const serviceDir = path.join(this.projectRoot, serviceName);
      if (fs.existsSync(serviceDir)) {
        fs.rmSync(serviceDir, { recursive: true, force: true });
      }
    }

    for (const serviceData of tree) {
      this.writeInstance(serviceData, this.projectRoot);
    }
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
    this.writeInstance(serviceData, this.projectRoot);
    return true;
  }

  /**
   * Every instance is a folder. Scripts get init.*.lua for source.
   * All instances get init.meta.json for className + properties.
   */
  private writeInstance(instance: InstanceData, parentDir: string): void {
    const dirPath = path.join(parentDir, instance.name);
    ensureDir(dirPath);

    const script = isScriptClass(instance.className);

    // Write script source file
    if (script) {
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

      this.writeInstance(child, dirPath);
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
    this.writeInstance(change.instanceData, parentPath);
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

      if (isScriptClass(change.instanceData.className)) {
        const ext = SCRIPT_EXTENSIONS[change.instanceData.className];
        const initPath = path.join(dirPath, "init" + ext);
        const source = (change.instanceData.properties["Source"] as string) ?? "";
        fs.writeFileSync(initPath, source, "utf-8");
      }
    } else if (change.property && change.value !== undefined) {
      if (change.property === "Source") {
        // Update the script source file
        const luaFile = findScriptInit(dirPath);
        if (luaFile) {
          fs.writeFileSync(luaFile, change.value as string, "utf-8");
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
