# ADR 0003: Hooks as External Processes with stdin/stdout JSON Contract

**Status:** Accepted
**Date:** 2026-05-20
**Authors:** Theo Odawara

---

## Context

Claude Code exposes lifecycle events — `PreToolUse`, `PostToolUse`, `SessionEnd`, `UserPromptSubmit`, `PermissionRequest` — at which user-defined logic can run. Several behaviors in this configuration require injection at these points without modifying the Claude Code binary itself:

- Auto-approving specific tool permissions that are safe and repetitive (`PermissionRequest` event).
- Blocking git write operations on branches that should be protected (`PreToolUse` on `Bash`).
- Enforcing the mandatory planning protocol before a task begins (`UserPromptSubmit` event).
- Cleaning up leftover git worktrees after a session ends (`SessionEnd` event).

These are not occasional conveniences — they are structural guardrails. The hook mechanism needed to satisfy several non-negotiable properties: it must work across Linux, macOS, and Windows; the hook logic must be user-owned and version-controlled (not locked inside the binary); it must be able to approve, block, or inject content depending on the event type; and hook failures must never crash or block the main Claude session.

The design question was: what runtime model gives user-authored hooks the right expressive power with the least coupling to Claude Code internals?

## Decision

Hooks are implemented as external processes invoked by the Claude Code binary. The communication contract is strictly via standard I/O: the binary writes a JSON event payload to the process's **stdin**, the hook reads it, performs its logic, and writes a JSON response to **stdout**. The binary reads stdout and acts on the response.

This is the complete contract. The hook process is otherwise opaque to the binary — it can be written in any language, use any libraries, perform I/O against any external system, and the binary does not care. The only constraints are: read JSON from stdin, write JSON to stdout, exit with the appropriate code.

**Exit code semantics** are deliberately asymmetric. Exit code `2` is a hard signal: it aborts the triggering action. All other non-zero exit codes are logged and ignored — the session continues. This asymmetry is intentional: hook errors should not block Claude's work unless the hook explicitly decides to veto an action. Debugging a broken hook should not require killing the session.

**Node.js** is the recommended runtime for hook scripts. It is available on every machine where Claude Code is installed via npm, handles asynchronous stdin/stdout naturally, and JSON parsing is a built-in primitive. The four existing hooks in `~/.claude/hooks/` demonstrate this: `auto-approve-permissions.js`, `plan-first.js`, and `worktree-cleanup.js` are Node.js scripts. **PowerShell** is used for `block-git-write.ps1` specifically because the Windows environment requires it for reliable process-level behavior that is awkward to achieve cross-platform in Node.js.

Hook registration lives in `settings.json` under the `hooks` key, mapping event types to a `command` string and an optional `matcher` glob that filters by tool name (relevant for `PreToolUse` and `PostToolUse` events that fire per tool).

## Alternatives Considered

### Alternative A: Python as the default hook runtime

Use Python scripts as the standard hook implementation language, given its prevalence in developer toolchains.

**Pros:**
- Python is widely familiar across engineering backgrounds.
- Rich standard library for JSON, filesystem operations, and subprocess calls.
- Strong ecosystem for any hook logic that needs external integrations.

**Cons:**
- Python is not guaranteed present on all target machines. macOS ships Python 3, but version fragmentation (system Python vs pyenv vs venv) creates reliable failures.
- Python 2 vs Python 3 shebang ambiguity on older systems produces silent runtime errors.
- Virtual environment management introduces a dependency management problem just to run a hook.
- Node.js is already installed on any machine running Claude Code via npm — Python has no equivalent guarantee.

**Why rejected:**
- The runtime availability guarantee is the decisive factor. If a hook silently fails because the wrong Python version was resolved, the guardrail it implements disappears without warning. Node.js is the only runtime with a guaranteed presence on every supported platform via the npm installation path.

### Alternative B: In-process plugin model (WASM or embedded JS engine)

Run hook logic inside the Claude Code process itself, using a sandboxed runtime (e.g., a WASM module or an embedded V8 engine).

**Pros:**
- Zero process-spawn latency — hooks would execute in microseconds.
- Strong sandboxing guarantees — a malicious hook cannot access the host filesystem.
- Tight integration with binary internals if needed.

**Cons:**
- Requires maintaining a stable plugin ABI across Claude Code versions. Every binary release that changes internal event types or payload schemas is a breaking change for all existing plugins.
- Users cannot inspect, test, or modify plugin binaries the way they can a plain `.js` or `.ps1` file.
- WASM toolchain requirements increase the contributor barrier significantly.
- The external process model already achieves the necessary sandboxing for these use cases — the hooks here do not need access to binary internals.

