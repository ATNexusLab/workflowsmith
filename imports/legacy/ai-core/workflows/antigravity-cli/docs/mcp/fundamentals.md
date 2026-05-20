<!-- topic: fundamentals | section: mcp -->
# MCP Fundamentals

## Quick Reference

> - MCP stands for Model Context Protocol: a standard bridge between Gemini CLI and external servers.
> - Gemini CLI is an MCP client only; it does not host MCP servers.
> - MCP servers can expose tools, resources, and prompts.
> - Gemini CLI supports stdio, SSE, and streamable HTTP transports.
> - MCP prompts become slash commands, and MCP resources can be injected with `@server://resource/path`.

## What MCP Is

MCP, short for Model Context Protocol, is a standardized bridge that lets Gemini CLI connect to external applications called MCP servers. An MCP server advertises capabilities in a structured way so the CLI can discover and use them without custom per-server integration logic.

In practice, MCP gives Gemini CLI a uniform way to reach outside the local built-in toolset. Instead of hardcoding one-off integrations, the CLI connects to separately running servers that expose capabilities through the MCP protocol.

## Gemini CLI's Role

Gemini CLI acts as an MCP client only. It does not host, embed, or publish MCP servers itself.

That distinction matters operationally. Every MCP server must exist outside the CLI: either as a local subprocess started by Gemini CLI, or as a remote service that Gemini CLI connects to over a network transport.

## What MCP Adds to Gemini CLI

MCP contributes three kinds of value to Gemini CLI.

| Capability | What it means in practice |
|---|---|
| Tool execution | The server exposes callable tools, and Gemini CLI can invoke them as part of normal agent work |
| Resource access | The server exposes addressable content such as files, API payloads, or generated data that Gemini CLI can read into context |
| Prompt shortcuts | The server exposes prompts that Gemini CLI turns into slash commands for reusable workflows |

These three surfaces make MCP more than a remote procedure call layer. It also acts as a structured context and workflow extension mechanism.

This documented MCP surface is limited to tools, resources, prompts, and transports. It is separate from the hooks event system and should not be read as hook-style lifecycle interception or extra runtime gating.

## Transport Mechanisms

Gemini CLI supports three MCP transport mechanisms.

| Transport | Configuration key | How it works |
|---|---|---|
| Stdio | `command` | Gemini CLI starts a subprocess and communicates with the server through stdin and stdout |
| SSE | `url` | Gemini CLI connects to a Server-Sent Events endpoint |
| Streamable HTTP | `httpUrl` | Gemini CLI connects to an HTTP streaming endpoint |

### Transport Selection Logic

Gemini CLI resolves transport type from configuration using this precedence order:

1. `httpUrl` → Streamable HTTP
2. `url` → SSE
3. `command` → stdio

This means `httpUrl` wins over `url`, and `url` wins over `command`. In practice, define only one transport key per server to keep configuration unambiguous.

## Discovery and Registration

At startup, Gemini CLI connects to each configured MCP server and fetches its advertised tool definitions. The CLI then normalizes those definitions and registers them in the same global tool registry that also holds built-in tools.

From the model's point of view, MCP tools become part of the overall callable tool set for the session. They are not handled as a separate manual workflow after discovery completes.

## MCP Tools in the Global Tool Registry

All discovered MCP tools are registered alongside Gemini CLI's built-in tools. That shared registry is what allows the model to choose an MCP tool during ordinary tool-use reasoning without switching to a different execution mode.

Each discovered tool still preserves its server origin through its fully qualified name, but operationally it behaves like any other callable tool the CLI knows about.

## MCP Prompts as Slash Commands

An MCP server can register prompts in addition to tools. Gemini CLI converts each registered prompt into a slash command.

For example, if a server exposes a prompt named `poem-writer`, Gemini CLI makes it available as:

```text
/poem-writer
```

The prompt can then be invoked with positional arguments or flag-style arguments, depending on how the server defines its prompt inputs.

## MCP Resources and Inline Injection

An MCP resource is server-exposed content addressable by URI. Gemini CLI can access those resources through built-in MCP resource tools, and it can also inject resource contents directly into a conversation.

Use this inline resource syntax:

```text
@server://resource/path
```

When Gemini CLI encounters that syntax, it resolves the referenced MCP resource and injects the resource content into the conversation context for the current interaction.
