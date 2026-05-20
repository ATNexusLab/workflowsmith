# IDE Integration — Advanced Configuration

Configuration, debugging, and advanced workflows for the VS Code and JetBrains integrations. For installation, feature lists, and known limits, see [`reference/ide-integrations.md`](../reference/ide-integrations.md).

---

## Scoped Settings in IDE Context

When a project folder is opened in VS Code or a JetBrains IDE, `.claude/settings.json` at the project root is automatically applied on top of `~/.claude/settings.json`. No IDE-specific configuration is needed — it is the same merge behavior as the CLI.

To override the working directory Claude operates from (useful when the IDE workspace root differs from the intended Claude Code root):

```bash
claude --add-dir /path/to/actual/project/root
```

`--add-dir` adds a directory to Claude's accessible roots without changing the shell working directory. Run this in the IDE's integrated terminal before starting a session to anchor context correctly.

---

## Multi-Root Workspaces (VS Code)

When VS Code has multiple root folders open, Claude Code selects the project root using this rule: **the first folder that contains a `CLAUDE.md` file**.

If no folder has a `CLAUDE.md`, Claude Code falls back to the first folder in the workspace.

To pin Claude to a specific root when the auto-detection picks the wrong one:
1. Open a terminal scoped to the target folder (right-click the folder in the Explorer → "Open in Integrated Terminal")
2. Run `claude --add-dir .` to explicitly register that directory

**MCP servers in multi-root workspaces:** `~/.claude/mcp.json` is always loaded globally. For project-scoped MCP overrides, place a `.claude/mcp.json` at the specific project root. The same path-layering logic applies as with `settings.json` — project-level adds to or overrides global entries by server name.

---

## Shell Hook Execution in IDE Sessions

Hooks (`UserPromptSubmit`, `SessionEnd`, `PreToolUse`, etc.) fire in IDE sessions. The extension spawns each hook process in the same environment the IDE process itself runs in.

**Common issue — hooks that rely on interactive shell configuration fail silently.** If a hook uses aliases, functions, or `$PATH` entries set in `.bashrc` / `.zshrc`, those may not be present in the IDE's process environment, which is typically initialized from the OS launch environment (not a login/interactive shell).

**Workaround — use absolute paths in hook `command` fields:**
```json
{
  "type": "command",
  "command": "/usr/local/bin/node",
  "args": ["/home/user/.claude/hooks/my-hook.js"]
}
```

**Alternative — source the shell profile explicitly:**
```json
{
  "type": "command",
  "command": "/bin/bash",
  "args": ["-c", "source ~/.bashrc && node ~/.claude/hooks/my-hook.js"]
}
```

The second form adds latency (sourcing a profile can take 100–500ms). Prefer absolute paths when possible.

---

## MCP Server Debugging in IDE

MCP server `stderr` output is surfaced in VS Code via the **Output panel** (`View → Output`). Select `Claude (MCP: <server-name>)` from the dropdown to see that server's log stream.

**If a server fails to start, diagnose in this order:**

1. Check the `command` and `args` in `~/.claude/mcp.json` (or `.claude/mcp.json`).
2. Run the server command manually in a terminal to confirm it starts cleanly:
   ```bash
   node /path/to/server/index.js
   ```
3. Use the MCP Inspector for a full protocol-level trace:
   ```bash
   npx @modelcontextprotocol/inspector <command> <args>
   ```
   This opens a local UI showing the initialization handshake, tool listings, and individual call/response pairs.
4. For verbose Claude-side MCP logging, start the CLI with `--debug` in a terminal session. Note: `--debug` applies to the CLI process; it does not inject into extension-managed sessions directly.

---

## Keybindings Customization

The VS Code extension's default keybindings are listed in [`reference/ide-integrations.md`](../reference/ide-integrations.md). To override or add bindings, edit `keybindings.json` (`Ctrl+Shift+P` → "Open Keyboard Shortcuts (JSON)").

**Bind `/compact` to `Ctrl+Shift+M`:**
```json
{
  "key": "ctrl+shift+m",
  "command": "claude.sendMessage",
  "args": { "text": "/compact" },
  "when": "claude.sessionActive"
}
```

**Bind a custom prompt to a chord:**
```json
{
  "key": "ctrl+k ctrl+r",
  "command": "claude.sendMessage",
  "args": { "text": "Review the current file for security issues." },
  "when": "editorFocus && claude.sessionActive"
}
```

`when` clauses support standard VS Code context keys (`editorFocus`, `editorHasSelection`, etc.) combined with `claude.sessionActive`.

---

## `statusLine` in IDE Context

The `statusLine.command` in `settings.json` outputs a string displayed in the IDE status bar (bottom bar in VS Code, status bar in JetBrains). The extension polls the command on each session tick.

**Keep the command under 100ms.** The status bar updates frequently; a slow command creates visible lag.

**Example — show active model name:**
```json
{
  "statusLine": {
    "type": "command",
    "command": "node -e \"const d=require('fs').readFileSync('/dev/stdin','utf8');const p=JSON.parse(d);process.stdout.write('claude: '+p.model)\""
  }
}
```

The command receives a JSON object on stdin (the same schema as the `statusLine` input documented in [`core/settings-json.md`](../core/settings-json.md)):
```json
{ "model": "claude-sonnet-4-6", "sessionId": "...", "cwd": "...", "contextUsage": 0.42 }
```

A simpler pattern using a shell script:
```bash
#!/bin/bash
# ~/.claude/statusline.sh
input=$(cat)
model=$(echo "$input" | jq -r '.model // "unknown"')
ctx=$(echo "$input" | jq '(.contextUsage * 100 | floor | tostring) + "%"' -r)
echo "claude:${model} ctx:${ctx}"
```

```json
{ "statusLine": { "type": "command", "command": "bash ~/.claude/statusline.sh" } }
```

---

## Session Continuity Across IDE and CLI

Sessions started in the IDE can be resumed in the CLI and vice versa. Sessions are surface-agnostic.

**Find session IDs:**
```bash
ls ~/.claude/projects/<encoded-path>/
```

Each `.jsonl` file is one session; the filename without the extension is the session ID.

**Resume a session started in VS Code, now in terminal:**
```bash
claude --resume <session-id>
```

The encoded path replaces `/` with `-` and strips the leading `/` from the absolute project root path. For a project at `/home/user/myapp`:
```
~/.claude/projects/home-user-myapp/
```

Sessions are stored as append-only JSONL and are not automatically deleted. To clean up old sessions, remove the `.jsonl` files directly.

---

## JetBrains-Specific Notes

The JetBrains plugin uses the same Claude Code CLI binary and `~/.claude/` configuration as VS Code. No separate config is needed — all settings, hooks, MCP servers, and agents are shared.

**Tool window persistence:** the tool window open/closed state and panel size persist across IDE restarts via JetBrains' own workspace `.idea/` settings. This is not a Claude Code setting.

**Shell hook behavior** is identical to VS Code: hooks fire in the process environment of the IDE launcher. The same workaround applies — use absolute paths in hook `command` fields when shell profile configuration is needed.

**Inline intentions:** Claude Code actions appear in the JetBrains "Show Context Actions" menu (`Alt+Enter`). These are not configurable via `settings.json` — they are part of the plugin's built-in integration with the JetBrains platform.

---

## Related

- [`reference/ide-integrations.md`](../reference/ide-integrations.md) — installation, features, known limits
- [`core/settings-json.md`](../core/settings-json.md) — `statusLine` schema, `hooks`, `permissions`
- [`hooks/hooks-overview.md`](../hooks/hooks-overview.md) — hook event types and execution contract
