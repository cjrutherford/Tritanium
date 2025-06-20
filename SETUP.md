# Project Setup Guide

This guide provides step-by-step instructions to set up and run the Trilium Notes project locally for development and testing.

## 1. Prerequisites

- Node.js (version specified in `package.json` or latest LTS)
- npm (comes with Node.js)
- Git
- Python (for some native Node module builds - specify version if known, otherwise suggest latest)
- C++ compiler (e.g., GCC, Visual Studio Build Tools - for some native Node module builds)

## 2. Clone the Repository

```bash
git clone https://github.com/zadam/trilium.git
cd trilium
```

## 3. Install Dependencies

Install project dependencies using npm:

```bash
npm install
```
**Note on Native Modules (`better-sqlite3`):** This project uses `better-sqlite3`, which is a native Node.js module. Installation might require build tools (Python, C++ compiler). If you encounter issues during `npm install`, ensure these are correctly installed and configured in your system's PATH. On some systems, you might need to install additional development libraries (e.g., `build-essential` on Debian/Ubuntu for `make`, `g++`, etc.). If `better-sqlite3` fails to build, you might try installing it with `--ignore-scripts` and using prebuilt binaries if available for your platform (though this is generally for deployment, not development).

## 4. Configure the Application

Trilium uses a configuration file for various settings.

1.  Copy the sample configuration file:
    ```bash
    cp config-sample.ini config.ini
    ```
2.  Review `config.ini` and adjust settings as needed. For a basic local setup, the defaults are often sufficient. Key settings include:
    *   `dataDir`: Path to the directory where Trilium will store its data. Default is `data` in the project root.
    *   `port`: Port for the Trilium server. Default is 8080.

## 5. Build Frontend Assets

The project uses Webpack to bundle frontend assets.

```bash
npm run webpack
```
This command will generate bundled files in the `src/public/app-dist/` directory.

## 6. Running the Application

You can run Trilium as a server application or as a desktop application using Electron.

### 6.1. Running the Server

To start the Trilium server:

```bash
npm run start-server
```
This script typically sets environment variables like `TRILIUM_DATA_DIR` and `TRILIUM_ENV`. By default, it will use the `./data` directory for application data. Access the application in your browser at `http://localhost:8080` (or the port specified in `config.ini`).

### 6.2. Running the Electron Desktop Application

To start the Trilium desktop application:

```bash
npm run start-electron
```
This will launch the application in an Electron window. It also typically sets development environment variables.

**Note on `better-sqlite3` context:**
The `better-sqlite3` module needs to be compiled for the correct Node.js runtime (Node.js server vs. Electron's embedded Node.js). The `package.json` includes scripts like `qswitch-server` and `qswitch-electron` which seem to handle swapping the correct `better_sqlite3.node` binary. If you switch between running as a server and running in Electron and encounter `better-sqlite3` errors, you might need to use these scripts or ensure the correct version of the native module is being used. For example, before `npm run start-electron`, you might need `npm run qswitch-electron`.

## 7. Running Tests

The project includes tests that can be run using npm:

```bash
npm run test
```
This command typically executes both Jasmine tests and ES6 specific tests as defined in `package.json`. Ensure the test server (if required by tests) can run, which might involve setting a specific `TRILIUM_DATA_DIR` for tests (e.g., `./data-test` as seen in `start-test-server` script).

## 8. Troubleshooting

*   **`better-sqlite3` build errors:**
    *   Ensure Python and a C++ compiler are installed and in PATH.
    *   Try deleting `node_modules/better-sqlite3` and running `npm install` again.
    *   On Linux, you might need `sudo apt-get install build-essential python3`.
    *   Refer to the `better-sqlite3` documentation for platform-specific troubleshooting.
*   **Port conflicts:** If `EADDRINUSE` error occurs, ensure no other application (including another Trilium instance) is using the configured port.
*   **Electron specific issues:** Consult Electron documentation for general Electron development issues. Ensure you have the correct version of Electron installed (as per `package.json`).

This guide should help you get Trilium Notes up and running for development. Refer to other documentation files (`README.md`, `PROJECT_MAP.md`, `BUILD_AND_STARTUP.md`) for more details on the project's architecture and features.
