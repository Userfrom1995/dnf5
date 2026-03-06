#!/bin/bash
# Check for required dependencies for DNF5 build

echo "=== DNF5 Dependency Checker ==="
echo ""

MISSING=()

# Core build tools
echo "Checking core build tools..."
for pkg in cmake gcc-c++ make pkg-config; do
    if ! command -v $pkg &> /dev/null; then
        echo "  ❌ $pkg - NOT FOUND"
        MISSING+=("$pkg")
    else
        echo "  ✓ $pkg"
    fi
done

echo ""
echo "Checking pkg-config packages..."

# List of pkg-config packages to check
PKG_CONFIG_DEPS=(
    "fmt"
    "json-c"
    "libcrypto"
    "librepo"
    "libsolv"
    "libsolvext"
    "rpm"
    "sqlite3"
    "libcomps"
    "modulemd-2.0"
    "smartcols"
)

for dep in "${PKG_CONFIG_DEPS[@]}"; do
    if pkg-config --exists "$dep" 2>/dev/null; then
        version=$(pkg-config --modversion "$dep" 2>/dev/null)
        echo "  ✓ $dep (version: $version)"
    else
        echo "  ❌ $dep - NOT FOUND"
        MISSING+=("$dep")
    fi
done

echo ""
echo "Checking for toml11..."
if [ -f "/usr/include/toml11/toml.hpp" ] || [ -f "/usr/local/include/toml11/toml.hpp" ]; then
    echo "  ✓ toml11 header found"
elif pkg-config --exists toml11 2>/dev/null; then
    echo "  ✓ toml11 found via pkg-config"
else
    echo "  ❌ toml11 - NOT FOUND"
    MISSING+=("toml11")
fi

echo ""
echo "Checking optional dependencies..."

# Optional packages
if pkg-config --exists libpkgmanifest 2>/dev/null; then
    echo "  ✓ libpkgmanifest (optional)"
else
    echo "  ⚠ libpkgmanifest - NOT FOUND (optional, can build without manifest plugin)"
fi

if pkg-config --exists librhsm 2>/dev/null; then
    echo "  ✓ librhsm (optional)"
else
    echo "  ⚠ librhsm - NOT FOUND (optional, can build without RHSM plugin)"
fi

if pkg-config --exists sdbus-c++ 2>/dev/null; then
    echo "  ✓ sdbus-c++ (optional)"
else
    echo "  ⚠ sdbus-c++ - NOT FOUND (optional, needed for dnf5daemon)"
fi

echo ""
echo "========================================"

if [ ${#MISSING[@]} -eq 0 ]; then
    echo "✓ All core dependencies found!"
    echo ""
    echo "You can now build DNF5 with:"
    echo "  ./quick-build.sh full"
else
    echo "❌ Missing ${#MISSING[@]} core dependencies:"
    for dep in "${MISSING[@]}"; do
        echo "  - $dep"
    done
    echo ""
    echo "To install missing dependencies, try:"
    echo "  sudo dnf builddep dnf5.spec"
    echo ""
    echo "Or build with minimal features:"
    echo "  ./quick-build.sh minimal"
fi

echo ""
echo "For manual dependency installation, see: build-instructions.md"
