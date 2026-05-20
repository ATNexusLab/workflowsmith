# Hooks — Patterns

Four hook implementations live in `~/.claude/hooks/`. Each demonstrates a real pattern for a different event and use case.

---

## Pattern 1 — Plan-First Enforcement (`plan-first.js`)

**Event:** `UserPromptSubmit`
**Type:** `command`
**Purpose:** Inject the mandatory planning protocol into Claude's context on every prompt, preventing the model from skipping the GitHub issue → @principal plan → execute flow.

```javascript
#!/usr/bin/env node
const chunks = [];
process.stdin.on('data', (chunk) => chunks.push(chunk));
process.stdin.on('end', () => {
  const additionalContext = `
MANDATORY PLANNING PROTOCOL — applies to every non-trivial task ...
STEP 1 — GitHub Issue (FIRST): ...
STEP 2 — @principal Plan (BEFORE implementation): ...
STEP 3 — Execute: Only after issue and plan are ready.
Skip ONLY for: pure conversation, quick lookups, single-file ≤ 3 lines, diagnostics.
`.trim();

  process.stdout.write(JSON.stringify({
    hookSpecificOutput: {
      hookEventName: 'UserPromptSubmit',
      additionalContext,
    },
  }));
});
```

**Key mechanics:**
- Fires on every user message, not just the first
- Injects text via `additionalContext` — Claude sees this as additional instructions
- Does not read stdin content (ignores the actual prompt); the injection is unconditional
- Timeout: 30s (UserPromptSubmit default)

**Settings.json registration:**
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [{ "type": "command", "command": "node", "args": ["~/.claude/hooks/plan-first.js"] }]
      }
    ]
  }
}
```

---

## Pattern 2 — Auto-Approve Permissions (`auto-approve-permissions.js`)

**Event:** `PermissionRequest`
**Type:** `command`
**Purpose:** Automatically approve all permission requests so Claude can operate in auto-mode without interrupting the user for every tool call.

```javascript
#!/usr/bin/env node
const chunks = [];
process.stdin.on('data', (chunk) => chunks.push(chunk));
process.stdin.on('end', () => {
  process.stdout.write(JSON.stringify({
    hookSpecificOutput: {
      hookEventName: 'PermissionRequest',
      permissionDecision: 'allow',
    },
  }));
});
```

**Key mechanics:**
- Returns `permissionDecision: 'allow'` unconditionally
- Works independently from git-write blocking (which is a `PreToolUse` event — different handler)
- Enables full auto-mode: Claude can read, write, and execute without stopping to ask

**Design note:** This hook and the `block-git-write.ps1` hook (PreToolUse) compose correctly — one approves permissions broadly, the other selectively blocks git write operations before they execute.

**Settings.json registration:**
```json
{
  "hooks": {
    "PermissionRequest": [
      {
        "hooks": [{ "type": "command", "command": "node", "args": ["~/.claude/hooks/auto-approve-permissions.js"] }]
      }
    ]
  }
}
```

---

## Pattern 3 — Block Git Writes (`block-git-write.ps1`)

**Event:** `PreToolUse`
**Type:** `command`
**Matcher:** `Bash`
**Purpose:** Intercept Bash tool calls and block git write operations (push, commit, tag, release) that could affect shared state without explicit approval.

```powershell
# block-git-write.ps1 — PreToolUse hook
# Reads tool input from stdin; blocks if it looks like a git write
param()
$input_json = $input | ConvertFrom-Json
$tool_input = $input_json.tool_input

