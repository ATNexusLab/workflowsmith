# Permission Controls

The full permission system — resolution chain, advanced patterns, and the programmable gate. For the basics (`permissions.allow`, `permissions.deny`, and the schema), see [`core/settings-json.md`](../core/settings-json.md).

---

## Permission Resolution Order

Evaluated top-to-bottom. The first definitive decision wins; later steps only run if no decision has been made yet.

```
1. CLI flag --permission-mode          ← highest priority, overrides everything
2. settings.json permissions.deny      ← blocks matching tools unconditionally
3. settings.json permissions.allow     ← approves matching tools unconditionally
4. PermissionRequest hook handler      ← programmable gate (allow / deny / neutral)
5. Interactive prompt to user          ← only in interactive sessions; never fires in bypassPermissions
```

A tool that matches a `deny` pattern never reaches the hook or the user prompt. A tool that matches an `allow` pattern is approved before the hook fires. The hook only runs when neither `allow` nor `deny` matched.

---

## `permissions.allow` and `permissions.deny` Patterns

Patterns use glob syntax prefixed by tool name:

```
Bash(<glob>)    Read(<glob>)    Write(<glob>)    Edit(<glob>)
```

**Examples:**

```json
"permissions": {
  "allow": [
    "Read(**)",
    "Bash(npm run *)",
    "Bash(npx tsc*)"
  ],
  "deny": [
    "Bash(git push*)",
    "Bash(git commit*)",
    "Bash(rm -rf*)",
    "Write(**/.env*)"
  ]
}
```

**Precedence rule:** when a tool call matches both an `allow` and a `deny` pattern, **deny wins**. This applies within a single `settings.json` and across the global/project merge.

---

## Per-Project Permission Narrowing

Project-level `.claude/settings.json` adds restrictions on top of `~/.claude/settings.json`. It does not replace global settings.

**Use case — read-only analysis project:**
```json
// <project-root>/.claude/settings.json
{
  "permissions": {
    "deny": [
      "Write(**)",
      "Edit(**)",
      "Bash(git commit*)",
      "Bash(git push*)"
    ]
  }
}
```

The project deny list stacks on top of whatever is allowed globally. Global `allow` patterns do not override project `deny` patterns — deny wins at all levels.

---

## The `PermissionRequest` Hook as a Programmable Gate

The `PermissionRequest` hook fires when a tool call has not been resolved by `allow`/`deny` patterns. It receives:

```json
{
  "type": "PermissionRequest",
  "tool_name": "Bash",
  "tool_input": { "command": "npm run test" },
  "session_id": "...",
  "cwd": "/path/to/project"
}
```

It must return one of:
- `{ "decision": "allow" }` — approve without prompting
- `{ "decision": "deny" }` — reject without prompting
- `{}` (empty object) — neutral; pass to the next step (user prompt)

**Selective approver skeleton:**
```js
#!/usr/bin/env node
const chunks = [];
process.stdin.on('data', c => chunks.push(c));
process.stdin.on('end', () => {
  const event = JSON.parse(Buffer.concat(chunks).toString() || '{}');
  const allow =
    event.tool_name === 'Read' ||
    event.tool_name === 'Glob' ||
    event.tool_name === 'Grep' ||
    (event.tool_name === 'Bash' && /^npm run /.test(event.tool_input?.command ?? ''));
  process.stdout.write(JSON.stringify(allow ? { decision: 'allow' } : {}));
});
```

This approves all reads and safe `npm run` commands; everything else falls through to the user prompt. Compare to `auto-approve-permissions.js`, which approves everything unconditionally — see [`hooks/hooks-patterns.md`](../hooks/hooks-patterns.md).

---

## Permission Modes

| Mode | What it does | When to use |
|---|---|---|
| `default` | Prompts for potentially dangerous operations | Default interactive use |
| `acceptEdits` | Auto-approves file edits (`Write`, `Edit`); prompts for `Bash` | Trusting local edits, cautious on shell |
| `plan` | Read-only; can write to plan file only | Architecture review, investigation without side effects |
| `auto` | Auto-approves most operations; prompts for new or unusual tools | Faster interactive sessions |
| `dontAsk` | Minimal prompting; blocks only what `deny` patterns cover | Fully trusted local development |
| `bypassPermissions` | Bypasses all permission checks | CI, automation, sandboxed environments only |

Set via CLI flag for one-off overrides:
```bash
claude --permission-mode acceptEdits
```

Set in `settings.json` as the session default — there is no top-level `permissionMode` key; use `--permission-mode` at invocation time or rely on the mode implied by your `allow`/`deny` pattern set.

---

## Copy-Paste Deny Patterns

Baseline deny list for projects where Claude should never touch VCS writes, infrastructure secrets, or destructive shell operations:

```json
"permissions": {
  "deny": [
    "Bash(git push*)",
    "Bash(git commit*)",
    "Bash(git tag*)",
    "Bash(git reset --hard*)",
    "Bash(git rebase*)",
    "Bash(rm -rf*)",
    "Read(**/.env.production)",
    "Read(**/.env.staging)",
    "Write(**/.env*)",
    "Write(**/secrets/*)"
  ]
}
```

Add this to `~/.claude/settings.json` for global coverage, and supplement at the project level for tighter scoping.

---

## Interaction with `PreToolUse` Hook

The `PermissionRequest` hook and the `PreToolUse` hook serve different purposes and fire at different points.

**Full chain for a tool call:**
```
permission check (allow/deny patterns)
  → PermissionRequest hook (allow / deny / neutral)
    → user prompt if neutral (interactive only)
      → PreToolUse hook (block / proceed)
        → tool executes
```

- Use `PermissionRequest` for permission-level decisions: "auto-approve Read on anything," "always deny network fetches."
- Use `PreToolUse` for business logic vetoes: "never touch files in `legacy/`," "block any Bash command containing a production hostname."

`PreToolUse` `decision: 'block'` is a veto that fires **after** permission has been granted. It cannot be bypassed by `bypassPermissions` — it is a separate layer.

---

## Audit Trail

Every permission decision is recorded in the session transcript:

```
~/.claude/projects/<encoded-path>/<session-id>.jsonl
```

The encoded path is the project root with `/` replaced by `-` and the leading `/` stripped.

Example — project at `/home/user/myapp`:
```
~/.claude/projects/home-user-myapp/<session-id>.jsonl
```

Each JSONL line with `"type": "permission"` records the tool, the decision, and whether it came from a pattern, hook, or user prompt. Useful for auditing what Claude was allowed to do in a CI run.

---

## Related

- [`core/settings-json.md`](../core/settings-json.md) — `permissions` schema and merge behavior
- [`hooks/hooks-overview.md`](../hooks/hooks-overview.md) — `PermissionRequest` and `PreToolUse` event contracts
- [`hooks/hooks-patterns.md`](../hooks/hooks-patterns.md) — `auto-approve-permissions.js` implementation
