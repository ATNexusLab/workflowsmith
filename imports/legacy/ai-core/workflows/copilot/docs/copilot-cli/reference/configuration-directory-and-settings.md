# Configuration Directory And Settings

Label: **Official reference**
Owner: `Configuration directory layout and settings scope`
Last checked: `2026-05-20`
Version note: Directory contents, documented settings keys, and supported repository-level keys can change between CLI releases.

This page owns the official layout of `~/.copilot`, the settings-scope cascade, and deletion safety guidance.

## Default home and relocation

By default, Copilot CLI stores configuration, state, logs, history, and user customizations under `~/.copilot`.

Official relocation variables:

| Variable | Effect |
| --- | --- |
| `COPILOT_HOME` | Moves the full configuration and state directory |
| `COPILOT_CACHE_HOME` | Moves cache storage without moving the full home directory |

## Top-level directory overview

| Path | Editable by users? | Official role |
| --- | --- | --- |
| `agents/` | Yes | Personal custom agent definitions |
| `skills/` | Yes | Personal custom skill definitions |
| `hooks/` | Yes | User-level hook scripts |
| `copilot-instructions.md` | Yes | Personal instructions applied to all sessions |
| `instructions/` | Yes | Additional personal `*.instructions.md` files |
| `mcp-config.json` | Yes | User-level MCP server definitions |
| `lsp-config.json` | Yes | User-level LSP server definitions |
| `settings.json` | Yes | Personal configuration settings |
| `config.json` | No | Automatically managed application state |
| `permissions-config.json` | No | Saved tool and directory permissions per project |
| `logs/` | No | Session log files |
| `session-state/` | No | Session history and workspace data |
| `command-history-state/` | No | Command-history data |
| `session-store.db` | No | SQLite cross-session data |
| `installed-plugins/` | No | Installed plugin files |
| `plugin-data/` | No | Persistent data for installed plugins |
| `ide/` | No | IDE integration state |

## Settings scope and precedence

The configuration-directory reference describes three file scopes for settings, with command-line options and environment variables above them.

| Scope | Location | Purpose |
| --- | --- | --- |
| User | `~/.copilot/settings.json` | Global defaults for all repositories |
| Repository | `.github/copilot/settings.json` | Shared repository configuration |
| Local | `.github/copilot/settings.local.json` | Personal overrides for one repository |

Important scope rules:

- repository and local files support only the documented repository schema
- unsupported keys at repository scope are ignored
- local settings use the same schema as repository settings and override them

## Repository-level keys

The official repository schema currently documents these keys:

| Key | Merge behavior | Description |
| --- | --- | --- |
| `companyAnnouncements` | Replaced | Startup messages |
| `disableAllHooks` | Repository takes precedence | Disable all hooks |
| `enabledPlugins` | Merged | Declarative plugin auto-install |
| `extraKnownMarketplaces` | Merged | Repository-scoped plugin marketplaces |
| `hooks` | Concatenated | Repository hooks run after user hooks |
| `mergeStrategy` | Repository takes precedence | Conflict resolution strategy for `/pr fix conflicts` |

## User settings ownership

The user settings file has a larger official key inventory. To avoid duplicating those keys across multiple pages, this atlas assigns them by fact area:

| Key family | Owner page |
| --- | --- |
| Trust, approvals, allowed and denied URLs, and ask-user behavior | [Tools, permissions, and safety controls](tools-permissions-and-safety-controls.md) |
| Model selection and reasoning controls | [Models, automation, and observability](models-automation-and-observability.md) |
| IDE auto-connect and diff-review behavior | [VS Code connection](../integrations/vs-code-connection.md) |
| Hook, plugin, agent, MCP, and skill content | Construct-specific pages under `constructs/` |

Use the official configuration-directory reference when you need the full raw settings-key table.

## Migration note

Official docs state that user-editable settings used to live in `config.json` and now live in `settings.json`. Existing settings are migrated automatically when possible.

## Deletion safety

Official deletion guidance is intentionally uneven:

| Item class | Official guidance | Main effect |
| --- | --- | --- |
| `logs/`, `plugin-data/` | Safe to delete | Re-created automatically |
| `permissions-config.json`, `session-state/`, `command-history-state/`, `session-store.db`, `settings.json`, `config.json` | With caution | Resets approvals, history, settings, or authentication state |
| `agents/`, `skills/`, `hooks/`, `copilot-instructions.md`, `instructions/`, `mcp-config.json`, `lsp-config.json`, `installed-plugins/` | Not recommended | Removes user-authored customizations or plugin state |

## Sources

- [GitHub Copilot CLI configuration directory](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference)
