# MCP Servers

Label: **Official reference** with **generic adaptation** notes

MCP servers add external tools and data sources to Copilot CLI. They are the right construct when the built-in runtime does not already provide the capability you need.

## Built-in versus added servers

Official docs distinguish between:

- built-in MCP servers that ship with the CLI runtime
- user, workspace, or repository MCP servers that you configure yourself

The command reference lists current built-in servers such as `github-mcp-server`, `playwright`, `fetch`, and `time`. The add-MCP guide also notes that the GitHub MCP server is already available without extra setup.

## Where MCP configuration lives

| Scope | Official location |
| --- | --- |
| User | `~/.copilot/mcp-config.json` |
| Repository | `.github/mcp.json` |
| Workspace | `.mcp.json` |
| One session only | `--additional-mcp-config` |

If `COPILOT_HOME` is set, the user-level path moves with it.

## Transport types

Officially documented transport types are:

- `local` or `stdio`
- `http`
- `sse`

`stdio` is the standard MCP type name and is the best choice when you want the configuration to stay compatible across MCP clients. `sse` is still supported, but the add-MCP guide describes it as a legacy transport kept for backward compatibility.

## Ways to add a server

### Interactive flow

Use `/mcp add` in interactive mode.

The guided form lets you set:

- server name
- transport type
- command and args for local servers, or URL for remote servers
- environment variables or headers
- enabled tools

Saving with `Ctrl+S` makes the server available immediately without restarting the CLI.

### Direct file editing

Edit `~/.copilot/mcp-config.json` directly when you want to share config, review it in version control, or add multiple servers together.

## Management commands

Useful interactive commands include:

- `/mcp show`
- `/mcp show SERVER-NAME`
- `/mcp edit SERVER-NAME`
- `/mcp delete SERVER-NAME`
- `/mcp disable SERVER-NAME`
- `/mcp enable SERVER-NAME`
- `/mcp auth SERVER-NAME` for OAuth re-authentication when needed

The command reference also documents non-interactive `copilot mcp` subcommands.

## Trust and governance

The command reference documents trust levels for different sources:

- built-in
- repository
- workspace
- user config
- remote servers

It also documents enterprise MCP allowlist enforcement for approved non-default servers. That matters when you design reusable docs for teams, because a configuration that works locally may still be blocked by enterprise policy.

## Migration note

If a project already has `.vscode/mcp.json`, the command reference documents a migration path to `.mcp.json` for Copilot CLI by remapping the `servers` key to `mcpServers`.

## Generic adaptation guidance

When translating from another ecosystem, choose MCP when the source pattern does one of these:

- reaches outside the repository
- exposes a tool or API surface
- needs authenticated access to a remote or local service
- adds executable capability rather than just instructions

If the pattern is only about how to behave while using existing tools, a skill or custom instructions page is usually a better fit.

## Repo example

This repository's [mcp-config.json](../../mcp-config.json) is a personal user-level MCP configuration. It is useful as an example of a populated config file, but it is not a statement about which servers are official defaults.

## Sources

- [Adding MCP servers for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers)
- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- [GitHub Copilot CLI configuration directory](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference)
- [Invoking custom agents](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/invoke-custom-agents)