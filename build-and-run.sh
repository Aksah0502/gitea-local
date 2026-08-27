#!/bin/bash

echo "================================"
echo "   Gitea Build & Run Script"
echo "================================"


############################################################
# Add Go to PATH if not already present
if [[ ":$PATH:" != *":/c/Program Files/Go/bin:"* ]]; then
    export PATH="/c/Program Files/Go/bin:$PATH"
fi

# Add Git to PATH if not already present
if [[ ":$PATH:" != *":/c/Program Files/Git/cmd:"* ]]; then
    export PATH="/c/Program Files/Git/cmd:$PATH"
fi

# Add MSYS2 UCRT64 tools to PATH if not already present
if [[ ":$PATH:" != *":/ucrt64/bin:"* ]]; then
    export PATH="/ucrt64/bin:$PATH"
fi

# Add Git to PATH if not already present
if [[ ":$PATH:" != *":/c/Program Files/Git/cmd:"* ]]; then
    export PATH="/c/Program Files/Git/cmd:$PATH"
fi

# Add Node.js to PATH if not already present
if [[ ":$PATH:" != *":/c/nvm4w/nodejs:"* ]]; then
    export PATH="/c/nvm4w/nodejs:$PATH"
fi

# Add npm global packages to PATH if not already present
if [[ ":$PATH:" != *":/c/Users/$USERNAME/AppData/Roaming/npm:"* ]]; then
    export PATH="/c/Users/$USERNAME/AppData/Roaming/npm:$PATH"
fi

############################################################

############################################################

echo ""
echo "================================"
echo "   Checking Required Tools"

if ! command -v go &> /dev/null; then
    echo "ERROR: Go is not installed."
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js is not installed."
    exit 1
fi

if ! command -v pnpm &> /dev/null; then
    echo "ERROR: pnpm is not installed."
    exit 1
fi

if ! command -v make &> /dev/null; then
    echo "ERROR: Make is not installed."
    exit 1
fi

if ! command -v gcc &> /dev/null; then
    echo "ERROR: GCC is not installed."
    exit 1
fi

echo "All required tools are installed."
echo "================================"
############################################################


#############################################################
echo ""
echo "================================"
echo "   Checking Tool Versions"
echo "================================"

echo "Go:   $(go version)"
echo "Node: $(node --version)"
echo "npm:  $(npm --version)"
echo "pnpm: $(pnpm --version)"
echo "Git:  $(git --version)"
echo "Make: $(make --version | head -n 1)"
echo "GCC:  $(gcc --version | head -n 1)"
echo "G++:  $(g++ --version | head -n 1)"
############################################################

############################################################


#######################################################
echo ""
echo "================================"
echo "   Checking Gitea project directory...   "


SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

if [[ ! -f "Makefile" || ! -f "go.mod" ]]; then
    echo "ERROR: This does not appear to be the Gitea project directory."
    echo "Makefile or go.mod not found."
    exit 1
fi

echo "Project directory verified:"
echo "$SCRIPT_DIR"
echo "================================"
#######################################################

#######################################################
echo ""
echo "================================"
echo "Building Gitea from source..."

TAGS="bindata sqlite sqlite_unlock_notify" make build

if [ $? -ne 0 ]; then  #Ensure the Gitea is already not running, if running then stop
    echo "ERROR: Gitea build failed."
    exit 1
fi

echo ""
echo "Gitea build completed successfully."
echo "================================"
#####################################################

####################################################
echo ""
echo "================================"
echo "Checking Gitea binary..."

if [[ ! -f "gitea.exe" ]]; then
    echo "ERROR: gitea.exe was not created."
    exit 1
fi

echo "Gitea binary found successfully."
echo "================================"
#####################################################

#####################################################
echo ""
echo "================================"
echo "Checking port 3000..."

if netstat -ano | grep -q ":3000"; then
    echo "ERROR: Port 3000 is already in use."
    echo "Please stop the application using port 3000 and try again."
    exit 1
fi

echo "Port 3000 is available."
echo "================================"
#####################################################


#####################################################
echo ""
echo "================================"
echo "Starting Gitea..."
echo "Local URL: http://localhost:3000"
echo "================================"
echo ""

./gitea.exe web

if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: Gitea failed to start."
    echo "================================"
    exit 1
fi
#######################################################


