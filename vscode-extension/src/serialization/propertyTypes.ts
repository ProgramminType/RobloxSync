/**
 * Encodes Roblox property values from the wire format (as sent by the plugin)
 * into the human-readable JSON format used on disk, and decodes them back.
 *
 * The plugin sends values already serialized (Vector3 as [x,y,z], etc.),
 * so for the on-disk format we mostly pass through. The decode path converts
 * human-edited JSON back to the wire format the plugin expects.
 */

export function encodePropertyValue(value: unknown, typeName: string): unknown {
  // Most types are already in the right format from the plugin serializer.
  // This function exists to normalize or pretty-print if needed.
  if (value === null || value === undefined) {
    return undefined;
  }

  if (typeName === "BrickColor" || typeName === "string") {
    return value;
  }

  if (typeName === "EnumItem" && typeof value === "string") {
    // Strip the "Enum.X." prefix for readability on disk
    const parts = (value as string).split(".");
    if (parts.length === 3) {
      return parts[2];
    }
    return value;
  }

  return value;
}

export function decodePropertyValue(
  value: unknown,
  typeName: string,
  enumTypeName?: string
): unknown {
  if (value === null || value === undefined) {
    return undefined;
  }

  if (typeName === "EnumItem" && typeof value === "string" && enumTypeName) {
    // If user wrote just "Plastic", expand to "Enum.Material.Plastic"
    if (!(value as string).startsWith("Enum.")) {
      return `Enum.${enumTypeName}.${value}`;
    }
    return value;
  }

  return value;
}

/**
 * Strips default values to keep JSON files compact.
 * Returns true if the value equals the default for this property type.
 */
export function isDefaultValue(value: unknown, typeName: string): boolean {
  if (value === undefined || value === null) {
    return true;
  }

  switch (typeName) {
    case "bool":
      return value === false;
    case "float":
    case "double":
    case "int":
    case "int64":
      return value === 0;
    case "string":
      return value === "";
    default:
      return false;
  }
}
