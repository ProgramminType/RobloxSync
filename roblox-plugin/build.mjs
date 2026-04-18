import * as fs from "fs";
import * as path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const srcDir = path.join(__dirname, "src");
const outFile = path.join(__dirname, "RobloxStudioSync.server.lua");
const apiDumpPath = path.join(__dirname, "..", "vscode-extension", "resources", "api-dump.json");

const IGNORED_PROPERTIES = new Set([
  "Parent", "ClassName", "Archivable", "DataCost", "RobloxLocked",
]);

const EXCLUDED_TAGS = new Set([
  "ReadOnly", "NotScriptable", "Hidden", "Deprecated",
]);

const UNSUPPORTED_TYPES = new Set([
  "Instance", "Objects", "RBXScriptSignal", "RBXScriptConnection",
  "Function", "Connection", "Array", "Dictionary", "Map", "Tuple",
  "ProtectedString", "BinaryString", "SharedTable", "OptionalCoordinateFrame",
  "Content", "UniqueId",
]);

function generatePropertyDatabase() {
  if (!fs.existsSync(apiDumpPath)) {
    console.warn("Warning: api-dump.json not found, using empty property database");
    return "_modules[\"PropertyDatabase\"] = function()\nreturn { data = {} }\nend\n\n";
  }

  const dump = JSON.parse(fs.readFileSync(apiDumpPath, "utf-8"));
  const db = {};

  for (const cls of dump.Classes) {
    const superclass = cls.Superclass || null;
    const props = [];

    for (const member of cls.Members) {
      if (member.MemberType !== "Property") continue;
      if (IGNORED_PROPERTIES.has(member.Name)) continue;

      const tags = member.Tags || [];
      if (tags.some((t) => EXCLUDED_TAGS.has(t))) continue;

      const typeName = member.ValueType?.Name;
      if (UNSUPPORTED_TYPES.has(typeName)) continue;
      if (member.ValueType?.Category === "Class") continue;

      const sec = member.Security;
      if (sec && typeof sec === "object" && sec.Write && sec.Write !== "None") continue;

      // Skip properties with special characters that can't be accessed via dot notation
      if (/[^a-zA-Z0-9_]/.test(member.Name)) continue;

      props.push(member.Name);
    }

    if (props.length > 0 || superclass) {
      db[cls.Name] = { superclass, props };
    }
  }

  let lua = '_modules["PropertyDatabase"] = function()\nlocal db = {}\n';

  for (const [className, info] of Object.entries(db)) {
    const escName = className.replace(/"/g, '\\"');
    const superStr = info.superclass ? `"${info.superclass.replace(/"/g, '\\"')}"` : "nil";
    const propsStr = info.props.map((p) => `"${p.replace(/"/g, '\\"')}"`).join(",");
    lua += `db["${escName}"]={super=${superStr},props={${propsStr}}}\n`;
  }

  lua += "return { data = db }\nend\n\n";
  return lua;
}

const modules = [
  "modules/Config.lua",
  "modules/PropertyHandler.lua",
  "modules/UI.lua",
  "modules/HttpClient.lua",
  "modules/Serializer.lua",
  "modules/Deserializer.lua",
  "modules/DuplicateSiblingWatcher.lua",
  "modules/ChangeDetector.lua",
];

function readModule(relPath) {
  return fs.readFileSync(path.join(srcDir, relPath), "utf-8");
}

function buildPlugin() {
  const moduleContents = {};
  for (const modPath of modules) {
    const modName = path.basename(modPath, ".lua");
    moduleContents[modName] = readModule(modPath);
  }

  const entrySource = readModule("init.server.lua");

  let output = `--[=[
  Roblox Sync Plugin v1.5.0
  Auto-generated — do not edit directly.
  Edit the source files in roblox-plugin/src/ instead.
]=]

`;

  output += `local _modules = {}
local _loaded = {}

local function _require(name)
  if _loaded[name] then
    return _loaded[name]
  end
  local loader = _modules[name]
  if not loader then
    error("Module not found: " .. name)
  end
  _loaded[name] = loader()
  return _loaded[name]
end

`;

  // Emit the auto-generated PropertyDatabase module
  output += generatePropertyDatabase();

  for (const [modName, source] of Object.entries(moduleContents)) {
    let transformed = source
      .replace(/require\(script\.Parent\.(\w+)\)/g, '_require("$1")')
      .replace(/require\(script\.modules\.(\w+)\)/g, '_require("$1")');

    output += `_modules["${modName}"] = function()\n${transformed}\nend\n\n`;
  }

  let entryTransformed = entrySource
    .replace(/require\(script\.modules\.(\w+)\)/g, '_require("$1")')
    .replace(/require\(script\.Parent\.(\w+)\)/g, '_require("$1")');

  output += `-- Entry point\n`;
  output += `do\n${entryTransformed}\nend\n`;

  fs.writeFileSync(outFile, output, "utf-8");
  console.log(`Plugin built: ${outFile}`);
  console.log(`Size: ${(fs.statSync(outFile).size / 1024).toFixed(1)} KB`);
}

buildPlugin();
