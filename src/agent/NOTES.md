# Implementation Notes

## Agent Feature

This feature provides AI programming agent tools integration for development containers.

### Components Installed

1. **Claude Code CLI**
   - Installed via official installation script: `curl -fsSL https://claude.ai/install.sh | bash`
   - Falls back to wrapper script if installation fails
   - Configurable via ANTHROPIC_API_KEY environment variable
   - Reference: https://code.claude.com/docs/en/overview

2. **OpenAI Codex CLI**
   - Installed via npm: `npm install -g @openai/codex`
   - Official command-line interface for OpenAI Codex
   - Reference: https://github.com/openai/codex

3. **Python and Node.js SDKs**
   - Python: `openai` and `anthropic` packages
   - Node.js: `openai` and `@anthropic-ai/sdk` packages
   - Support for both AI platforms in multiple languages

4. **Runtime Dependencies**
   - Node.js (optional, for npm packages and Codex CLI)
   - Python 3 (optional, for pip packages)
   - Basic build tools and dependencies

### Installation Process

The install script:
1. Detects the appropriate non-root user
2. Installs runtime dependencies (Node.js, Python) if requested
3. Installs Claude Code CLI via official installer script
4. Installs OpenAI Codex CLI via npm
5. Installs Python and Node.js SDKs for both Anthropic and OpenAI
6. Creates helper scripts and configuration directories

### Configuration

Users need to set API keys:
- `ANTHROPIC_API_KEY` for Claude Code
- `OPENAI_API_KEY` for OpenAI tools and Codex
- `SHENGSUANYUN_API_KEY` for ShengSuanYun services (optional)

Optional base URLs for API-compatible services:
- `OPENAI_BASE_URL` for OpenAI-compatible endpoints
- `ANTHROPIC_BASE_URL` for Anthropic-compatible endpoints

### Helper Script

The `agent-tools-info` command provides:
- Status of installed tools (Claude Code CLI, Codex CLI, Python/Node SDKs)
- Configuration instructions with API keys and base URLs
- Links to API key registration and documentation

### Testing

To test the feature:
1. Build a devcontainer with this feature
2. Run `agent-tools-info` to verify installation
3. Check that `claude` and `codex` commands are available
4. Set API keys and test basic API calls
5. Verify both Python and Node.js SDKs work correctly

### Known Issues

- Claude Code official installer requires internet access and may not work in restricted environments
- OpenAI Codex CLI requires Node.js/npm to be installed
- Some installations may require manual API key configuration
- Network access required during container build for package downloads

### Future Enhancements

- Support for additional AI coding tools (GitHub Copilot CLI, etc.)
- Pre-configured templates for common AI workflows
- Integration with more VS Code extensions
- Support for local AI models (Ollama, LM Studio, etc.)
- Automatic API key management from secret stores
