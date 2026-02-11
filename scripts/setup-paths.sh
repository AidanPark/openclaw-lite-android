#!/usr/bin/env bash
# setup-paths.sh - Create required directories and symlinks for Termux
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=== Setting Up Paths ==="
echo ""

# Create TMPDIR
mkdir -p "$PREFIX/tmp/openclaw"
echo -e "${GREEN}[OK]${NC}   Created $PREFIX/tmp/openclaw"

# Create openclaw-lite config directory
mkdir -p "$HOME/.openclaw-lite/patches"
echo -e "${GREEN}[OK]${NC}   Created $HOME/.openclaw-lite/patches"

# Create openclaw data directory
mkdir -p "$HOME/.openclaw"
echo -e "${GREEN}[OK]${NC}   Created $HOME/.openclaw"

# Create symlinks for standard Linux paths if they don't exist
# These help packages that hardcode /bin/sh, /usr/bin/env, etc.
setup_symlink() {
    local target="$1"
    local link="$2"
    if [ -e "$link" ] || [ -L "$link" ]; then
        echo -e "${YELLOW}[SKIP]${NC} $link already exists"
    else
        # In Termux, we can only create symlinks in writable areas
        # We rely on $PREFIX/bin being in PATH instead
        echo -e "${YELLOW}[INFO]${NC} $link -> $target (handled via PATH)"
    fi
}

echo ""
echo "Standard path mappings (via \$PREFIX):"
echo "  /bin/sh      -> $PREFIX/bin/sh"
echo "  /usr/bin/env -> $PREFIX/bin/env"
echo "  /tmp         -> $PREFIX/tmp"

echo ""
echo -e "${GREEN}Path setup complete.${NC}"
