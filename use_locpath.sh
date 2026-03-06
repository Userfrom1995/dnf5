#!/bin/bash
# Use LOCPATH to point to your build directory

# First, we need to create the proper locale structure
BUILD_DIR="/home/myuser/dnf5/build"
LOCALE_DIR="$BUILD_DIR/locale_test"

echo "=== Setting up locale directory structure ==="
mkdir -p "$LOCALE_DIR/cs/LC_MESSAGES"

# Copy your built .gmo files
echo "Copying your built translations..."
cp "$BUILD_DIR/libdnf5-cli/po/cs.gmo" "$LOCALE_DIR/cs/LC_MESSAGES/libdnf5-cli.mo"
cp "$BUILD_DIR/libdnf5/po/cs.gmo" "$LOCALE_DIR/cs/LC_MESSAGES/libdnf5.mo"
cp "$BUILD_DIR/dnf5/po/cs.gmo" "$LOCALE_DIR/cs/LC_MESSAGES/dnf5.mo"

echo "✓ Locale directory prepared at: $LOCALE_DIR"
echo ""
echo "Now run with LOCPATH:"
echo "sudo LOCPATH=$LOCALE_DIR LANG=cs_CZ.UTF-8 LC_ALL=cs_CZ.UTF-8 dnf5 install bind"
