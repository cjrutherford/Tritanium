#!/bin/bash

# init-dev-env.sh
# Script to initialize the development environment for Trilium Notes

echo "Starting Trilium Notes development environment setup..."

# Function to check if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# 1. Check for Prerequisites
echo "Checking prerequisites..."

if ! command_exists git; then
    echo "Error: Git is not installed. Please install Git and try again."
    exit 1
fi

if ! command_exists node; then
    echo "Error: Node.js is not installed. Please install Node.js (recommended LTS version) and try again."
    exit 1
fi

if ! command_exists npm; then
    echo "Error: npm is not installed. Please install npm (usually comes with Node.js) and try again."
    exit 1
fi

echo "Prerequisites check passed."

# 2. Install Dependencies
echo "Installing project dependencies using npm..."
if npm install; then
    echo "npm install completed successfully."
else
    echo "Error during npm install. Please check the output above for details."
    echo "Ensure you have Python and a C++ compiler installed for native module compilation (e.g., better-sqlite3)."
    echo "On Debian/Ubuntu, you might need: sudo apt-get install build-essential python3"
    exit 1
fi

# 3. Configure the Application
echo "Configuring the application..."
if [ ! -f "config.ini" ]; then
    echo "config.ini not found. Copying config-sample.ini to config.ini..."
    if cp config-sample.ini config.ini; then
        echo "config.ini copied successfully."
        echo "Please review config.ini and adjust settings if needed (e.g., dataDir, port)."
    else
        echo "Error copying config-sample.ini. Please do this manually."
        exit 1
    fi
else
    echo "config.ini already exists. Skipping copy."
fi

# 4. Build Frontend Assets
echo "Building frontend assets using Webpack..."
if npm run webpack; then
    echo "Webpack build completed successfully."
else
    echo "Error during Webpack build. Please check the output above for details."
    exit 1
fi

echo ""
echo "Development environment setup completed!"
echo ""
echo "Next Steps:"
echo "1. Review 'config.ini' for any custom configurations."
echo "2. To run the Trilium server: npm run start-server"
echo "   (Access at http://localhost:8080 by default)"
echo "3. To run the Trilium Electron desktop application: npm run start-electron"
echo "   (Remember to use 'npm run qswitch-electron' if you were previously running the server and encounter native module issues, and 'npm run qswitch-server' before switching back to server)."
echo "4. To run tests: npm run test"
echo ""
echo "Refer to SETUP.md for more detailed instructions and troubleshooting."

exit 0
