<!-- topic: tools-and-resources | section: mcp -->
# MCP Tools and Resources

## Quick Reference

> - Every MCP tool is named `mcp_{serverName}_{toolName}`.
> - Gemini CLI sanitizes server and tool names before building the fully qualified name.
> - Different servers do not collide because the server name is part of the tool name.
> - MCP prompts become slash commands such as `/poem-writer`.
> - MCP resources can be listed, read, or injected inline with `@server://resource/path`.

## Fully Qualified Names

Gemini CLI gives every discovered MCP tool a fully qualified name, abbreviated FQN. The FQN format is unconditional:

```text
mcp_{serverName}_{toolName}
```

The purpose of the FQN is to preserve the server origin of each tool while keeping every MCP tool in the shared global tool registry.

### Why the FQN Exists

Two different servers can expose tools with the same logical name, such as `search` or `fetch`. By prefixing each tool with `mcp_{serverName}_`, Gemini CLI prevents collisions across servers without requiring the tool author to rename the tool itself.

## Name Sanitization Rules

Gemini CLI sanitizes names before building the FQN.

| Rule | Effect |
|---|---|
| Characters other than letters, numbers, `_`, `-`, `.`, `:` | Replaced with `_` |
| Names longer than 63 characters | Truncated with middle replacement using `...` |

Sanitization applies so the final tool name remains stable and policy-friendly even when a server or tool exposes a less restrictive original name.

### Server Naming Constraint

Because the FQN uses an underscore separator after the `mcp_` prefix, server names must not contain underscores. Use `my-server`, not `my_server`.

That rule is not stylistic. The policy parser splits MCP FQNs on the first underscore after `mcp_`, so underscores inside the server name can make the server and tool boundary ambiguous.

## Conflict Resolution

FQNs automatically prevent collisions across different server names, but Gemini CLI still has one overwrite case to understand.

| Scenario | Result |
|---|---|
| Two different servers expose the same tool name | No conflict, because the server name keeps the FQN distinct |
| Two configured servers use the same alias and expose the same tool name | The last-registered tool overwrites the earlier one |

The practical rule is simple: unique server aliases eliminate avoidable conflict.

## MCP Prompts as Slash Commands

An MCP server can register prompts in addition to tools and resources. Gemini CLI exposes each prompt as a slash command using the prompt name.

If a server registers a prompt named `poem-writer`, Gemini CLI makes it available as:

```text
/poem-writer
```

Arguments can be passed positionally or with flag syntax.

```text
/poem-writer --title="Ode to Code" --mood=optimistic
```

This turns an MCP prompt into a reusable interactive shortcut rather than requiring the user to manually restate the workflow every time.

## Built-In MCP Resource Tools

A resource is server-exposed content addressable by URI. Gemini CLI ships with built-in tools for discovering and reading those resources.

| Tool | Description |
|---|---|
| `list_mcp_resources` | Lists available resources from all connected MCP servers; accepts an optional `serverName` filter |
| `read_mcp_resource` | Reads a specific resource by `uri` |

These tools are built into Gemini CLI itself. They are not renamed per server, because they operate as a common access layer over all connected MCP servers.

## `@` Syntax for Inline Resource Injection

Gemini CLI can inject an MCP resource directly into conversation context with `@` syntax.

```text
@server://resource/path
```

When Gemini CLI encounters that reference, it resolves the resource and places the resource content inline into the current conversation context. This is the fastest way to bring server-hosted reference material into a prompt without calling the resource tools manually first.

## Operational Summary

MCP tools, prompts, and resources are three different surfaces, but they all share the same discovery flow: Gemini CLI connects to a configured server, reads what the server advertises, normalizes names where needed, and exposes the result through standard CLI interaction patterns.
