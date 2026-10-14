#!/usr/bin/env bash
set -euo pipefail

MESA_DIR="${1:-../mesa}"
PATCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../patches" && pwd)"

echo "=== Applying STORM DRIVER 6.0.0 patches to Mesa ($MESA_DIR) ==="

if [ ! -d "$MESA_DIR" ]; then
    echo "Error: Mesa directory '$MESA_DIR' not found!"
    exit 1
fi

cd "$MESA_DIR"
for patch in "$PATCH_DIR"/*.patch; do
    patch_name="$(basename "$patch")"
    if git apply --check "$patch" 2>/dev/null; then
        echo "[APPLY] $patch_name"
        git apply --verbose "$patch"
    elif git apply --reverse --check "$patch" 2>/dev/null; then
        echo "[SKIP]  $patch_name (already applied)"
    else
        echo "[WARN]  $patch_name could not be applied cleanly via git apply --check; attempting 3-way merge..."
        git apply --3way "$patch" || echo "[WARN]  $patch_name skipped"
    fi
done

echo "=== All STORM DRIVER 6.0.0 patches processed! ==="