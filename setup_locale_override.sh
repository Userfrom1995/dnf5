#!/bin/bash
# Script to set up locale override for testing DNF5 translations

BUILD_DIR="/home/myuser/dnf5/build"
LOCALE_OVERRIDE_DIR="/tmp/dnf5-locale-test"

echo "=== Setting up locale override for DNF5 ==="
echo ""

# Create proper locale directory structure
mkdir -p "$LOCALE_OVERRIDE_DIR/cs/LC_MESSAGES"

# Copy the built .gmo file to the proper location
# The system expects: <dir>/cs/LC_MESSAGES/libdnf5-cli.mo
if [ -f "$BUILD_DIR/libdnf5-cli/po/cs.gmo" ]; then
    cp "$BUILD_DIR/libdnf5-cli/po/cs.gmo" "$LOCALE_OVERRIDE_DIR/cs/LC_MESSAGES/libdnf5-cli.mo"
    echo "✓ Copied cs.gmo to $LOCALE_OVERRIDE_DIR/cs/LC_MESSAGES/libdnf5-cli.mo"
else
    echo "✗ Error: $BUILD_DIR/libdnf5-cli/po/cs.gmo not found!"
    echo "  Run 'make' in the build directory first."
    exit 1
fi

echo ""
echo "=== Verifying file dates ==="
echo "System file (OLD):"
ls -lh /usr/share/locale/cs/LC_MESSAGES/libdnf5-cli.mo
echo ""
echo "Your test file (NEW):"
ls -lh "$LOCALE_OVERRIDE_DIR/cs/LC_MESSAGES/libdnf5-cli.mo"

echo ""
echo "=== Export these environment variables: ==="
echo ""
echo "export LOCPATH=$LOCALE_OVERRIDE_DIR"
echo "export LANG=cs_CZ.UTF-8"
echo "export LC_ALL=cs_CZ.UTF-8"
echo ""
echo "Then run DNF5 with sudo -E:"
echo "sudo -E dnf5 install bind"
echo ""
echo "Or source this script to set the variables:"
echo "source setup_locale_override.sh"
echo ""

# Export for current shell if sourced
export LOCPATH="$LOCALE_OVERRIDE_DIR"
export LANG=cs_CZ.UTF-8
export LC_ALL=cs_CZ.UTF-8

echo "✓ Environment variables set in current shell!"
echo ""
echo "Test with: sudo -E dnf5 install bind"
