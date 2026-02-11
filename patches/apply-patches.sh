#!/usr/bin/env bash
# apply-patches.sh - Apply all patches for OpenClaw on Termux
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_DEST="$HOME/.openclaw-lite/patches"
LOG_FILE="$HOME/.openclaw-lite/patch.log"

echo "=== Applying Patches ==="
echo ""

# Ensure destination exists
mkdir -p "$PATCH_DEST"

# Start logging
echo "Patch application started: $(date)" > "$LOG_FILE"

# 1. Copy bionic-compat.js
if [ -f "$SCRIPT_DIR/bionic-compat.js" ]; then
    cp "$SCRIPT_DIR/bionic-compat.js" "$PATCH_DEST/bionic-compat.js"
    echo -e "${GREEN}[OK]${NC}   Copied bionic-compat.js to $PATCH_DEST/"
    echo "  Copied bionic-compat.js" >> "$LOG_FILE"
else
    echo -e "${RED}[FAIL]${NC} bionic-compat.js not found in $SCRIPT_DIR"
    echo "  FAILED: bionic-compat.js not found" >> "$LOG_FILE"
    exit 1
fi

# 2. Run path patches
echo ""
if [ -f "$SCRIPT_DIR/patch-paths.sh" ]; then
    bash "$SCRIPT_DIR/patch-paths.sh" 2>&1 | tee -a "$LOG_FILE"
else
    echo -e "${RED}[FAIL]${NC} patch-paths.sh not found in $SCRIPT_DIR"
    echo "  FAILED: patch-paths.sh not found" >> "$LOG_FILE"
    exit 1
fi

echo ""
echo "Patch log saved to: $LOG_FILE"
echo -e "${GREEN}All patches applied.${NC}"
echo "Patch application completed: $(date)" >> "$LOG_FILE"
