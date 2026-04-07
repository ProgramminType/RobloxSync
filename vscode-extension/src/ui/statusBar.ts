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
    this.item.tooltip = "Roblox Sync — listening for Studio. Plugin connects automatically when HTTP is enabled.";
    this.item.command = undefined;
    this.item.backgroundColor = undefined;
  }

  setDisconnected(): void {
    this.item.text = "$(debug-disconnect) Roblox Sync";
    this.item.tooltip = "Roblox Sync — not listening. Click to run Connect to Studio.";
    this.item.command = "robloxSync.connect";
    this.item.backgroundColor = new vscode.ThemeColor("statusBarItem.warningBackground");
  }

  setPluginConnected(): void {
    this.item.text = "$(check) Roblox Sync (Studio)";
    this.item.tooltip = "Roblox Studio Sync — Studio connected.";
    this.item.command = undefined;
  }

  dispose(): void {
    this.item.dispose();
  }
}
