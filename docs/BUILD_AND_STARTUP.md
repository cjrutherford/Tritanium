# Build and Startup Guide

This document provides instructions on how to build and start the Trilium Notes application.

## Configuration

Before building or starting the application, you may need to configure it. A sample configuration file is provided as `config-sample.ini`. You can copy this file to `config.ini` (or a location specified by the `TRILIUM_CONFIG_PATH` environment variable) and modify it to suit your needs. This file typically contains settings for the database, server port, data directory, and other application-specific options.

## Building the Application

The primary build process for the frontend assets is managed by Webpack. Key scripts related to building are defined in `package.json`:

- **`npm run webpack`**: This is typically the main command to trigger a frontend build. It uses `webpack.config.js` to bundle JavaScript, CSS, and other assets into optimized files ready for deployment. These are usually placed in a `dist` or `public/build` directory.
- **`npm run build-frontend`**: This script might be an alias for `npm run webpack` or could include additional frontend build steps like minification or asset copying.
- **`npm run build-backend-docs`**: Generates JSDoc documentation for the backend code.
- **`npm run build-frontend-docs`**: Generates JSDoc documentation for the frontend code.

To perform a full build, you might need to run several of these scripts, or there might be a master build script available (check `package.json` for scripts like `build` or `ci-build`).

## Starting the Application

There are two main ways to start Trilium:

1.  **Starting the Server (`npm run start-server`)**:
    This command starts the backend Node.js/Express server. It typically executes the `src/www.js` script. Once started, you can usually access the web version of Trilium by navigating to `http://localhost:[configured_port]` in your web browser.

2.  **Starting the Electron Application (`npm run start-electron`)**:
    This command launches the desktop application using Electron. It will typically:
    *   Ensure the backend server is running (it might start it internally or expect it to be started separately).
    *   Execute the `electron.js` script, which creates the main application window and loads the frontend.

    This is the recommended way to run Trilium as a desktop application.

Refer to the `scripts` section in `package.json` for the exact commands and any variations (e.g., development mode with auto-reloading via `npm run dev`).
