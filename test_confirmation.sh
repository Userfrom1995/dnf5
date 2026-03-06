#!/bin/bash
# Test the confirmation prompt

echo "=== Testing confirmation prompt ==="
echo ""
echo "Trying to trigger the 'Is this ok' prompt..."
echo ""

# Try to install a small package that's likely not installed
# Using --setopt=defaultyes=0 to force the prompt
cd build/dnf5

echo "Test 1: English (current locale)"
./dnf5 install --setopt=defaultyes=0 --downloadonly nano 2>&1 | grep -A2 -B2 "ok"

echo ""
echo "Test 2: Try with LANGUAGE variable (doesn't need locale installed)"
LANGUAGE=de ./dnf5 install --setopt=defaultyes=0 --downloadonly nano 2>&1 | grep -A2 -B2 "ok"

echo ""
echo "=== Result ==="
echo "If you see 'Is this ok [y/N]:' in BOTH tests, that's the bug!"
echo "It should be translated in Test 2 but it's not."
