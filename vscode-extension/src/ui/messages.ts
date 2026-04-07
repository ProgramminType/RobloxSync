/**
 * User-visible notification copy (information / warning / error toasts).
 * Edit strings here only.
 */

export const UI = {
  workspaceReadyToEdit: "Roblox Sync: Workspace is synced and ready to edit.",

  alreadyConnected: "Roblox Sync: Workspace is already synced.",

  pluginBundledMissing: "Roblox Sync: Bundled plugin file not found. The extension may be corrupted.",

  localAppDataMissing: "Roblox Sync: Could not find LOCALAPPDATA directory.",

  pluginInstalled: (dest: string) => `Roblox Sync: Studio plugin installed to ${dest}.`,

  cursorModeEnabled: "Roblox Sync: Cursor mode enabled.",
  cursorModeDisabled: "Roblox Sync: Cursor mode disabled.",

  serverStartFailed: (detail: string) => `Roblox Sync: Workspace could not be synced, ${detail}.`,

  disconnected: "Roblox Sync: Workspace disconnected.",

  protectedServiceRestored: (serviceName: string) =>
    `Roblox Sync: Cannot delete ${serviceName}, it's a protected Roblox service and has been restored.`,
} as const;
