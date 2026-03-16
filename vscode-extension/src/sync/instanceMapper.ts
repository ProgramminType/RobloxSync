import * as path from "path";
import { META_FILENAME, SYNCED_SERVICES } from "../types";

/**
 * In folder-only mode every instance is a directory containing
 * init.meta.json (properties) and optionally init.*.lua (script source).
 */
export class InstanceMapper {
  constructor(private projectRoot: string) {}

  /**
   * Determine what a file represents in the folder-only model.
   * Only init.meta.json and init.*.lua are meaningful files.
   */
  filePathToInstance(filePath: string): {
    name: string;
    className: string | null;
    isScript: boolean;
    isMeta: boolean;
  } | null {
    const basename = path.basename(filePath);

    if (basename === META_FILENAME) {
      return {
        name: path.basename(path.dirname(filePath)),
        className: null,
        isScript: false,
        isMeta: true,
      };
    }

    const initScriptExts: [string, string][] = [
      ["init.server.lua", "Script"],
      ["init.client.lua", "LocalScript"],
      ["init.lua", "ModuleScript"],
    ];
    for (const [filename, cls] of initScriptExts) {
      if (basename === filename) {
        return {
          name: path.basename(path.dirname(filePath)),
          className: cls,
          isScript: true,
          isMeta: false,
        };
      }
    }

    return null;
  }

  /**
   * Convert a file path to its dot-delimited instance path.
   * Both init.meta.json and init.*.lua map to their parent directory.
   */
  filePathToInstancePath(filePath: string): string {
    const parsed = this.filePathToInstance(filePath);

    if (parsed) {
      // init.meta.json or init.*.lua → parent directory is the instance
      const dir = path.dirname(filePath);
      const rel = path.relative(this.projectRoot, dir);
      return rel.split(path.sep).join(".");
    }

    // Directory or unknown → use relative path directly
    const rel = path.relative(this.projectRoot, filePath);
    return rel.split(path.sep).join(".");
  }

  /**
   * Convert a dot-delimited instance path to a directory path.
   */
  instancePathToDir(instancePath: string): string {
    const parts = instancePath.split(".");
    if (parts[0] === "game") {
      parts.shift();
    }
    return path.join(this.projectRoot, ...parts);
  }

  getServiceName(filePath: string): string | null {
    const relativePath = path.relative(this.projectRoot, filePath);
    const firstSegment = relativePath.split(path.sep)[0];
    if (SYNCED_SERVICES.includes(firstSegment)) {
      return firstSegment;
    }
    return null;
  }
}
