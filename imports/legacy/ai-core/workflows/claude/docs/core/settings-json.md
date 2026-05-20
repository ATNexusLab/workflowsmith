# settings.json

`settings.json` is the Claude Code runtime configuration file. It controls hooks, permissions, UI preferences, and the statusline. Unlike `CLAUDE.md`, it affects the runtime environment rather than the instruction contract.

---

## File Locations

| Location | Scope |
|---|---|
| `~/.claude/settings.json` | Global — applies to all sessions |
| `<repo-root>/.claude/settings.json` | Project — applies when Claude Code is inside that repo |

Project settings merge with global settings. For conflicting keys, project settings take precedence.

---

## Schema

```json
{
  "hooks": { ... },
  "autoUpdatesChannel": "latest" | "beta",
  "theme": "dark" | "light",
  "verbose": false,
  "statusLine": {
    "type": "command",
    "command": "<shell command>"
  },
  "permissions": {
    "allow": ["<tool-pattern>"],
    "deny": ["<tool-pattern>"]
  }
}
```

---

## `hooks`

The hooks section wires shell commands to Claude Code lifecycle events. Each event type gets an array of hook objects.

```json
{
  "hooks": {
    "<EventType>": [
      {
        "matcher": "<pattern>",
        "hooks": [
          {
            "type": "command",
            "command": "<executable>",
            "args": ["<arg1>", "<arg2>"],
            "if": "<condition>",
            "timeout": <milliseconds>
          }
        ]
      }
    ]
  }
}
```

**Supported event types:** `PreToolUse`, `PostToolUse`, `UserPromptSubmit`, `SessionEnd`, `PermissionRequest`, `Notification`, `Stop`

See [hooks/hooks-overview.md](../hooks/hooks-overview.md) for full event details and JSON contract.

### Example — 4-hook setup from `settings.json.template`

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "pwsh",
            "args": [
              "-NoProfile", "-NonInteractive",
              "-File", "%USERPROFILE%/.claude/hooks/block-git-write.ps1"
            ],
            "if": "Bash(git commit*|git push*|git tag*)"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "node",
            "args": ["-e", "require(require('os').homedir()+'/.claude/hooks/plan-first.js')"],
            "timeout": 10
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "node",
            "args": ["-e", "require(require('os').homedir()+'/.claude/hooks/worktree-cleanup.js')"],
            "timeout": 30
          }
        ]
      }
    ],
    "PermissionRequest": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "node",
            "args": ["-e", "require(require('os').homedir()+'/.claude/hooks/auto-approve-permissions.js')"],
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

### Hook object fields

| Field | Type | Description |
|---|---|---|
| `type` | `"command"` | Always `"command"` (the only supported type) |
| `command` | string | Executable to run (`node`, `pwsh`, `bash`, etc.) |
| `args` | string[] | Arguments passed to the executable |
| `if` | string | Optional condition — hook runs only if this matches the input |
| `timeout` | number | Milliseconds before the hook is killed (default: no timeout) |

The outer object with `matcher` and `hooks` array controls which tool calls trigger the hooks under `PreToolUse` and `PostToolUse`. Empty string `""` matches everything.

---

## `autoUpdatesChannel`

Controls which release channel Claude Code updates from.

| Value | Behavior |
|---|---|
| `"latest"` | Stable releases (recommended) |
| `"beta"` | Pre-release features |

---

## `theme`

```json
{ "theme": "dark" }
```

Controls the Claude Code UI color scheme. `"dark"` or `"light"`.

---

## `verbose`

```json
{ "verbose": false }
```

When `true`, enables verbose logging of tool calls and internal events.

---

## `statusLine`

Configures the status bar displayed in the Claude Code terminal UI.

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash $HOME/.claude/statusline-command.sh"
  }
}
```

The command is run periodically and its output is displayed in the status bar. Common uses: show current context usage (`ctx:N%`), model name, git branch.

### Input JSON provided to the statusLine command

```json
{
  "model": "claude-sonnet-4-6",
  "sessionId": "<uuid>",
  "cwd": "/path/to/working/directory",
  "contextUsage": 0.42
}
```

---

## `permissions`

Fine-grained tool allow/deny configuration.

```json
{
  "permissions": {
    "allow": ["Bash(npm run test)", "Read(**/*.ts)"],
    "deny": ["Bash(rm -rf*)"]
  }
}
```

Patterns use glob-style matching. Tool names prefix patterns: `Bash(...)`, `Read(...)`, `Write(...)`, etc.

When a tool call matches a `deny` pattern, it is blocked without prompting the user. When it matches an `allow` pattern, it proceeds without prompting.

---

## Adding a New Hook

1. Write the hook script (Node.js or shell) — see [hooks/hooks-patterns.md](../hooks/hooks-patterns.md) for patterns
2. Add an entry to `settings.json` under the appropriate event type:

```json
"SessionEnd": [
  {
    "matcher": "",
    "hooks": [
      {
        "type": "command",
        "command": "node",
        "args": ["-e", "require('/path/to/my-hook.js')"],
        "timeout": 30
      }
    ]
  }
]
```

3. Test: trigger the event and check that the hook executes

---

## Using `settings.json.template`

The `~/.claude/settings.json.template` file is a committed reference copy. The actual `settings.json` is listed in `.gitignore` to avoid committing sensitive values (e.g., API keys in hook args).

Workflow:
```bash
# On a new machine:
cp ~/.claude/settings.json.template ~/.claude/settings.json
# Edit to fill in actual values
```

---

## Related

- [hooks/hooks-overview.md](../hooks/hooks-overview.md) — hook event types and JSON contract
- [hooks/hooks-patterns.md](../hooks/hooks-patterns.md) — real hook implementations
- [core/scope-layers.md](scope-layers.md) — how settings merge across scopes
