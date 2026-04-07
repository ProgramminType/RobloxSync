import { getOutputChannel } from "./syncLog";

/** Legacy alias — same channel as syncLog. */
export function getDebugChannel(): ReturnType<typeof getOutputChannel> {
  return getOutputChannel();
}
