<!-- topic: configuration | section: hooks -->
# Hooks Configuration

> **Quick Reference**
> - Hooks are enabled globally with `hooksConfig.enabled: true` in `settings.json`.
> - `hooksConfig.notifications: true` turns on visual hook activity indicators.
> - An extension can declare hooks in `hooks/hooks.json` relative to its extension root.
> - Each hook entry defines a name, event, command, and optional matcher or environment variables.
> - Multiple hooks may target the same event; `BeforeToolSelection` results are union-aggregated.

## Where Hooks Are Declared

Gemini CLI supports two configuration shapes described in this section.

| Location | Purpose |
|---|---|
| `hooks/hooks.json` relative to an extension root | Declares hooks that ship with an extension |
| `settings.json` hook command definitions | Declares hooks directly in user or project settings |

Project-level hooks such as `.gemini/hooks.json` are untrusted by default and require explicit user trust before Gemini CLI will run them persistently.

## Master Toggles in settings.json

The hooks system is controlled by `hooksConfig` in `settings.json`.

```json
{
  "hooksConfig": {
    "enabled": true,
    "notifications": true
  }
}
```

| Setting | Type | Meaning |
|---|---|---|
| `hooksConfig.enabled` | `boolean` | Master switch for the hooks system |
| `hooksConfig.notifications` | `boolean` | Enables visual indicators and related hook notifications |

## hooks.json Structure

A minimal registry looks like this:

```json
{
  "hooks": [
    {
      "name": "my-hook",
      "event": "BeforeTool",
      "matcher": "write_file|replace",
      "command": "${extensionPath}/hooks/before-write.sh"
    }
  ]
}
```

## Hook Configuration Fields

| Field | Required | Type | Meaning |
|---|---|---|---|
| `name` | Yes | `string` | Display name shown in hook management surfaces |
| `event` | Yes | `string` | One of the 11 supported hook event names |
| `command` | Yes | `string` | Executable path or command line to run for the hook subprocess |
| `matcher` | No | `string` | Regex for `BeforeTool` and `AfterTool`; exact-string matcher for lifecycle events |
| `env` | No | `object` | Additional environment variables injected into the hook subprocess |

## Command Variable Expansion

`command` supports placeholder expansion.

| Variable | Expands to |
|---|---|
| `${extensionPath}` | The current extension root |
| `${workspacePath}` | The current workspace root |
| `${/}` | The platform path separator |

## Event Matching Rules

| Event type | Matcher behavior |
|---|---|
| `BeforeTool`, `AfterTool` | `matcher` is interpreted as a regular expression against the tool name |
| All other events | `matcher` is interpreted as an exact string |

Omit `matcher` when one hook should receive every occurrence of the configured event.

## Multiple Hooks Per Event

Gemini CLI executes every configured hook that matches an event. This means you can stack separate hooks for policy enforcement, audit logging, notifications, and argument rewriting.

`BeforeToolSelection` is special: multiple matching hooks do not overwrite one another. Their tool directives are union-aggregated, and `NONE` remains the dominant decision when more than one hook mentions the same tool.
