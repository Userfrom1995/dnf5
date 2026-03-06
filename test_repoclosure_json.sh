#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "Starting dnf5 repoclosure --json test suite..."
echo "------------------------------------------"

# Function to run and check results
run_test() {
    local name=$1
    local command=$2
    local expected_exit=$3
    local check_mode=$4 # "json", "empty_json", "standard", or "error"

    echo "Test: $name"
    echo "Running: $command"

    # Capture output and exit code
    tmp_out=$(mktemp)
    eval "$command" > "$tmp_out" 2>&1
    exit_code=$?
    output=$(cat "$tmp_out")
    rm "$tmp_out"

    echo "Response:"
    echo "---"
    echo "$output"
    echo "---"

    echo -n "Result: "

    # Check exit code
    if [ $exit_code -ne $expected_exit ]; then
        echo -e "${RED}FAILED${NC} (Expected exit $expected_exit, got $exit_code)"
        return 1
    fi

    if [ "$check_mode" == "empty_json" ]; then
        if [[ "$output" == "[]" ]]; then
             echo -e "${GREEN}PASSED${NC} (Empty array returned)"
        else
             echo -e "${RED}FAILED${NC} (Expected [], got: $output)"
             return 1
        fi
    elif [ "$check_mode" == "json" ]; then
        # Basic JSON check: starts with [ and ends with ]
        trimmed_output=$(echo "$output" | tr -d '[:space:]')
        if [[ "$trimmed_output" =~ ^\[.*\]$ ]]; then
             echo -e "${GREEN}PASSED${NC} (JSON array returned)"
        else
             echo -e "${RED}FAILED${NC} (Output is not a JSON array)"
             return 1
        fi
    elif [ "$check_mode" == "standard" ]; then
        if [[ "$output" == *"package:"* && "$output" == *"unresolved deps"* ]]; then
             echo -e "${GREEN}PASSED${NC} (Standard text output returned)"
        else
             echo -e "${RED}FAILED${NC} (Expected standard text output)"
             return 1
        fi
    elif [ "$check_mode" == "error" ]; then
        if [[ "$output" == *"No match"* || "$output" == *"Failed to resolve"* ]]; then
             echo -e "${GREEN}PASSED${NC} (Error message returned)"
        else
             echo -e "${RED}FAILED${NC} (Expected error message)"
             return 1
        fi
    fi
    return 0
}

# 1. Test standard output (no --json) with results
run_test "Standard Output (Unresolved Deps)" "dnf5 repoclosure --arch x86_64 --check fedora zbar-gtk" 1 "standard"

# 2. Test JSON output with results
run_test "JSON Output (Unresolved Deps)" "dnf5 repoclosure --json --arch x86_64 --check fedora zbar-gtk" 1 "json"

# 3. Test JSON output with NO results (Empty)
run_test "JSON Output (Empty results)" "dnf5 repoclosure --json --check fedora bash" 0 "empty_json"

# 4. Test JSON output with multiple options
run_test "JSON Output (Multi-options)" "dnf5 repoclosure --json --arch x86_64 --newest --check fedora zbar-gtk" 1 "json"

# 5. Test JSON output with invalid arguments (should return error and exit 1)
run_test "JSON Output (Invalid Args)" "dnf5 repoclosure --json --check fedora non-existent-pkg" 1 "error"

echo "------------------------------------------"
echo "All tests completed."
