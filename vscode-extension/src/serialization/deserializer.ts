import * as fs from "fs";
import * as path from "path";
import { InstanceData, META_FILENAME, Change } from "../types";
import { decodePropertyValue } from "./propertyTypes";
import { getPropertyType, resolveClassName, isValidClassName } from "./apiDump";
import { InstanceMapper } from "../sync/instanceMapper";

/**
 * Read a file event and convert it to a Change for the Roblox plugin.
 * In folder-only mode, only init.meta.json and init.*.lua are meaningful files.
 */
export function fileToChange(
  filePath: string,
  changeType: "create" | "update" | "delete",
  mapper: InstanceMapper
): Change | null {
  const parsed = mapper.filePathToInstance(filePath);
  if (!parsed) {
    return null;
  }

  const instancePath = mapper.filePathToInstancePath(filePath);

  if (changeType === "delete") {
    return {
      type: "delete",
      instancePath,
      timestamp: Date.now(),
    };
  }

  if (!fs.existsSync(filePath)) {
    return null;
  }

  const content = fs.readFileSync(filePath, "utf-8");

  if (parsed.isScript) {
    // init.*.lua → read full properties from meta + Source from this file
    const metaPath = path.join(path.dirname(filePath), META_FILENAME);
    let className = parsed.className ?? "Script";
    let name = parsed.name;
    const properties: Record<string, unknown> = {};

    if (fs.existsSync(metaPath)) {
      try {
        const meta = JSON.parse(fs.readFileSync(metaPath, "utf-8"));
        if (meta.className) {
          className = meta.className;
        }
        if (meta.name) {
          name = meta.name;
        }
        if (meta.properties) {
          for (const [key, value] of Object.entries(meta.properties)) {
            const typeInfo = getPropertyType(className, key);
            if (typeInfo) {
              properties[key] = decodePropertyValue(
                value,
                typeInfo.name,
                typeInfo.name === "Enum" ? key : undefined
              );
            } else {
              properties[key] = value;
            }
          }
        }
      } catch {
        // use defaults
      }
    }

    properties["Source"] = content;

    return {
      type: changeType,
      instancePath,
      instanceData: {
        id: "",
        className,
        name,
        properties,
        children: [],
      },
      timestamp: Date.now(),
    };
  }

  if (parsed.isMeta) {
    // init.meta.json → create/update the instance's properties
    const trimmed = content.trim();
    if (!trimmed || trimmed === "{}" || trimmed === "{ }") {
      return {
        type: changeType,
        instancePath,
        instanceData: {
          id: "",
          className: "Folder",
          name: parsed.name,
          properties: {},
          children: [],
        },
        timestamp: Date.now(),
      };
    }

    try {
      const json = JSON.parse(content);
      const className = resolveClassName(json.className ?? "Folder");
      const name = json.name ?? parsed.name;
      const properties: Record<string, unknown> = {};

      if (json.properties) {
        for (const [key, value] of Object.entries(json.properties)) {
          const typeInfo = getPropertyType(className, key);
          if (typeInfo) {
            const decoded = decodePropertyValue(
              value,
              typeInfo.name,
              typeInfo.name === "Enum" ? key : undefined
            );
            properties[key] = decoded;
          } else {
            properties[key] = value;
          }
        }
      }

      // Also read init.*.lua if it exists (for script source)
      const dirPath = path.dirname(filePath);
      const source = readScriptSource(dirPath);
      if (source !== null) {
        properties["Source"] = source;
      }

      return {
        type: changeType,
        instancePath,
        instanceData: {
          id: "",
          className,
          name,
          properties,
          children: [],
        },
        timestamp: Date.now(),
      };
    } catch {
      console.error(`[RobloxSync] Failed to parse JSON: ${filePath}`);
      return null;
    }
  }

  return null;
}

/**
 * Read an entire directory tree and produce InstanceData.
 * In folder-only mode, every subdirectory is a child instance.
 */
export function directoryToInstanceData(
  dirPath: string,
  mapper: InstanceMapper
): InstanceData | null {
  const folderName = path.basename(dirPath);
  const metaPath = path.join(dirPath, META_FILENAME);

  let className = "Folder";
  let name = folderName;
  let properties: Record<string, unknown> = {};

  if (fs.existsSync(metaPath)) {
    try {
      const raw = fs.readFileSync(metaPath, "utf-8").trim();
      if (raw && raw !== "{}" && raw !== "{ }") {
        const json = JSON.parse(raw);
        className = resolveClassName(json.className ?? "Folder");
        if (json.name) {
          name = json.name;
        }
        if (json.properties) {
          for (const [key, value] of Object.entries(json.properties)) {
            const typeInfo = getPropertyType(className, key);
            if (typeInfo) {
              properties[key] = decodePropertyValue(
                value,
                typeInfo.name,
                typeInfo.name === "Enum" ? key : undefined
              );
            } else {
              properties[key] = value;
            }
          }
        }
      } else {
        // Empty meta: use folder name as class if valid
        const resolvedClass = isValidClassName(folderName);
        if (resolvedClass) {
          className = resolvedClass;
          name = folderName;
        }
      }
    } catch {
      // Parse failed: use folder name as class if valid
      const resolvedClass = isValidClassName(folderName);
      if (resolvedClass) {
        className = resolvedClass;
        name = folderName;
      }
    }
  } else {
    // No meta file: use folder name as class if valid (creates object with defaults)
    const resolvedClass = isValidClassName(folderName);
    if (resolvedClass) {
      className = resolvedClass;
      name = folderName;
    }
  }

  // Read script source if present
  const source = readScriptSource(dirPath);
  if (source !== null) {
    properties["Source"] = source;
  }

  const data: InstanceData = {
    id: "",
    className,
    name,
    properties,
    children: [],
  };

  // All subdirectories are child instances
  if (fs.existsSync(dirPath)) {
    const entries = fs.readdirSync(dirPath, { withFileTypes: true });
    for (const entry of entries) {
      if (!entry.isDirectory()) {
        continue;
      }
      const childPath = path.join(dirPath, entry.name);
      const child = directoryToInstanceData(childPath, mapper);
      if (child) {
        data.children.push(child);
      }
    }
  }

  return data;
}

function readScriptSource(dirPath: string): string | null {
  for (const initName of ["init.server.lua", "init.client.lua", "init.lua"]) {
    const p = path.join(dirPath, initName);
    if (fs.existsSync(p)) {
      return fs.readFileSync(p, "utf-8");
    }
  }
  return null;
}
