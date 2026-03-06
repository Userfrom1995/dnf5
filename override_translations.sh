#!/bin/bash
# Script to override system DNF5 translations with your local build

echo "=== Overriding system translations with local build ==="
echo ""

# Backup original system file
if [ ! -f /usr/share/locale/cs/LC_MESSAGES/libdnf5-cli.mo.backup ]; then
    echo "Backing up original system file..."
    sudo cp /usr/share/locale/cs/LC_MESSAGES/libdnf5-cli.mo \
            /usr/share/locale/cs/LC_MESSAGES/libdnf5-cli.mo.backup
    echo "✓ Backup created"
fi

# Copy your build to system location
echo "Copying your build to system location..."
sudo cp build/libdnf5-cli/po/cs.gmo \
        /usr/share/locale/cs/LC_MESSAGES/libdnf5-cli.mo

echo "✓ Done!"
echo ""
echo "Now run: sudo LANG=cs_CZ.UTF-8 LC_ALL=cs_CZ.UTF-8 dnf5 install bind"
echo ""
echo "To restore original: sudo cp /usr/share/locale/cs/LC_MESSAGES/libdnf5-cli.mo.backup /usr/share/locale/cs/LC_MESSAGES/libdnf5-cli.mo"
