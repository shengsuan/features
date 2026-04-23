# AI Agent Tools (agent)

## Summary

This feature installs AI programming agent tools including Claude Code CLI and OpenAI Codex integration tools to help developers leverage AI-powered coding assistance.

## Features
- **Coding Helper**: CLI tool for configuring ShengSuanYun Coding Plan API credentials across multiple AI coding tools
- **Claude Code CLI**: Official Anthropic CLI tool for interacting with Claude AI
- **OpenAI Codex CLI**: Official OpenAI command-line coding agent
- **OpenAI Integration**: SDKs and tools for OpenAI API integration
- **Multi-language Support**: Python and Node.js SDKs for both platforms
- **Easy Configuration**: Simple environment variable configuration

## Usage

```json
{
    "features": {
        "ghcr.io/devcontainers/features/agent:1": {}
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|------------|-------------|------|---------------|
| claudeCodeVersion | Version of Claude Code CLI to install. Use 'none' to skip installation. | string | latest |
| installCodex | Install OpenAI Codex integration tools and dependencies. | boolean | true |
| installNode | Install Node.js if not present (required for some AI tools). | boolean | true |
| installPython | Install Python if not present (required for OpenAI tools). | boolean | true |

## Examples

### Basic Installation

Install both Claude Code and OpenAI tools with default settings:

```json
{
    "features": {
        "ghcr.io/devcontainers/features/agent:1": {}
    }
}
```

### Claude Code Only

Install only Claude Code CLI:

```json
{
    "features": {
        "ghcr.io/devcontainers/features/agent:1": {
            "installCodex": false
        }
    }
}
```

### OpenAI Tools Only

Install only OpenAI integration tools:

```json
{
    "features": {
        "ghcr.io/devcontainers/features/agent:1": {
            "claudeCodeVersion": "none"
        }
    }
}
```

### Custom Configuration

Skip runtime installations if already configured:

```json
{
    "features": {
        "ghcr.io/devcontainers/features/agent:1": {
            "claudeCodeVersion": "latest",
            "installCodex": true,
            "installNode": false,
            "installPython": false
        }
    }
}
```

## Configuration

After installation, configure the tools with your API keys:

### Environment Variables

Add to your `.bashrc`, `.zshrc`, or container environment:

```bash
export ANTHROPIC_API_KEY="your_anthropic_api_key_here"
export OPENAI_API_KEY="your_openai_api_key_here"
export SHENGSUANYUN_API_KEY="your_shengsuanyun_api_key_here"
export OPENAI_BASE_URL="openai_compatible_base_url"
export ANTHROPIC_BASE_URL="anthropic_compatible_base_url"
```

### Get API Keys

- **胜算云 API Key**: [https://console.shengsuanyun.com/user/keys](https://console.shengsuanyun.com/user/keys)
- **Anthropic API Key**: [https://console.anthropic.com/](https://console.anthropic.com/)
- **OpenAI API Key**: [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)

## Using the Tools

### Claude Code CLI

```bash
# Check Claude Code installation
claude --help

# Start an interactive coding session
claude

# Run a one-off task
claude "add error handling to the login function"

# Work with specific files
claude "refactor this file" main.py
```

For more details, see the [Claude Code documentation](https://code.claude.com/docs).

### OpenAI Codex CLI

```bash
# Check Codex installation
codex --version

# Start an interactive coding session
codex

# Run a specific task
codex "write unit tests for the API endpoints"
```

For more details, see the [OpenAI Codex repository](https://github.com/openai/codex).

### Python Usage

```python
# Anthropic Claude
import anthropic

client = anthropic.Anthropic(api_key="your_api_key")
message = client.messages.create(
    model="claude-3-opus-20240229",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Hello, Claude!"}
    ]
)
print(message.content)

# OpenAI
import openai

openai.api_key = "your_api_key"
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "Hello!"}]
)
print(response.choices[0].message.content)
```

### Node.js Usage

```javascript
// Anthropic Claude
import Anthropic from '@anthropic-ai/sdk';

const anthropic = new Anthropic({
    apiKey: process.env.ANTHROPIC_API_KEY,
});

const message = await anthropic.messages.create({
    model: 'claude-3-opus-20240229',
    max_tokens: 1024,
    messages: [{ role: 'user', content: 'Hello, Claude!' }],
});

console.log(message.content);

// OpenAI
import OpenAI from 'openai';

const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

const completion = await openai.chat.completions.create({
    model: 'gpt-4',
    messages: [{ role: 'user', content: 'Hello!' }],
});

console.log(completion.choices[0].message.content);
```

## Helper Commands

After installation, use the following command to check installed tools:

```bash
agent-tools-info
```

This displays:
- Installed AI tools and their status
- Configuration instructions
- Links to get API keys

## Notes

- Both Claude Code and OpenAI tools require valid API keys to function
- API usage may incur costs based on your plan with Anthropic and OpenAI
- Ensure your API keys are kept secure and not committed to version control
- Consider using `.env` files or secret management solutions for production

## Support

For issues and feature requests, please visit:
- [DevContainer Features Repository](https://github.com/devcontainers/features)
- [Anthropic Documentation](https://docs.anthropic.com/)
- [OpenAI Documentation](https://platform.openai.com/docs)

---

*This feature is maintained by the DevContainers community.*
