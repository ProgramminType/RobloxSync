import { Change } from "../types";

function parentDotPath(instancePath: string): string {
  const parts = instancePath.split(".").filter(Boolean);
  if (parts.length <= 1) {
    return "";
  }
  parts.pop();
  return parts.join(".");
}

function lastSegment(instancePath: string): string {
  const parts = instancePath.split(".").filter(Boolean);
  return parts[parts.length - 1] ?? "";
}

/**
 * Explorer / FS renames often appear as create(new) + delete(old) in either order.
 * Merge a single sibling delete + create under the same parent into one rename for Studio
 * (preserves instance identity). Conservative: only when exactly one delete and one create share a parent.
 */
export function coalesceSiblingRenames(changes: Change[]): Change[] {
  if (changes.length < 2) {
    return changes;
  }

  type Del = { index: number; path: string };
  type Cr = { index: number; path: string };
  const byParent = new Map<string, { deletes: Del[]; creates: Cr[] }>();

  for (let i = 0; i < changes.length; i++) {
    const c = changes[i];
    if (c.type === "delete" && c.instancePath) {
      const parent = parentDotPath(c.instancePath);
      const bucket = byParent.get(parent) ?? { deletes: [], creates: [] };
      bucket.deletes.push({ index: i, path: c.instancePath });
      byParent.set(parent, bucket);
    } else if (c.type === "create" && c.instancePath && c.instanceData) {
      const parent = parentDotPath(c.instancePath);
      const bucket = byParent.get(parent) ?? { deletes: [], creates: [] };
      bucket.creates.push({ index: i, path: c.instancePath });
      byParent.set(parent, bucket);
    }
  }

  const remove = new Set<number>();
  const renames: Change[] = [];

  for (const [, { deletes, creates }] of byParent) {
    if (deletes.length !== 1 || creates.length !== 1) {
      continue;
    }
    const d = deletes[0];
    const cr = creates[0];
    const oldBase = lastSegment(d.path);
    const newBase = lastSegment(cr.path);
    if (oldBase === newBase) {
      continue;
    }
    remove.add(d.index);
    remove.add(cr.index);
    renames.push({
      type: "rename",
      instancePath: d.path,
      oldName: oldBase,
      newName: newBase,
      timestamp: Math.min(changes[d.index].timestamp ?? 0, changes[cr.index].timestamp ?? 0),
    });
  }

  if (remove.size === 0) {
    return changes;
  }

  const out: Change[] = [...renames];
  for (let i = 0; i < changes.length; i++) {
    if (!remove.has(i)) {
      out.push(changes[i]);
    }
  }
  return out;
}
