#!/bin/bash
# Script to check what locale dnf5 sees

echo "=== Current shell environment ==="
echo "LANG: $LANG"
echo "LC_ALL: $LC_ALL"
echo "LC_MESSAGES: $LC_MESSAGES"
echo ""

echo "=== What sudo sees (without -E) ==="
sudo printenv | grep -E "^(LANG|LC_)" | sort
echo ""

echo "=== What sudo sees (with -E) ==="
sudo -E printenv | grep -E "^(LANG|LC_)" | sort
echo ""

echo "=== Czech locale YESEXPR and NOEXPR ==="
LANG=cs_CZ.UTF-8 locale -k LC_MESSAGES | grep -E "(yesexpr|noexpr)"
echo ""

echo "=== Testing sudo with LANG inline ==="
sudo LANG=cs_CZ.UTF-8 LC_ALL=cs_CZ.UTF-8 bash -c 'echo "LANG inside sudo: $LANG"'
