#!/bin/bash
# Test script to verify YESEXPR/NOEXPR work with dnf5

echo "=== Testing Czech locale confirmation ==="
echo ""

# Check what Czech locale expects for yes/no
echo "Czech locale patterns:"
LANG=cs_CZ.UTF-8 locale -k LC_MESSAGES | grep -E "(yesexpr|noexpr)"
echo ""

# Test 1: Answer with 'a' (Czech for yes = "ano")
echo "Test 1: Answering with 'a' (ano = yes in Czech)"
echo "a" | sudo -E LANG=cs_CZ.UTF-8 LC_ALL=cs_CZ.UTF-8 ./dnf5/dnf5 install bind --downloadonly

echo ""
echo "Test 2: Answering with 'n' (ne = no in Czech)"
echo "n" | sudo -E LANG=cs_CZ.UTF-8 LC_ALL=cs_CZ.UTF-8 ./dnf5/dnf5 install bind

echo ""
echo "Test 3: Check if prompt is translated"
echo "Look for 'Je to v pořádku' instead of 'Is this ok'"
