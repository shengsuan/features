#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

echo "Testing Codex CLI installation..."

# Check if Codex CLI is installed
check "codex command exists" command -v codex

# Check version (if available)
check "codex runs" codex --version || codex --help

echo "Codex CLI tests passed!"

# Report result
reportResults
