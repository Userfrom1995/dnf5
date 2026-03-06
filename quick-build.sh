#!/bin/bash
# Quick build script for DNF5
# Usage: ./quick-build.sh [minimal|full]

set -e

BUILD_TYPE="${1:-minimal}"
BUILD_DIR="build"

echo "=== DNF5 Build Script ==="
echo "Build type: $BUILD_TYPE"
echo ""

# Clean previous build
if [ -d "$BUILD_DIR" ]; then
    echo "Cleaning previous build..."
    rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure based on build type
if [ "$BUILD_TYPE" = "minimal" ]; then
    echo "Configuring minimal build (without optional plugins)..."
    cmake .. \
        -DWITH_PLUGIN_MANIFEST=OFF \
        -DWITH_PLUGIN_RHSM=OFF \
        -DWITH_DNF5DAEMON_SERVER=OFF \
        -DWITH_DNF5DAEMON_CLIENT=OFF \
        -DWITH_TESTS=OFF
elif [ "$BUILD_TYPE" = "full" ]; then
    echo "Configuring full build..."
    cmake ..
else
    echo "Unknown build type: $BUILD_TYPE"
    echo "Usage: $0 [minimal|full]"
    exit 1
fi

# Build
echo ""
echo "Building DNF5..."
make -j$(nproc)

echo ""
echo "=== Build completed successfully! ==="
echo "Build artifacts are in: $BUILD_DIR"
echo ""
echo "To run tests:"
echo "  cd $BUILD_DIR && CTEST_OUTPUT_ON_FAILURE=1 make test"
echo ""
echo "To install (as root):"
echo "  cd $BUILD_DIR && sudo make install"
