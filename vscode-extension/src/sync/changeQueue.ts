import { Change } from "../types";

export class ChangeQueue {
  private pendingForStudio: Change[] = [];
  private paused = false;

  enqueue(change: Change): void {
    if (this.paused) {
      return;
    }
    this.pendingForStudio.push(change);
  }

  drain(): Change[] {
    const changes = this.pendingForStudio;
    this.pendingForStudio = [];
    return changes;
  }

  pause(): void {
    this.paused = true;
  }

  resume(): void {
    this.paused = false;
  }

  isPaused(): boolean {
    return this.paused;
  }

  get length(): number {
    return this.pendingForStudio.length;
  }
}
