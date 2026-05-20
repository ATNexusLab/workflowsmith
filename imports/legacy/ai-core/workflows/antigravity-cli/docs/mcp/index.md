# MCP Reference

> **Migration note:** This section remains the detailed reference for MCP mechanics, but Antigravity-first readers should start from [../antigravity-cli/workflow-authoring.md](../antigravity-cli/workflow-authoring.md) to decide where new workflow behavior belongs and use [../antigravity-cli/index.md](../antigravity-cli/index.md) for the preferred navigation layer and migration guidance.

This section documents how Gemini CLI discovers, configures, secures, and operates its Model Context Protocol (MCP) integrations.

## Quick Reference

> - Gemini CLI is an MCP client that connects to external MCP servers.
> - Configure servers under the top-level `mcpServers` object in `settings.json`.
> - MCP tools are exposed with fully qualified names in the form `mcp_{serverName}_{toolName}`.
> - MCP resources can be listed, read, and injected inline with `@server://resource/path`.
> - Use `/mcp` in-session or `gemini mcp ...` in the terminal to manage servers.

## Load by Task

| Load when you need to… | Module |
|---|---|
| Understand what MCP is and how Gemini CLI uses it | [fundamentals.md](fundamentals.md) |
| Configure an MCP server in settings.json (all fields) | [configuration.md](configuration.md) |
| Understand tool naming, FQNs, conflict resolution | [tools-and-resources.md](tools-and-resources.md) |
| Understand trust model, env redaction, OAuth tokens | [security.md](security.md) |
| Use `/mcp` slash commands or `gemini mcp` CLI commands | [commands-reference.md](commands-reference.md) |
