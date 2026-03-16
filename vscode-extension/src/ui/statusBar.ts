import * as vscode from "vscode";

export class StatusBarManager implements vscode.Disposable {
  private item: vscode.StatusBarItem;

  constructor() {
    this.item = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
    this.setDisconnected();
    this.item.show();
  }

  setConnected(port: number): void {
    this.item.text = `$(plug) Roblox Sync :${port}`;
    this.item.tooltip = "Roblox Studio Sync — Server running. Click to stop.";
    this.item.command = "robloxSync.disconnect";
    this.item.backgroundColor = undefined;
  }

  setDisconnected(): void {
    this.item.text = "$(debug-disconnect) Roblox Sync";
    this.item.tooltip = "Roblox Studio Sync — Not running. Click to start.";
    this.item.command = "robloxSync.connect";
    this.item.backgroundColor = new vscode.ThemeColor("statusBarItem.warningBackground");
  }

  setPluginConnected(): void {
    this.item.text = "$(check) Roblox Sync (Studio Connected)";
    this.item.tooltip = "Roblox Studio Sync — Studio plugin connected.";
    this.item.command = "robloxSync.disconnect";
  }

  dispose(): void {
    this.item.dispose();
  }
}
