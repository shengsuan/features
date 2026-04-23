#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

echo "Testing AI Agent Tools installation..."

# Check if helper script is installed
check "agent-tools-info exists" test -f /usr/local/bin/agent-tools-info
check "agent-tools-info is executable" test -x /usr/local/bin/agent-tools-info

# Check Python packages
check "anthropic python package" python3 -c "import anthropic; print('Anthropic SDK installed')"
check "openai python package" python3 -c "import openai; print('OpenAI SDK installed')"

# Check if pip packages are available
check "pip list shows anthropic" pip3 list | grep anthropic
check "pip list shows openai" pip3 list | grep openai

# Run the info command
check "agent-tools-info runs" agent-tools-info

echo "All tests passed!"

# Report result
reportResults
