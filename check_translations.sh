#!/bin/bash
# Check if "Is this ok" exists in any translation

echo "=== Checking all .po files for 'Is this ok' ==="
echo ""

for po_file in libdnf5-cli/po/*.po dnf5/po/*.po dnf5daemon-client/po/*.po; do
    if [ -f "$po_file" ]; then
        result=$(grep -c "Is this ok" "$po_file" 2>/dev/null || echo "0")
        if [ "$result" != "0" ]; then
            echo "✓ FOUND in: $po_file ($result times)"
            grep -A1 "Is this ok" "$po_file" | head -4
        fi
    fi
done

echo ""
echo "=== Checking all .pot files ==="
for pot_file in */po/*.pot; do
    if [ -f "$pot_file" ]; then
        result=$(grep -c "Is this ok" "$pot_file" 2>/dev/null || echo "0")
        basename_file=$(basename "$pot_file")
        if [ "$result" != "0" ]; then
            echo "✓ FOUND in: $pot_file"
        else
            echo "✗ NOT in: $pot_file"
        fi
    fi
done

echo ""
echo "=== Conclusion ==="
echo "If 'Is this ok' is NOT in libdnf5-cli.pot, that's the bug!"
echo "The string in userconfirm.hpp is not being extracted."
