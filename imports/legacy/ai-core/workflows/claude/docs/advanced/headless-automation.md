# Headless Automation

Running Claude Code without a human in the loop — CI pipelines, cron jobs, background agent tasks.

---

## One-Shot Mode (`-p` / `--print`)

```bash
claude -p "<prompt>"
claude --print "<prompt>"
```

The process exits after one response. Suitable for scripting anywhere an interactive session would block.

**Output formats** (`--output-format`):

| Format | Output | Use when |
|---|---|---|
| `text` | Plain string to stdout | Shell scripts, log lines, simple capture |
| `json` | Single JSON object with full turn | Need `.result`, `.is_error`, token counts |
| `stream-json` | NDJSON — one object per event | Real-time CI log streaming, progress feedback |

**Stdin piping:**
```bash
cat diff.txt | claude -p "Review this diff for security issues" --output-format json
git diff $BASE...HEAD | claude -p "Summarize changes for the changelog" --output-format text
```

---

## Max-Turns Guard

Always set `--max-turns N` in automated contexts. Without it, a looping task has no ceiling.

```bash
claude -p "Fix all failing tests" --max-turns 20 --output-format json
```

**Recommended values:**

| Task type | `--max-turns` |
|---|---|
| Simple text transformation | 3 |
| Lint-fix cycle | 5 |
| Test + fix cycle | 20 |
| Code review (read-only) | 3 |

When the ceiling is reached, Claude outputs whatever it has completed and exits with code 0. Check `.is_error` in JSON output to distinguish a clean finish from a forced stop.

---

## Permission Modes for Automation

Two approaches, depending on trust level:

**Option 1 — CLI flag (per invocation):**
```bash
claude -p "..." --permission-mode bypassPermissions
```

**Option 2 — `settings.json` for a dedicated automation profile:**
```json
{
  "permissions": {
    "allow": ["Read(**)", "Bash(npm run *)", "Write(src/**)"],
    "deny": ["Bash(git push*)", "Bash(git commit*)", "Write(**/.env*)"]
  }
}
```

**Safety prerequisite checklist before using `bypassPermissions`:**
- [ ] Running inside a sandboxed environment (GitHub Actions runner, Docker container, VM)
- [ ] No production database credentials in the process environment
- [ ] No production API keys beyond `ANTHROPIC_API_KEY`
- [ ] `--disallowedTools 'Bash(git push*)'` set as a hard fence, or push hooks removed
- [ ] `--max-turns` is set

---

## Output Parsing

**`stream-json` format:** each line is a JSON object with a `type` field. The final answer arrives as `type: "result"`.

Extract the final text:
```bash
claude -p "Generate a release summary" \
  --output-format stream-json \
  | jq -r 'select(.type == "result") | .result'
```

Check whether the run errored:
```bash
claude -p "Fix the build" --output-format json | jq '.is_error'
```

Capture both result and error state:
```bash
output=$(claude -p "..." --output-format json)
is_error=$(echo "$output" | jq '.is_error')
result=$(echo "$output" | jq -r '.result')
```

Useful `type` values in `stream-json`:
- `"text"` — streaming content chunk
- `"tool_use"` — tool being called
- `"result"` — final answer (the object you usually want)
- `"error"` — hard failure

---

## Hook Interactions in Headless Mode

**`auto-approve-permissions.js`** — the recommended pattern for fully automated runs. It returns `permissionDecision: 'allow'` unconditionally, eliminating all interactive permission prompts. See [`hooks/hooks-patterns.md`](../hooks/hooks-patterns.md) for the implementation.

**`plan-first.js`** — injects the mandatory planning protocol on every `UserPromptSubmit`. This is useful in interactive sessions but adds noise and latency in CI. For automation runs, either:
- Remove it from `settings.json` for the automation invocation, or
- Maintain a separate `settings.json` file and pass it with a wrapper that swaps configs before running

**`block-git-write.ps1`** — the `PreToolUse` hook that vetoes git writes. Keep this active in CI even when using `bypassPermissions`; it fires at the tool-execution layer, after permission checks.

---

## Required Environment Variables

| Variable | Required | Notes |
|---|---|---|
| `ANTHROPIC_API_KEY` | Yes | Authentication — must be set or Claude exits immediately |
| `CLAUDE_MODEL` | No | Overrides `model` in `settings.json` |
| `CLAUDE_EFFORT` | No | `low`, `normal`, or `high` — overrides `effort` in settings |
| `NO_COLOR` | No | Set to `1` to strip ANSI codes from `text` output |

---

## GitHub Actions Recipe

```yaml
- name: Claude code review
  run: |
    git diff ${{ github.base_ref }}...HEAD > /tmp/diff.txt
    result=$(cat /tmp/diff.txt | claude -p "Review this diff. Flag any security issues or bugs." \
      --output-format json \
      --max-turns 5 \
      --permission-mode bypassPermissions \
      --disallowedTools 'Bash(git push*),Bash(git commit*)' \
      | jq -r '.result')
    echo "$result"
  env:
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

For longer tasks (test-fix cycles), increase `--max-turns` and add a step timeout:
```yaml
- name: Auto-fix failing tests
  timeout-minutes: 15
  run: |
    claude -p "Run the test suite and fix all failures." \
      --output-format json \
      --max-turns 20 \
      --permission-mode bypassPermissions \
      | jq -r 'if .is_error then error(.result) else .result end'
  env:
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

---

## Safety Checklist

Before any headless run in a shared or production-adjacent environment:

- Run in a sandboxed environment (GitHub Actions runner, Docker container, isolated VM)
- Set `--disallowedTools 'Bash(git push*)'` as a hard fence against pushes
- Always set `--max-turns` — never run without a ceiling in CI
- Verify `ANTHROPIC_API_KEY` is scoped to the task (not a key with billing access or org-admin rights)
- Confirm no `.env.production` or production secrets are on disk in the working directory
- Log the `is_error` field from JSON output — a forced stop at max-turns returns `is_error: false`, but the work may be incomplete

---

## Related

- [`reference/cli-reference.md`](../reference/cli-reference.md) — full flag reference
- [`hooks/hooks-patterns.md`](../hooks/hooks-patterns.md) — `auto-approve-permissions.js` and `block-git-write.ps1`
- [`advanced/permission-controls.md`](permission-controls.md) — full permission resolution chain
