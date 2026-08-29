#!/usr/bin/env bash
set -euo pipefail

NDK_DIR="${ANDROID_NDK_HOME:-/opt/android-ndk-r28}"
BUILD_DIR="$(pwd)/build-android"
INSTALL_DIR="$(pwd)/install-android"

while [[ $# -gt 0 ]]; do
    case $1 in
        --ndk) NDK_DIR="$2"; shift 2 ;;
        --build-dir) BUILD_DIR="$2"; shift 2 ;;
        --install-dir) INSTALL_DIR="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

echo "=== Building Mesa Turnip with NDK: $NDK_DIR ==="

export ANDROID_NDK_HOME="$NDK_DIR"

meson setup "$BUILD_DIR" \
    --cross-file ./scripts/android-aarch64.ini \
    --prefix "$INSTALL_DIR" \
    --buildtype release \
    -Dplatforms=android \
    -Dplatform-sdk-version=34 \
    -Dandroid-stub=true \
    -Dgallium-drivers=freedreno,panfrost \
    -Dvulkan-drivers=freedreno,panfrost \
    -Dfreedreno-kmds=kgsl,msm \
    -Dshader-cache=enabled \
    -Db_lto=true

ninja -C "$BUILD_DIR" install

echo "=== Build finished! Artifacts in $INSTALL_DIR ==="