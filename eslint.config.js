// @ts-check
/// <reference types="@types/node" />

import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  eslint.configs.recommended,
  ...tseslint.configs.recommendedTypeChecked,
  {
    languageOptions: {
      parserOptions: {
        project: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
  },
  {
    ignores: ["app/assets/builds/", "app/assets/config/", "eslint.config.js", "rollup.config.js"]
  }
);
