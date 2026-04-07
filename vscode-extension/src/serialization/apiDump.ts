import * as fs from "fs";
import * as path from "path";
import { ApiDump, ApiClass, ApiMember } from "../types";

let cachedDump: ApiDump | null = null;
let classMap: Map<string, ApiClass> | null = null;
let classNameLowerMap: Map<string, string> | null = null;
let classPropertyCache: Map<string, ApiMember[]> = new Map();

export function loadApiDump(extensionPath: string): ApiDump {
  if (cachedDump) {
    return cachedDump;
  }
  const dumpPath = path.join(extensionPath, "resources", "api-dump.json");
  const raw = fs.readFileSync(dumpPath, "utf-8");
  cachedDump = JSON.parse(raw) as ApiDump;
  classMap = new Map();
  classNameLowerMap = new Map();
  for (const cls of cachedDump.Classes) {
    classMap.set(cls.Name, cls);
    classNameLowerMap.set(cls.Name.toLowerCase(), cls.Name);
  }
  return cachedDump;
}

export function getClass(className: string): ApiClass | undefined {
  return classMap?.get(className);
}

export function getSerializableProperties(className: string): ApiMember[] {
  const cached = classPropertyCache.get(className);
  if (cached) {
    return cached;
  }

  const properties: ApiMember[] = [];
  let current: string | undefined = className;

  while (current && current !== "<<<ROOT>>>") {
    const classInfo: ApiClass | undefined = classMap?.get(current);
    if (!classInfo) {
      break;
    }

    for (const member of classInfo.Members) {
      if (member.MemberType !== "Property") {
        continue;
      }
      if (member.Tags?.includes("ReadOnly") || member.Tags?.includes("NotScriptable")) {
        continue;
      }
      const ser = member.Serialization;
      if (ser && !ser.CanSave) {
        continue;
      }
      properties.push(member);
    }

    current = classInfo.Superclass;
  }

  classPropertyCache.set(className, properties);
  return properties;
}

export function getPropertyType(
  className: string,
  propertyName: string
): { category: string; name: string } | undefined {
  const props = getSerializableProperties(className);
  const prop = props.find((p) => p.Name === propertyName);
  if (!prop?.ValueType) {
    return undefined;
  }
  return { category: prop.ValueType.Category, name: prop.ValueType.Name };
}

export function isScriptClass(className: string): boolean {
  return className === "Script" || className === "LocalScript" || className === "ModuleScript";
}

export function resolveClassName(name: string): string {
  if (classMap?.has(name)) {
    return name;
  }
  return classNameLowerMap?.get(name.toLowerCase()) ?? name;
}

export function isValidClassName(name: string): string | null {
  const resolved = resolveClassName(name);
  return classMap?.has(resolved) ? resolved : null;
}

let classNamesLongestFirst: string[] | null = null;

function getClassNamesLongestFirst(): string[] {
  if (classNamesLongestFirst) {
    return classNamesLongestFirst;
  }
  if (!classMap) {
    return [];
  }
  classNamesLongestFirst = Array.from(classMap.keys()).sort((a, b) => b.length - a.length);
  return classNamesLongestFirst;
}

/**
 * Non–cursor mode: folder name may be a class name or that class name + any suffix
 * (e.g. Part, Part1, Part_4, PartFoo). Longest matching class wins (ParticleEmitter before Part).
 */
export function resolveClassFromFolderPrefix(folderName: string): string | null {
  if (!folderName) {
    return null;
  }
  const lower = folderName.toLowerCase();
  for (const c of getClassNamesLongestFirst()) {
    const cl = c.toLowerCase();
    if (lower.startsWith(cl)) {
      return c;
    }
  }
  return null;
}
