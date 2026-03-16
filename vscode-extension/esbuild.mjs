import * as esbuild from "esbuild";
import * as fs from "fs";
import * as path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const production = process.argv.includes("--production");
const watch = process.argv.includes("--watch");

// Copy the built Roblox plugin into resources/ so it ships inside the .vsix
const pluginSrc = path.join(__dirname, "..", "roblox-plugin", "RobloxStudioSync.server.lua");
const pluginDest = path.join(__dirname, "resources", "RobloxStudioSync.server.lua");
if (fs.existsSync(pluginSrc)) {
  fs.copyFileSync(pluginSrc, pluginDest);
  console.log("Copied Roblox plugin into resources/");
} else {
  console.warn("Warning: roblox-plugin/RobloxStudioSync.server.lua not found — run 'node build.mjs' in roblox-plugin/ first");
}

/** @type {import('esbuild').BuildOptions} */
const buildOptions = {
  entryPoints: ["src/extension.ts"],
  bundle: true,
  outfile: "dist/extension.js",
  external: ["vscode"],
  format: "cjs",
  platform: "node",
  target: "node18",
  sourcemap: !production,
  minify: production,
  loader: { ".json": "json" },
};

if (watch) {
  const ctx = await esbuild.context(buildOptions);
  await ctx.watch();
  console.log("Watching for changes...");
} else {
  await esbuild.build(buildOptions);
  console.log("Build complete.");
}
