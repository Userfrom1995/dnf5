#!/bin/bash
# Install your built DNF5 to a custom location

BUILD_DIR="/home/myuser/dnf5/build"
INSTALL_PREFIX="/home/myuser/dnf5-install"

echo "=== Installing your build to $INSTALL_PREFIX ==="

cd "$BUILD_DIR"

# Install to custom prefix
sudo cmake --install . --prefix "$INSTALL_PREFIX"

echo ""
echo "✓ Installation complete!"
echo ""
echo "Your custom dnf5 is at: $INSTALL_PREFIX/bin/dnf5"
echo "Translations are at: $INSTALL_PREFIX/share/locale/"
echo ""
echo "To test, run:"
echo "sudo LANG=cs_CZ.UTF-8 LC_ALL=cs_CZ.UTF-8 $INSTALL_PREFIX/bin/dnf5 install bind"
