export interface InstanceData {
  id: string;
  className: string;
  name: string;
  properties: Record<string, unknown>;
  children: InstanceData[];
}

export type ChangeType = "create" | "update" | "delete" | "rename";

export interface Change {
  type: ChangeType;
  /** Dot-delimited instance path, e.g. "Workspace.MyModel.Part1" */
  instancePath: string;
  instanceData?: InstanceData;
  property?: string;
  value?: unknown;
  oldName?: string;
  newName?: string;
  timestamp: number;
}

export interface SessionState {
  connected: boolean;
  sessionId: string | null;
  lastFullSync: number | null;
}

export interface ApiClass {
  Name: string;
  Superclass: string;
  Members: ApiMember[];
  Tags?: string[];
}

export interface ApiMember {
  MemberType: "Property" | "Function" | "Event" | "Callback";
  Name: string;
  Security?: { Read?: string; Write?: string } | string;
  Serialization?: { CanLoad?: boolean; CanSave?: boolean };
  ValueType?: { Category: string; Name: string };
  Tags?: string[];
}

export interface ApiDump {
  Classes: ApiClass[];
  Enums: { Name: string; Items: { Name: string; Value: number }[] }[];
}

export const SCRIPT_EXTENSIONS: Record<string, string> = {
  Script: ".server.lua",
  LocalScript: ".client.lua",
  ModuleScript: ".lua",
};

export const EXTENSION_TO_CLASS: Record<string, string> = {
  ".server.lua": "Script",
  ".client.lua": "LocalScript",
  ".lua": "ModuleScript",
};

export const SYNCED_SERVICES = [
  "Workspace",
  "Players",
  "Lighting",
  "MaterialService",
  "ReplicatedFirst",
  "ReplicatedStorage",
  "ServerScriptService",
  "ServerStorage",
  "StarterGui",
  "StarterPack",
  "StarterPlayer",
  "SoundService",
  "Teams",
  "TextChatService",
];

export const META_FILENAME = "init.meta.json";

export const DEFAULT_PORT = 34872;
