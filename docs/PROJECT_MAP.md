# Project Map

This document provides a high-level overview of the Trilium Notes project structure.

- **`electron.js`**: This file is the main entry point for the Electron application. It is responsible for creating and managing the application windows, handling inter-process communication (IPC) between the main process and renderer processes, and managing the overall lifecycle of the Electron application (e.g., startup, quit, window management).

- **`src/app.js`**: This file sets up the main Express application. It configures middleware (like body parsers, security headers, session management), defines global error handlers, and mounts the various route handlers. It's the core of the backend server logic.

- **`src/www.js`**: This script is responsible for starting the HTTP and/or HTTPS server. It imports the Express app from `src/app.js`, configures the port and SSL certificates (if applicable), and starts listening for incoming requests. It also often serves as the command-line interface (CLI) entry point for starting the server.

- **`src/services/`**: This directory contains the core backend logic and business rules of the application. Services in this directory typically handle tasks like database interactions (CRUD operations), data processing, interacting with external APIs, and implementing specific features of the application. They are called by the route handlers.

- **`src/routes/`**: This directory defines the API route handlers for the backend. Each file typically corresponds to a group of related API endpoints (e.g., notes, attachments, search). These handlers receive HTTP requests, validate input, call appropriate service methods, and send back HTTP responses.

- **`src/becca/`**: This directory appears to contain core data structures, entities, and logic related to the underlying data model of Trilium Notes. "Becca" might be an internal name for this core component, which likely manages notes, attributes, branches, and their relationships.

- **`src/public/app/`**: This directory houses the frontend application code. This includes JavaScript files for client-side logic (e.g., UI interactions, API calls to the backend, data rendering), HTML templates, CSS stylesheets, and potentially frontend frameworks or libraries used to build the user interface.

- **`webpack.config.js`**: This file configures Webpack, a module bundler. It defines how frontend assets (JavaScript, CSS, images, etc.) should be processed, bundled, and optimized for production. It specifies entry points, output locations, loaders for different file types, and plugins for various build tasks.

- **`package.json`**: This is the project's manifest file. It lists dependencies, development dependencies, and defines key npm scripts for various tasks:
    - **Build scripts**: (e.g., `webpack`, `build-frontend`, `build-backend-docs`) Commands to compile/bundle assets, generate documentation.
    - **Development scripts**: (e.g., `start-server`, `start-electron`, `dev`) Commands to start development servers, run the application in development mode, or watch for file changes.
    - **Test scripts**: (e.g., `test`) Commands to execute automated tests.
