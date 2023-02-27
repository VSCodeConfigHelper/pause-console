// @ts-check
import { defineConfig } from "rollup";
import nodeResolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import typescript from "@rollup/plugin-typescript";

export default defineConfig({
  input: "src/extension.ts",
  output: {
    file: "dist/extension.js",
    format: "cjs",
  },
  external: ["vscode"],
  plugins: [
    nodeResolve(),
    commonjs(),
    typescript()
  ]
});
