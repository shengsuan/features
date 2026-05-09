#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/devcontainers/features/tree/main/src/agent
# Maintainer: DevContainers Community

CLAUDE_CODE_VERSION=${CLAUDECODEVERSION:-"latest"}
INSTALL_CODEX=${INSTALLCODEX:-"true"}
INSTALL_NODE=${INSTALLNODE:-"true"}
SHENGSUANYUN_API_KEY=${SHENGSUANYUNAPIKEY:-"none"}
set -e

# Clean up
rm -rf /var/lib/apt/lists/*

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

export DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
echo "Installing basic dependencies..."
check_packages curl ca-certificates wget gnupg2

# Determine the appropriate non-root user
USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if [ -n "${CURRENT_USER}" ] && id -u "${CURRENT_USER}" > /dev/null 2>&1; then
            USERNAME="${CURRENT_USER}"
            break
        fi
    done
    if [ -z "${USERNAME}" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u "${USERNAME}" > /dev/null 2>&1; then
    USERNAME=root
fi

echo "Installing for user: ${USERNAME}"

# Install Node.js if requested and not present
if [ "${INSTALL_NODE}" = "true" ] && ! type node > /dev/null 2>&1; then
    echo "Installing Node.js..."
    check_packages nodejs npm
fi

# Install Claude Code CLI
if [ "${CLAUDE_CODE_VERSION}" != "none" ]; then
    echo "Installing Claude Code CLI..."

    # Install via official installation script
    # Reference: https://code.claude.com/docs/en/overview
    if ! type claude > /dev/null 2>&1; then
        echo "Installing Claude Code using official installer..."

        # Download and run the official install script (follow redirects with -L)
        curl -fsSL https://claude.ai/install.sh | bash || echo "(!) Claude Code installation failed, creating fallback wrapper..."
    fi

    # Fallback: Create a wrapper script if installation failed
    # Check both PATH and common installation locations
    if ! type claude > /dev/null 2>&1 && \
       ! [ -f "/usr/local/bin/claude" ] && \
       ! [ -f "$HOME/.local/bin/claude" ] && \
       ! [ -f "/home/$USERNAME/.local/bin/claude" ]; then
        echo "Creating Claude Code CLI wrapper..."
        cat > /usr/local/bin/claude << 'EOF'
#!/bin/bash
echo "Claude Code CLI"
echo ""
echo "Note: Claude Code installation may have failed."
echo "Please try manual installation:"
echo "  curl -fsSL https://claude.ai/install.sh | bash"
echo ""
echo "For configuration, set your API key:"
echo "  export ANTHROPIC_API_KEY=your_api_key_here"
echo ""
echo "Visit https://console.anthropic.com/ to get your API key"
echo "Documentation: https://code.claude.com/docs"
EOF
        chmod +x /usr/local/bin/claude
    elif [ -f "/home/$USERNAME/.local/bin/claude" ] && ! type claude > /dev/null 2>&1; then
        # Claude installed to ~/.local/bin but not in PATH, create symlink
        echo "Creating symlink to Claude Code CLI..."
        ln -sf "/home/$USERNAME/.local/bin/claude" /usr/local/bin/claude
    fi

    echo "Claude Code CLI installation complete."
fi

# Install OpenAI Codex integration tools
if [ "${INSTALL_CODEX}" = "true" ]; then
    echo "Installing OpenAI Codex integration tools..."

    # Install OpenAI Codex CLI
    # Reference: https://github.com/openai/codex
    if type npm > /dev/null 2>&1 && ! type codex > /dev/null 2>&1; then
        echo "Installing OpenAI Codex CLI..."
        npm install -g @openai/codex || echo "(!) Codex CLI installation failed"
    fi

    # Install Python OpenAI and Anthropic SDKs
    if type pip3 > /dev/null 2>&1; then
        echo "Installing Python SDKs..."
        if [ "${USERNAME}" = "root" ]; then
            pip3 install --upgrade openai anthropic
        else
            su - "${USERNAME}" -c "pip3 install --user --upgrade openai anthropic"
        fi
    fi

    # Install Node.js OpenAI and Anthropic SDKs
    if type npm > /dev/null 2>&1; then
        echo "Installing Node.js SDKs..."
        npm install -g openai @anthropic-ai/sdk
    fi

    echo "OpenAI Codex tools installation complete."
fi

echo "Installing Coding Helper integration tools..."
# Reference: https://github.com/shengsuan/coding-helper
if type npm > /dev/null 2>&1 && ! type coding-helper > /dev/null 2>&1; then
    echo "Installing Coding Helper..."
    npm install -g @coohu/coding-helper || echo "(!) Coding Helper installation failed"
fi
echo "Coding Helper tools installation complete."

# Create configuration directory
if [ "${USERNAME}" != "root" ]; then
    USER_HOME=$(eval echo ~${USERNAME})
    mkdir -p "${USER_HOME}/.config/agent-tools"
    chown -R ${USERNAME}:${USERNAME} "${USER_HOME}/.config/agent-tools" 2>/dev/null || true
fi

if [ "${SHENGSUANYUN_API_KEY}" != "none" ]; then
    echo "Configuring Coding Helper with ShengSuanYun API key..."
    coding-helper custom \
        -url https://router.shengsuanyun.com/api/v1 \
        -k ${SHENGSUANYUN_API_KEY} \
        -m anthropic/claude-sonnet-4.6 \
        -label 胜算云

    echo "Configuring Codex with ShengSuanYun API key..."
    coding-helper custom \
        -url https://router.shengsuanyun.com/api/v1 \
        -k ${SHENGSUANYUN_API_KEY} \
        -m openai/gpt-5.3-codex \
        -t codex \
        -label 胜算云-codex
fi

# Create a helper script for AI agent tools
cat > /usr/local/bin/agent-tools-info << 'EOF'
#!/bin/bash
echo "==================================="
echo "AI Agent Tools - Installation Info"
echo "==================================="
echo ""
echo "Installed Tools:"
echo "----------------"

if command -v claude &> /dev/null; then
    echo "✓ Claude Code CLI"
    echo "  Usage: claude [command]"
    echo "  Config: Set ANTHROPIC_API_KEY environment variable"
    echo "  Docs: https://code.claude.com/docs"
else
    echo "✗ Claude Code CLI (not found)"
fi

if command -v codex &> /dev/null; then
    echo "✓ OpenAI Codex CLI"
    echo "  Usage: codex [command]"
    echo "  Config: Sign in or set OPENAI_API_KEY"
    echo "  Docs: https://github.com/openai/codex"
else
    echo "✗ OpenAI Codex CLI (not installed)"
fi

if command -v coding-helper &> /dev/null; then
    echo "✓ Coding Helper"
    echo "  Usage: coding-helper [command]"
    echo "  Config: Set API keys as environment variables"
    echo "  Docs: https://github.com/shengsuan/coding-helper"
else
    echo "✗ Coding Helper (not installed)"
fi

if python3 -c "import openai" 2>/dev/null; then
    echo "✓ OpenAI Python SDK"
    echo "  Usage: import openai in Python"
else
    echo "✗ OpenAI Python SDK (not installed)"
fi

if python3 -c "import anthropic" 2>/dev/null; then
    echo "✓ Anthropic Python SDK"
    echo "  Usage: import anthropic in Python"
else
    echo "✗ Anthropic Python SDK (not installed)"
fi

if command -v node &> /dev/null && node -e "require('openai')" 2>/dev/null; then
    echo "✓ OpenAI Node.js SDK"
    echo "  Usage: import OpenAI from 'openai'"
else
    echo "✗ OpenAI Node.js SDK (not installed)"
fi

if command -v node &> /dev/null && node -e "require('@anthropic-ai/sdk')" 2>/dev/null; then
    echo "✓ Anthropic Node.js SDK"
    echo "  Usage: import Anthropic from '@anthropic-ai/sdk'"
else
    echo "✗ Anthropic Node.js SDK (not installed)"
fi

echo ""
echo "Configuration:"
echo "--------------"
echo "Set your API keys as environment variables:"
echo "  export ANTHROPIC_API_KEY=your_anthropic_key"
echo "  export OPENAI_API_KEY=your_openai_key"
echo "  export SHENGSUANYUN_API_KEY=your_shengsuanyun_key"
echo ""
echo "Optional base URLs for API-compatible services:"
echo "  export OPENAI_BASE_URL=openai_compatible_base_url"
echo "  export ANTHROPIC_BASE_URL=anthropic_compatible_base_url"
echo ""
echo "Get API keys from:"
echo "  - ShengSuanYun: https://console.shengsuanyun.com/user/keys"
echo "  - Anthropic: https://console.anthropic.com/"
echo "  - OpenAI: https://platform.openai.com/api-keys"
echo ""
echo "Documentation:"
echo "  - Claude Code: https://code.claude.com/docs"
echo "  - OpenAI Codex: https://github.com/openai/codex"
echo "  - Coding Helper: https://github.com/shengsuan/coding-helper"
EOF

chmod +x /usr/local/bin/agent-tools-info

echo ""
echo "========================================="
echo "AI Agent Tools installation complete!"
echo "========================================="
echo ""
echo "Run 'agent-tools-info' to see installed tools and configuration instructions."
echo ""

# Clean up
rm -rf /var/lib/apt/lists/*
