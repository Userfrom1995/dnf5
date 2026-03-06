#!/bin/bash
# Script to reproduce the i18n bug in userconfirm

echo "=== Testing i18n bug in userconfirm.hpp ==="
echo ""
echo "Current locale: $LANG"
echo ""

# Check if German locale is available
if locale -a 2>/dev/null | grep -q "de_DE"; then
    echo "✓ German locale available"
    GERMAN_LOCALE=$(locale -a 2>/dev/null | grep "de_DE" | head -1)
else
    echo "✗ German locale not installed"
    echo "  Install with: sudo dnf install glibc-langpack-de"
    GERMAN_LOCALE=""
fi

echo ""
echo "=== The Bug ==="
echo "When you run dnf5 in German locale, the confirmation prompt"
echo "should appear in German, but it stays in English:"
echo ""
echo "Expected (German): 'Ist das in Ordnung [J/n]: '"
echo "Actual (English):  'Is this ok [Y/n]: '"
echo ""

if [ -n "$GERMAN_LOCALE" ]; then
    echo "=== To reproduce manually ==="
    echo "1. Build dnf5:"
    echo "   cmake -S . -B build -DWITH_TRANSLATIONS=ON"
    echo "   cmake --build build"
    echo ""
    echo "2. Install it (or use from build dir)"
    echo ""
    echo "3. Run with German locale:"
    echo "   LANG=$GERMAN_LOCALE sudo ./build/dnf5/dnf5 install bash"
    echo ""
    echo "4. When prompted 'Is this ok [Y/n]:', notice it's in English!"
    echo "   (Other messages will be in German, but this one won't be)"
fi

echo ""
echo "=== Why this happens ==="
echo "The strings in userconfirm.hpp are NOT wrapped in _() macro:"
echo "  Line 43: msg = \"Is this ok [Y/n]: \";  // ← Should be: msg = _(\"Is this ok [Y/n]: \");"
echo "  Line 45: msg = \"Is this ok [y/N]: \";  // ← Should be: msg = _(\"Is this ok [y/N]: \");"
echo ""
echo "Without _(), xgettext doesn't extract them to the .pot file,"
echo "so translators never see them, and they can't be translated."
