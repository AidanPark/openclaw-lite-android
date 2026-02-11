#!/usr/bin/env bash
# setup-env.sh - Configure environment variables for OpenClaw in Termux
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=== Setting Up Environment Variables ==="
echo ""

BASHRC="$HOME/.bashrc"
MARKER_START="# >>> OpenClaw Lite Android >>>"
MARKER_END="# <<< OpenClaw Lite Android <<<"

COMPAT_PATH="$HOME/.openclaw-lite/patches/bionic-compat.js"

ENV_BLOCK="${MARKER_START}
export TMPDIR=\"\$PREFIX/tmp\"
export TMP=\"\$TMPDIR\"
export TEMP=\"\$TMPDIR\"
export NODE_OPTIONS=\"-r $COMPAT_PATH \${NODE_OPTIONS:-}\"
export CONTAINER=1
${MARKER_END}"

# Create .bashrc if it doesn't exist
touch "$BASHRC"

# Check if block already exists
if grep -qF "$MARKER_START" "$BASHRC"; then
    echo -e "${YELLOW}[SKIP]${NC} Environment block already exists in $BASHRC"
    echo "       Removing old block and re-adding..."
    # Remove old block
    sed -i "/${MARKER_START//\//\\/}/,/${MARKER_END//\//\\/}/d" "$BASHRC"
fi

# Append environment block
echo "" >> "$BASHRC"
echo "$ENV_BLOCK" >> "$BASHRC"
echo -e "${GREEN}[OK]${NC}   Added environment variables to $BASHRC"

echo ""
echo "Variables configured:"
echo "  TMPDIR=\$PREFIX/tmp"
echo "  TMP=\$TMPDIR"
echo "  TEMP=\$TMPDIR"
echo "  NODE_OPTIONS=\"-r $COMPAT_PATH\""
echo "  CONTAINER=1  (suppresses systemd checks)"

# Source for current session
export TMPDIR="$PREFIX/tmp"
export TMP="$TMPDIR"
export TEMP="$TMPDIR"
export NODE_OPTIONS="-r $COMPAT_PATH ${NODE_OPTIONS:-}"
export CONTAINER=1

echo ""
echo -e "${GREEN}Environment setup complete.${NC}"
