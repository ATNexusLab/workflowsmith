# Glossary

Label: **Official reference**

This glossary normalizes the core terms used throughout the atlas.

## Core runtime terms

### Copilot CLI

GitHub's terminal-native Copilot experience. Official docs describe both an interactive interface and a programmatic interface.

### Interactive mode

The session model launched by running `copilot`, with a conversation timeline, slash commands, permissions, and session management.

### Programmatic mode

Single-prompt execution, typically invoked with `-p` or `--prompt`, intended for scripting, automation, or one-shot use.

### Tool

An ability the agent uses to get work done, such as reading files, editing files, running shell commands, invoking a skill, or calling an MCP server tool.

## Customization terms

### Custom instructions

Persistent instruction files that Copilot CLI loads at session start to shape general behavior, repository conventions, and communication preferences.

### Skill

A task-specific instruction module, minimally a Markdown file, that Copilot can invoke automatically or manually to improve its handling of a particular workflow.

### Hook

A user-defined shell command that runs at a lifecycle event such as session start, prompt submission, tool use, error handling, or agent stop.

### Custom agent

A specialized agent profile defined in Markdown with frontmatter. It can carry a role, tool constraints, optional MCP configuration, and inference settings.

### Subagent

A separate agent execution spawned by the main agent to keep work isolated, parallelize effort, or apply a specialist profile.

### Plugin

An installable package that can bundle Copilot CLI customizations such as skills, hooks, custom agents, and MCP configurations.

## Integration terms

### MCP server

An external service that exposes tools and data sources to Copilot via the Model Context Protocol.

### Built-in MCP server

An MCP server shipped with the CLI runtime itself. Official docs currently list built-in servers such as `github-mcp-server`, `playwright`, `fetch`, and `time` in the command reference.

### LSP server

A Language Server Protocol integration that provides language-aware intelligence such as diagnostics and symbol navigation to the agent.

### Copilot Memory

An official Copilot capability for storing durable context about conventions, patterns, and preferences so future sessions can reuse it.

### ACP

The Agent Client Protocol, an open protocol that lets Copilot CLI act as an agent inside tools or systems that support ACP.

## Scope terms

### Official reference

Atlas content that states behavior supported by official GitHub Docs.

### Generic adaptation

Atlas content that explains how to combine official features into reusable patterns.

### Repo example

Atlas content that uses this `~/.copilot` repository as an example while making clear that the example is not an upstream default.