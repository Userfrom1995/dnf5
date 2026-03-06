#!/bin/bash
# Reproduce the i18n bug

echo "=== Step 1: Check which locales are installed ==="
locale -a | grep -E "^(de|fr|es|cs|ka)" | head -5

echo ""
echo "=== Step 2: Check if 'Is this ok' is in translation files ==="
for lang in de fr es cs ka; do
    if [ -f "libdnf5-cli/po/${lang}.po" ]; then
        count=$(grep -c "Is this ok" "libdnf5-cli/po/${lang}.po" 2>/dev/null || echo "0")
        echo "$lang.po: $count occurrences"
    fi
done

echo ""
echo "=== Step 3: Build dnf5 (if not already built) ==="
if [ ! -f "build/dnf5/dnf5" ]; then
    echo "Building dnf5..."
    cmake -S . -B build -DWITH_TRANSLATIONS=ON 2>&1 | tail -5
    cmake --build build -j$(nproc) 2>&1 | tail -10
else
    echo "Already built: build/dnf5/dnf5"
fi

echo ""
echo "=== Step 4: Try to reproduce the bug ==="
echo "Pick a locale from above and run:"
echo ""
echo "  LANG=de_DE.UTF-8 ./build/dnf5/dnf5 repoquery bash"
echo ""
echo "Or to see the confirmation prompt (needs root):"
echo "  LANG=de_DE.UTF-8 sudo ./build/dnf5/dnf5 install --assumeno bash"
echo ""
echo "The bug: 'Is this ok [y/N]:' will appear in ENGLISH even though"
echo "other messages are translated to German!"
