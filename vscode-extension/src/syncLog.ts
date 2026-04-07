import * as vscode from "vscode";
import type { Change } from "./types";

const PREFIX = "[Roblox Sync]";

let outputChannel: vscode.OutputChannel | null = null;

function channel(): vscode.OutputChannel {
  if (!outputChannel) {
    outputChannel = vscode.window.createOutputChannel("Roblox Sync");
  }
  return outputChannel;
}

/** Shared output channel (also exposed for legacy getDebugChannel). */
export function getOutputChannel(): vscode.OutputChannel {
  return channel();
}

export function showOutput(): void {
  channel().show(true);
}

export function line(msg: string): void {
  channel().appendLine(`${PREFIX} ${msg}`);
}

export function connected(detail?: string): void {
  line(detail ? `Connected (${detail})` : "Connected");
}

export function disconnected(detail?: string): void {
  line(detail ? `Disconnected (${detail})` : "Disconnected");
}

export function change(dir: "VS Code ---> Studio" | "Studio ---> VS Code", summary: string): void {
  line(`${dir}: ${summary}`);
}

export function errorLine(msg: string): void {
  line(`error: ${msg}`);
}

function capitalizeAction(t: Change["type"]): string {
  const map: Record<Change["type"], string> = {
    create: "Create",
    delete: "Delete",
    update: "Update",
    rename: "Rename",
  };
  return map[t] ?? (t ? t.charAt(0).toUpperCase() + t.slice(1) : "?");
}

export function formatChangeSummary(c: Change): string {
  const p = c.instancePath;
  const act = capitalizeAction(c.type);
  if (c.type === "rename" && c.oldName != null && c.newName != null) {
    return `${act} ${p} (${c.oldName} -> ${c.newName})`;
  }
  // Updates: instance path only; ".Property" reads like hierarchy (e.g. LocalScript.Source).
  return `${act} ${p}`;
}