# Check for destructive git patterns
$blocked_patterns = @('git push', 'git commit', 'git tag', 'git release', 'git reset --hard')
foreach ($pattern in $blocked_patterns) {
  if ($tool_input.command -match [regex]::Escape($pattern)) {
    $output = @{
      hookSpecificOutput = @{
        hookEventName = 'PreToolUse'
        decision = 'block'
        reason = "Git write operation blocked. Present diff to user and await explicit approval."
      }
    } | ConvertTo-Json
    Write-Output $output
    exit 0
  }
}
Write-Output '{}'
```

**Key mechanics:**
- Uses `matcher: "Bash"` to fire only on Bash tool calls (not on Read, Edit, etc.)
- Reads `tool_input.command` from the PreToolUse event payload
- Returns `decision: 'block'` with a reason shown to the user
- Returns `{}` (empty JSON) for non-matching patterns — Claude continues

**Settings.json registration:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "pwsh", "args": ["~/.claude/hooks/block-git-write.ps1"] }]
      }
    ]
  }
}
```

---

## Pattern 4 — Worktree Cleanup (`worktree-cleanup.js`)

**Event:** `SessionEnd`
**Type:** `command`
**Purpose:** Remove stale Claude-created worktrees from the session's repository on session exit. Claude Code creates worktrees with a `claude-` prefix; this hook cleans them up automatically.

```javascript
#!/usr/bin/env node
const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const chunks = [];
process.stdin.on('data', (chunk) => chunks.push(chunk));
process.stdin.on('end', () => {
  let input = {};
  try { input = JSON.parse(Buffer.concat(chunks).toString() || '{}'); } catch (_) {}
  const cwd = input.cwd || process.cwd();

  try {
    const gitRoot = execSync('git rev-parse --show-toplevel', { cwd, encoding: 'utf8' }).trim();
    const raw = execSync('git worktree list --porcelain', { cwd: gitRoot, encoding: 'utf8' });

    // Parse worktrees and filter stale claude- prefixed ones
    const stale = parseWorktrees(raw).filter(w =>
      path.basename(w.wtPath).startsWith('claude-') && w.wtPath !== gitRoot
    );

    for (const wt of stale) {
      // Skip locked worktrees (still active)
      const lockFile = path.join(gitRoot, '.git', 'worktrees', path.basename(wt.wtPath), 'locked');
      if (fs.existsSync(lockFile)) continue;
      try { execSync(`git worktree remove --force "${wt.wtPath}"`, { cwd: gitRoot }); }
      catch (_) {} // Non-fatal
    }
    if (stale.length > 0) execSync('git worktree prune', { cwd: gitRoot });
  } catch (_) {}  // Not a git repo or git unavailable — silently skip

  process.stdout.write('{}');
});
```

**Key mechanics:**
- Reads `cwd` from SessionEnd input to locate the correct git repo
- Uses `git worktree list --porcelain` and parses the output
- Only removes worktrees with `claude-` prefix (safe — won't touch user worktrees)
- Checks for a `locked` file before removing (skips active worktrees)
- Always writes `{}` — non-blocking, SessionEnd has no decision gate
- Silently swallows all errors (not a git repo, no worktrees, removal fails) — never interrupts session exit

**Settings.json registration:**
```json
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [{ "type": "command", "command": "node", "args": ["~/.claude/hooks/worktree-cleanup.js"] }]
      }
    ]
  }
}
```

---

## Node.js Hook Template

Base template for any new Node.js hook:

```javascript
#!/usr/bin/env node
const chunks = [];
process.stdin.on('data', (chunk) => chunks.push(chunk));
process.stdin.on('end', () => {
  let input = {};
  try { input = JSON.parse(Buffer.concat(chunks).toString() || '{}'); } catch (_) {}

  // Your logic here
  // Read: input.cwd, input.session_id, input.tool_input, etc.

  const output = {
    hookSpecificOutput: {
      hookEventName: input.hook_event_name,
      // event-specific fields here
    },
  };

  process.stdout.write(JSON.stringify(output));
});
```

---

## Related

- [hooks/hooks-overview.md](hooks-overview.md) — event types, handler types, JSON contract
- [hooks/hooks-reference.md](hooks-reference.md) — complete per-event JSON schemas
- [core/settings-json.md](../core/settings-json.md) — where hooks are configured
