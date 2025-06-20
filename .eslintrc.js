module.exports = {
  root: true,
  parser: '@typescript-eslint/parser', // Specifies the ESLint parser for TypeScript
  plugins: [
    '@typescript-eslint', // Enables TypeScript-specific linting rules
    'prettier', // Integrates Prettier with ESLint
  ],
  extends: [
    'eslint:recommended', // Base ESLint recommended rules
    'plugin:@typescript-eslint/recommended', // Recommended rules from @typescript-eslint/eslint-plugin
    'prettier', // Uses eslint-config-prettier to disable ESLint rules from @typescript-eslint/eslint-plugin that would conflict with prettier
    'plugin:prettier/recommended', // Enables eslint-plugin-prettier and displays prettier errors as ESLint errors. Make sure this is always the last configuration in the extends array.
  ],
  parserOptions: {
    ecmaVersion: 2020, // Allows for the parsing of modern ECMAScript features
    sourceType: 'module', // Allows for the use of imports
    ecmaFeatures: {
      jsx: true, // Allows for the parsing of JSX
    },
  },
  env: {
    node: true, // Enables Node.js global variables and Node.js scoping.
    browser: true, // Enables browser global variables.
    es6: true, // Enables ES6 global variables.
    jquery: true, // Enables jQuery global variables (useful for existing frontend code)
  },
  rules: {
    // Place to specify ESLint rules. Can be used to overwrite rules specified from the extended configs
    // e.g. "@typescript-eslint/explicit-function-return-type": "off",
    'prettier/prettier': ['error', { endOfLine: 'auto' }], // Avoid CRLF issues with Prettier
    '@typescript-eslint/no-explicit-any': 'warn', // Warn on 'any' type
    '@typescript-eslint/no-var-requires': 'off', // Allow 'require' statements for now, as it's a JS to TS migration
    'no-unused-vars': 'off', // Disable base rule as @typescript-eslint/no-unused-vars is used
    '@typescript-eslint/no-unused-vars': ['warn', { 'argsIgnorePattern': '^_' }],
  },
  settings: {
    react: {
      version: 'detect', // Tells eslint-plugin-react to automatically detect the version of React to use
    },
  },
  ignorePatterns: [
    'node_modules/',
    'dist/',
    'build/',
    'coverage/',
    'src/public/app-dist/',
    'src/public/libs/', // Assuming libs are third-party
    'libraries/',
    'docs/', // JSDoc generated files
    'bin/better-sqlite3/',
    '*.md' // Don't lint markdown files
  ],
};
