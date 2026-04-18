/**
 * Resolve the public experience title (matches Creator / Studio title bar) using Roblox public HTTP APIs.
 * Studio's HttpService is often blocked or flaky; the VS Code host can call these reliably.
 */

export async function resolveExperienceTitleFromPlaceId(placeId: number): Promise<string | null> {
  if (placeId <= 0) {
    return null;
  }
  try {
    const uniRes = await fetch(`https://apis.roblox.com/universes/v1/places/${placeId}/universe`, {
      headers: { Accept: "application/json" },
    });
    if (!uniRes.ok) {
      return null;
    }
    const uni = (await uniRes.json()) as { universeId?: number };
    const uid = uni.universeId;
    if (typeof uid !== "number" || uid <= 0) {
      return null;
    }
    return await resolveExperienceTitleFromUniverseId(uid);
  } catch {
    return null;
  }
}

export async function resolveExperienceTitleFromUniverseId(universeId: number): Promise<string | null> {
  if (universeId <= 0) {
    return null;
  }
  try {
    const gameRes = await fetch(`https://games.roblox.com/v1/games?universeIds=${universeId}`, {
      headers: { Accept: "application/json" },
    });
    if (!gameRes.ok) {
      return null;
    }
    const game = (await gameRes.json()) as { data?: { name?: string }[] };
    const name = game.data?.[0]?.name;
    if (typeof name === "string" && name.trim() !== "") {
      return name.trim();
    }
  } catch {
    return null;
  }
  return null;
}
