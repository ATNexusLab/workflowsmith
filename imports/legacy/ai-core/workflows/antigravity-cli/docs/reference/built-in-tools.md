<!-- topic: built-in tools | section: reference -->
# Built-in Tools Reference

> **Quick Reference**
> - This file is the canonical reference for Gemini CLI built-in tools.
> - Tools are grouped by operational kind so you can scan by task.
> - “Key parameters” lists the fields you need most often, not every implementation detail.
> - “Return value” tells you what shape of result to expect back from the tool call.
> - Detailed notes appear only for tools whose behavior changes execution flow.

## What this file covers

Gemini CLI built-in tools are the native callable actions available to the agent during a session. They cover command execution, file and directory reads, file edits, web access, user interaction, planning, and internal runtime actions.

## Execute

| Tool | Description | Key Parameters | Return Value | Constraints |
|---|---|---|---|---|
| `run_shell_command` | Executes shell commands in the current environment. | `command` (required), `description`, `timeout` | Command result including stdout, stderr, and exit status. | Blocked in sandbox unless allowed; requires user confirm. |

## Read

| Tool | Description | Key Parameters | Return Value | Constraints |
|---|---|---|---|---|
| `read_file` | Reads the content of a single file. | `path` (required), `offset` (line number), `limit` (line count) | File content for the requested range. | Paths must be within allowed dirs. |
| `read_many_files` | Reads multiple files in one call. | `paths` (required array) | Concatenated file contents, usually labeled by file. | Same as `read_file`. |
| `list_directory` | Lists files and subdirectories at a path. | `path` (required) | Directory entries for the requested location. | No special constraint beyond directory access. |
| `glob` | Pattern-matches file paths. | `pattern` (required), `path` (base dir) | Matching paths. | No special constraint beyond directory access. |
| `grep` | Searches file contents with a regular expression. | `pattern` (required), `path`, `include`, `exclude` | Matching lines or matching file names, depending on mode. | No special constraint beyond directory access. |

## Edit

| Tool | Description | Key Parameters | Return Value | Constraints |
|---|---|---|---|---|
| `write_file` | Writes or overwrites a file. | `path` (required), `content` (required) | Write confirmation. | Triggers checkpoint if enabled. |
| `replace` | Replaces exact text in a file. | `path` (required), `old_string` (required), `new_string` (required) | Replacement result for the targeted match. | Triggers checkpoint; must match exactly once. |
| `edit` | Applies structured edits to a file. | `path` (required), `edits` (array of `{old, new}`) | Edit result after applying all valid replacements. | Use when multiple related changes belong in one edit operation. |

## Search

| Tool | Description | Key Parameters | Return Value | Constraints |
|---|---|---|---|---|
| `web_search` | Searches the web for current information. | `query` (required) | Grounded search summary with cited sources. | Requires network access. |

## Fetch

| Tool | Description | Key Parameters | Return Value | Constraints |
|---|---|---|---|---|
| `fetch` | Performs an HTTP GET request. | `url` (required) | Retrieved response body or fetch result payload. | Requires network access; blocked by sandbox unless allowed. |
| `list_mcp_resources` | Lists resources exposed by configured MCP servers. | `serverName` (optional filter) | Resource inventory, optionally filtered to one server. | Requires MCP servers configured. |
| `read_mcp_resource` | Reads an MCP resource by URI. | `uri` (required) | Resource content for the requested URI. | Requires MCP servers configured. |

## Communicate

| Tool | Description | Key Parameters | Return Value | Constraints |
|---|---|---|---|---|
| `ask_user` | Displays a prompt to the user and collects a response. | `prompt` (required), `choices` (optional array) | User response text or selected choice. | Interactive by nature; waits for user input. |

## Think

| Tool | Description | Key Parameters | Return Value | Constraints |
|---|---|---|---|---|
| `think` | Records an internal reasoning step without direct user output. | `thought` (required) | Internal reasoning state update. | Not shown to user by default. |

## Plan

| Tool | Description | Key Parameters | Return Value | Constraints |
|---|---|---|---|---|
| `enter_plan_mode` | Enters read-only planning mode. | `plan_title` (required), `plan_description` (required) | Plan-mode transition acknowledgement. | Requires user confirmation; auto-approved in headless mode. |
| `exit_plan_mode` | Exits plan mode and hands execution back to the session. | `plan_path` (required) | Approval result and execution handoff. | `plan_path` must be within the session plan directory under `~/.gemini/tmp/<project>/<session>/plans/`. |
| `write_todos` | Writes the session todo list. | `todos` (required array of `[{id, content, status, priority}]`) | Updated session todo state. | Only one `in_progress` item at a time; Ctrl+T toggles visibility. |

## Other

| Tool | Description | Key Parameters | Return Value | Constraints |
|---|---|---|---|---|
| `activate_skill` | Loads a skill by name. | `name` (required) | Skill activation result for the current agent context. | Model-only; cannot be invoked manually by users. |
| `complete_task` | Marks a subagent task as complete. | `result` (required) | Completion payload returned to the parent agent. | Subagent-only; not available to the user or main session. |
| `get_internal_docs` | Reads Gemini CLI’s own internal documentation. | `topic` (optional) | Internal documentation content or topic inventory. | Reads from the CLI package `docs/` directory. |
| `save_memory` | Persists memory across sessions when supported. | `content` (required), `key` (optional) | Persistence acknowledgement or saved-memory result. | Existence and behavior are unconfirmed; may be extension-only. |

## Detailed tool notes

### `write_todos`

`write_todos` manages a session-local task list for multi-step work.

```json
{
  "todos": [
    {
      "id": "docs-reference",
      "content": "Write the reference docs section",
      "status": "in_progress",
      "priority": "high"
    }
  ]
}
```

- `todos` array entries use this shape: `{id: string, content: string, status: "not_started"|"in_progress"|"done", priority: "low"|"medium"|"high"}`
- Only **one** item can have status `in_progress` at a time; setting a second one overwrites the first item’s status
- Toggle todo panel visibility with **Ctrl+T** in interactive mode
- Todos are session-local and do not persist across sessions

### `replace`

`replace` is the safest choice for one precise text substitution in one file.

- `old_string` must match **exactly once** in the file; the tool fails if it matches zero times or more than once
- It triggers a checkpoint snapshot before executing when checkpointing is enabled
- Use `edit` instead when you need multiple coordinated changes in the same file

### `enter_plan_mode` and `exit_plan_mode`

These tools control Gemini CLI plan mode, which separates research from execution.

- `enter_plan_mode` puts the session into read-only research mode; the model cannot modify files while plan mode is active
- `exit_plan_mode` requires `plan_path` to point to a Markdown file inside `~/.gemini/tmp/<project>/<session>/plans/`
- After plan exit, the session switches to YOLO mode, which auto-approves tool calls
- In headless mode, both tool calls are auto-approved and the session still switches to YOLO on plan exit
