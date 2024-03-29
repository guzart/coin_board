import resolve from "@rollup/plugin-node-resolve";
import typescript from "@rollup/plugin-typescript";

export default {
  input: "app/javascript/application.ts",
  output: {
    file: "app/assets/builds/application.js",
    format: "esm",
    inlineDynamicImports: true,
    sourcemap: true,
  },
  plugins: [resolve(), typescript()],
};
