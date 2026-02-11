#!/usr/bin/env bash
# install-deps.sh - Install required Termux packages
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=== Installing Dependencies ==="
echo ""

# Update package repos
echo "Updating package repositories..."
pkg update -y

# Install required packages
PACKAGES=(
    nodejs-lts
    git
    python
    make
    cmake
    clang
    tmux
    termux-api
)

echo "Installing packages: ${PACKAGES[*]}"
pkg install -y "${PACKAGES[@]}"

echo ""

# Verify Node.js version
if ! command -v node &>/dev/null; then
    echo -e "${RED}[FAIL]${NC} Node.js installation failed"
    exit 1
fi

NODE_VER=$(node -v)
NODE_MAJOR=$(echo "$NODE_VER" | sed 's/v\([0-9]*\).*/\1/')

echo -e "${GREEN}[OK]${NC}   Node.js $NODE_VER installed"

if [ "$NODE_MAJOR" -lt 22 ]; then
    echo -e "${RED}[FAIL]${NC} Node.js >= 22 required, got $NODE_VER"
    echo "       Try: pkg install nodejs-lts"
    exit 1
fi

# Verify npm
if ! command -v npm &>/dev/null; then
    echo -e "${RED}[FAIL]${NC} npm not found"
    exit 1
fi

NPM_VER=$(npm -v)
echo -e "${GREEN}[OK]${NC}   npm $NPM_VER installed"

echo ""
echo -e "${GREEN}All dependencies installed.${NC}"
