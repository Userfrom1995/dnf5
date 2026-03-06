#!/bin/bash
# Test script to verify your built DNF5 binary shows translated prompts

cd /home/myuser/dnf5/build

echo "==================================="
echo "Testing YOUR built DNF5 binary"
echo "==================================="
echo ""

echo "Binary location: $(pwd)/dnf5/dnf5"
echo ""

echo "Test 1: Run with Czech locale and see the prompt"
echo "-----------------------------------------------"
echo ""

# This will show the prompt and abort
timeout 5 sudo -E LANG=cs_CZ.UTF-8 LC_ALL=cs_CZ.UTF-8 ./dnf5/dnf5 install bind 2>&1 | grep -A2 "Je to v pořádku\|Is this ok"

echo ""
echo ""
echo "==================================="
echo "Manual test command:"
echo "cd /home/myuser/dnf5/build"
echo "sudo LANG=cs_CZ.UTF-8 LC_ALL=cs_CZ.UTF-8 ./dnf5/dnf5 install bind"
echo ""
echo "Then type 'a' (for 'ano' = yes in Czech)"
echo "==================================="
