#!/usr/bin/env bash
# uninstall.sh - Remove OpenClaw Lite from Termux
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}========================================${NC}"
echo -e "${BOLD}  OpenClaw Lite - Uninstaller${NC}"
echo -e "${BOLD}========================================${NC}"
echo ""

# Confirm
read -rp "This will remove OpenClaw and all related config. Continue? [y/N] " REPLY
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo ""

# 1. Uninstall OpenClaw npm package
echo "Removing OpenClaw npm package..."
if command -v openclaw &>/dev/null; then
    npm uninstall -g openclaw 2>/dev/null || true
    echo -e "${GREEN}[OK]${NC}   openclaw package removed"
else
    echo -e "${YELLOW}[SKIP]${NC} openclaw not installed"
fi

# 2. Remove openclaw-lite directory
if [ -d "$HOME/.openclaw-lite" ]; then
    rm -rf "$HOME/.openclaw-lite"
    echo -e "${GREEN}[OK]${NC}   Removed $HOME/.openclaw-lite"
else
    echo -e "${YELLOW}[SKIP]${NC} $HOME/.openclaw-lite not found"
fi

# 3. Remove environment block from .bashrc
BASHRC="$HOME/.bashrc"
MARKER_START="# >>> OpenClaw Lite Android >>>"
MARKER_END="# <<< OpenClaw Lite Android <<<"

if [ -f "$BASHRC" ] && grep -qF "$MARKER_START" "$BASHRC"; then
    sed -i "/${MARKER_START//\//\\/}/,/${MARKER_END//\//\\/}/d" "$BASHRC"
    # Remove any trailing blank lines left behind
    sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$BASHRC"
    echo -e "${GREEN}[OK]${NC}   Removed environment block from $BASHRC"
else
    echo -e "${YELLOW}[SKIP]${NC} No environment block found in $BASHRC"
fi

# 4. Clean up temp directory
if [ -d "$PREFIX/tmp/openclaw" ]; then
    rm -rf "$PREFIX/tmp/openclaw"
    echo -e "${GREEN}[OK]${NC}   Removed $PREFIX/tmp/openclaw"
fi

# 5. Optionally remove openclaw data
echo ""
if [ -d "$HOME/.openclaw" ]; then
    read -rp "Remove OpenClaw data directory ($HOME/.openclaw)? [y/N] " REPLY
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        rm -rf "$HOME/.openclaw"
        echo -e "${GREEN}[OK]${NC}   Removed $HOME/.openclaw"
    else
        echo -e "${YELLOW}[KEEP]${NC} Keeping $HOME/.openclaw"
    fi
fi

echo ""
echo -e "${GREEN}${BOLD}Uninstall complete.${NC}"
echo "Restart your Termux session to clear environment variables."
echo ""