**Why rejected:**
- The external process model has zero ABI requirements. Hooks are versioned alongside the configuration in git, testable in isolation (`echo '{"tool":"Bash","command":"git push"}' | node block-git-write.js`), and completely language-agnostic. No ABI maintenance burden justifies the complexity of an in-process plugin system for this use case.

### Alternative C: HTTP webhooks (hook as a local HTTP endpoint)

Each hook is an HTTP endpoint on localhost. The binary POSTs the event payload to the registered URL.

**Pros:**
- Language-agnostic in practice (any HTTP server works).
- Easy to develop and debug using standard HTTP tooling.
- Natural fit for hooks that need to call external services.

**Cons:**
- Requires the user to run a persistent local HTTP server just to handle hook events. This server must start before Claude Code, survive across sessions, and be managed as a separate process.
- Port conflicts, authentication, and server lifecycle management become new operational concerns.
- The `command` external-process model achieves all the same benefits (language-agnostic, easy to test, any runtime) without requiring a persistent daemon.
- HTTP adds a full networking stack where stdin/stdout suffices.

**Why rejected:**
- The operational cost of managing a persistent local HTTP server is disproportionate to the benefit. The stdin/stdout model gives identical language flexibility with no daemon requirement.

## Consequences

### Positive

- Hooks are plain files in a version-controlled directory — readable, editable, diffable, and testable without any special tooling.
- The external process model is runtime-agnostic: any language that can read stdin and write stdout works. The Node.js default is a recommendation, not a constraint.
- Testing a hook in isolation is trivial: pipe a JSON payload to it from the command line and inspect stdout.
- Hook failures are non-fatal by default. A bug in a hook that exits with code 1 is logged but does not interrupt the session; only a deliberate exit code 2 blocks an action.

### Negative / Tradeoffs

- Process spawning adds latency per hook event. For `PreToolUse` and `PostToolUse` events that fire on every tool call, this adds measurable overhead. Mitigated by tight timeout configuration in `settings.json`.
- Hook errors that exit non-2 are silently ignored from the session's perspective. A broken hook (syntax error, missing dependency) appears to do nothing rather than fail loudly. Debugging requires checking stderr output explicitly.

### Risks

- A hook that produces invalid JSON on stdout will cause the binary to fail to parse the response. Depending on the event type, this may be treated as a non-fatal error or may cause unexpected behavior. Mitigated by testing hooks with representative payloads before deployment.
- The non-fatal default for non-2 exit codes means a guardrail hook can silently stop working (e.g., due to a Node.js version upgrade that breaks a dependency). Periodic verification that hooks are activating as expected is the mitigation.

## Implementation Notes

The four existing hooks demonstrate the full range of hook capabilities:

- `auto-approve-permissions.js` — reads a `PermissionRequest` payload, checks the tool name and parameters against an allowlist, and outputs an `approve` response. Demonstrates conditional approval logic.
- `plan-first.js` — fires on `UserPromptSubmit`, inspects the prompt for planning-protocol compliance, and optionally injects a reminder. Demonstrates content injection.
- `worktree-cleanup.js` — fires on `SessionEnd`, enumerates leftover git worktrees, and removes stale ones. Demonstrates post-session cleanup with side effects.
- `block-git-write.ps1` — fires `PreToolUse` on `Bash` tool calls containing git write commands, exits 2 to block them. Demonstrates hard veto logic and PowerShell usage.

Hook registration in `settings.json` uses the `matcher` field to scope a hook to specific tools (e.g., `matcher: "Bash"` ensures `block-git-write.ps1` only fires for Bash tool calls, not all `PreToolUse` events). This keeps per-event overhead proportional to the number of hooks registered for that specific tool.

---

## Related

- [`docs/hooks/hooks-overview.md`](/home/theo/.claude/docs/hooks/hooks-overview.md) — full event list, JSON payload schemas per event type, and exit code contract reference.
- [`docs/hooks/hooks-patterns.md`](/home/theo/.claude/docs/hooks/hooks-patterns.md) — annotated implementations of all four existing hooks with commentary on the patterns used.
- [`docs/core/settings-json.md`](/home/theo/.claude/docs/core/settings-json.md) — `hooks` section structure in `settings.json`, including `command`, `matcher`, and timeout fields.

---

*ADR based on Michael Nygard's format.*
