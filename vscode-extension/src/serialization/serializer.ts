import { InstanceData } from "../types";
import { encodePropertyValue } from "./propertyTypes";
import { getPropertyType, isScriptClass } from "./apiDump";

/**
 * Creates the content for an init.meta.json file.
 * This is now the canonical format for ALL instances (className + non-Source properties).
 */
export function serializeMetaContent(instance: InstanceData): string {
  const properties: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(instance.properties)) {
    if (key === "Source" || key === "Name") {
      continue;
    }
    const typeInfo = getPropertyType(instance.className, key);
    const encoded = typeInfo
      ? encodePropertyValue(value, typeInfo.name)
      : value;
    if (encoded !== undefined) {
      properties[key] = encoded;
    }
  }

  const obj = {
    className: instance.className,
    properties,
  };

  return JSON.stringify(obj, null, 2) + "\n";
}

/**
 * In folder-only mode, every instance is always a directory.
 */
export function shouldBeDirectory(_instance: InstanceData): boolean {
  return true;
}
