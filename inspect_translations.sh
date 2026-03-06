#!/bin/bash
# Script to inspect and compare translation files

echo "==================================="
echo "DNF5 Translation Files Comparison"
echo "==================================="
echo ""

SYSTEM_FILE="/usr/share/locale/cs/LC_MESSAGES/libdnf5-cli.mo"
LOCAL_FILE="/home/myuser/dnf5/build/libdnf5-cli/po/cs.gmo"

echo "=== File Locations ==="
echo "System: $SYSTEM_FILE"
echo "Local:  $LOCAL_FILE"
echo ""

echo "=== File Sizes and Dates ==="
ls -lh "$SYSTEM_FILE" "$LOCAL_FILE"
echo ""

echo "=== Checking if msgunfmt is available ==="
if command -v msgunfmt &> /dev/null; then
    echo "✓ msgunfmt found"
    echo ""

    echo "=== System file translations for 'Is this ok' ==="
    msgunfmt "$SYSTEM_FILE" 2>/dev/null | grep -A2 "Is this ok" || echo "Could not extract"
    echo ""

    echo "=== Your built file translations for 'Is this ok' ==="
    msgunfmt "$LOCAL_FILE" 2>/dev/null | grep -A2 "Is this ok" || echo "Could not extract"
    echo ""
else
    echo "✗ msgunfmt not found. Install with: sudo dnf install gettext"
    echo ""
    echo "Alternative: Use strings command (less reliable)"
    echo "=== System file (using strings) ==="
    strings "$SYSTEM_FILE" | grep -i "je to v pořádku\|is this ok" | head -5
    echo ""
    echo "=== Your file (using strings) ==="
    strings "$LOCAL_FILE" | grep -i "je to v pořádku\|is this ok" | head -5
fi

echo ""
echo "=== File differences (binary comparison) ==="
if cmp -s "$SYSTEM_FILE" "$LOCAL_FILE"; then
    echo "Files are IDENTICAL"
else
    echo "Files are DIFFERENT"
    echo "Differences:"
    cmp -l "$SYSTEM_FILE" "$LOCAL_FILE" | wc -l | xargs echo "Number of differing bytes:"
fi

echo ""
echo "==================================="
echo "To use your local file system-wide:"
echo "sudo cp $LOCAL_FILE $SYSTEM_FILE"
echo "==================================="
