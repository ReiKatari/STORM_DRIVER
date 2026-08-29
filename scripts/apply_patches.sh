#!/usr/bin/env bash
set -euo pipefail

MESA_DIR="${1:-../mesa}"
PATCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../patches" && pwd)"

echo "=== Applying STORM DRIVER patches to Mesa ($MESA_DIR) ==="

if [ ! -d "$MESA_DIR" ]; then
    echo "Error: Mesa directory '$MESA_DIR' not found!"
    exit 1
fi

cd "$MESA_DIR"
for patch in "$PATCH_DIR"/*.patch; do
    echo "Applying $(basename "$patch")..."
    git apply --verbose "$patch" || true
done

echo "=== All patches applied successfully! ==="