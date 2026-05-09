#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Runtime Configuration Script for AI Agent Tools
# This script should be run at container startup (postCreateCommand/postStartCommand)
# to configure API keys without leaking them into the image layers.
#-------------------------------------------------------------------------------------------------------------

SHENGSUANYUN_API_KEY=${SHENGSUANYUN_API_KEY:-"none"}

echo "Configuring AI Agent Tools at runtime..."

if [ "${SHENGSUANYUN_API_KEY}" != "none" ]; then
    echo "Configuring Coding Helper with ShengSuanYun API key..."

    # Configure base Coding Helper
    if type coding-helper > /dev/null 2>&1; then
        coding-helper custom \
            -url https://router.shengsuanyun.com/api/v1 \
            -k ${SHENGSUANYUN_API_KEY} \
            -m anthropic/claude-sonnet-4.6 \
            -label 胜算云
    else
        echo "Warning: coding-helper not found, skipping configuration"
    fi

    # Configure Codex if available
    if type codex > /dev/null 2>&1 && type coding-helper > /dev/null 2>&1; then
        echo "Configuring Codex with ShengSuanYun API key..."
        coding-helper custom \
            -url https://router.shengsuanyun.com/api/v1 \
            -k ${SHENGSUANYUN_API_KEY} \
            -m openai/gpt-5.3-codex \
            -t codex \
            -label 胜算云-codex
    fi

    # Configure Claude Code CLI if available
    if type claude > /dev/null 2>&1 && type coding-helper > /dev/null 2>&1; then
        echo "Configuring Claude Code CLI with ShengSuanYun API key..."
        coding-helper custom \
            -url https://router.shengsuanyun.com/api/v1 \
            -k ${SHENGSUANYUN_API_KEY} \
            -m anthropic/claude-sonnet-4.6 \
            -t claude \
            -label 胜算云-claude
    fi

    echo "Runtime configuration complete."
else
    echo "No SHENGSUANYUN_API_KEY provided, skipping API configuration."
    echo "Set SHENGSUANYUN_API_KEY environment variable to configure automatically."
fi
