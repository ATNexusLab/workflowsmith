# Context Management

Claude Code manages context across several dimensions: the model's context window (what fits in one session), plan mode (a restricted interaction mode for design-before-implement), and special session modes like /fast and /loop.

---

## Context Window

Claude Code operates within the model's context window. As a session grows, prior messages are compressed automatically to keep the active context manageable.

### What counts as context

- All user messages and Claude responses in the current session
- File contents read via the `Read` tool
- Tool output (Bash, WebSearch, etc.)
- System prompt, CLAUDE.md instructions, loaded skills, and imported rules

### Compression

When the session approaches the context limit, Claude Code automatically compresses older messages. The conversation continues, but early exchanges become a summary rather than full text. A new session (`/clear`) starts fresh.

### `ctx:N%` in the statusline

If configured, the status bar shows `ctx:N%` where `N` is the current context usage as a percentage. At 80%+ it is worth considering:
- Using `/compact` to compress the current session
- Starting a new session (`/clear`) for unrelated work
- Delegating large subtasks to agents (each agent runs in isolated context)

---

## Plan Mode

Plan mode is an interaction mode where Claude can only read files and write to the designated plan file. It cannot execute commands, edit other files, or take side-effecting actions.

### Entering and exiting plan mode

Plan mode is entered via the `ExitPlanMode` / `EnterPlanMode` tools, which are part of the system prompt in planning workflows. Users see a plan-first interface where Claude must write a plan before any implementation is approved.

When plan mode is active:
- Claude reads source files freely (read-only actions)
- Claude writes only to `~/.claude/plans/<session-slug>.md`
- The user reviews the plan and approves before execution resumes

### Plan file location and lifecycle

```
~/.claude/plans/<session-slug>.md
```

Plan files are **ephemeral** — they serve the session that created them and are not permanent design documents. For persistent architectural decisions, use ADRs via `@principal` + `spec-writing` skill.

The plan file is created by Claude during planning and referenced during execution. It is not committed by default.

---

## `/fast` Mode

`/fast` enables a higher-throughput mode using Claude Opus, optimized for faster output. It does not downgrade to a smaller model — it uses Opus with a configuration that prioritizes speed.

**Trade-off:** faster responses at the cost of reduced extended thinking depth. Use for quick iterations, interactive debugging, and tasks where speed matters more than deep multi-step reasoning.

Toggle with `/fast` in the session. The current mode is visible in the statusline.

---

## `/loop` — Dynamic Self-Pacing

`/loop` starts an autonomous loop where Claude re-invokes itself with the same prompt on a schedule it sets using `ScheduleWakeup`.

```
/loop <description of what to repeat>
```

The loop:
1. Claude executes the task
2. Calls `ScheduleWakeup` with a `delaySeconds` and the same prompt as the `prompt` parameter
3. Wakes up after the delay and repeats

### Delay selection strategy

The `delaySeconds` choice affects cache behavior and cost:

| Delay | Behavior | Use when |
|---|---|---|
| 60–270s | Stays within Anthropic's 5-minute prompt cache window (warm cache) | Actively polling fast-changing external state |
| 300s | Cache miss — worst of both (avoid) | — |
| 1200–1800s (20–30 min) | One cache miss, long idle window | Background monitoring, infrequent checks |

Use the `<<autonomous-loop-dynamic>>` sentinel as the `prompt` parameter in `ScheduleWakeup` to re-enter the autonomous loop behavior on each wake.

### Ending a loop

Call `ScheduleWakeup` without scheduling a future wake, or `/clear` the session.

---

## Agents and Context Isolation

Each agent invocation (`@engine`, `@creative`, `@principal`) runs in **isolated context** — it does not share the main session's conversation history. This is intentional:

- Agents start fresh, without the accumulated context of the main session
- Results return to the main session as a single summary message
- For agents with `isolation: worktree`, a git worktree is created for the duration of the task

Practical implication: when dispatching to an agent, the prompt must be fully self-contained. The agent does not know what the main session has already discussed.

---

## `/compact`

`/compact` compresses the current session's prior messages in place, freeing context space without starting a new session. The model retains a summary of compressed messages.

Use when:
- `ctx:N%` is above 70–80%
- The task is ongoing and starting a new session would lose important working state

---

## Context Strategy for Large Tasks

For large multi-phase tasks:
1. **Plan in plan mode** — produces a plan file without consuming much context
2. **Execute in phases via agents** — each agent has isolated context; main session stays lean
3. **Summarize between phases** — after an agent returns, extract only the essential result before dispatching the next agent
4. **Use `/compact` at phase boundaries** — compress early-phase context before starting the next

---

## Related

- [agents/agents-overview.md](../agents/agents-overview.md) — agent isolation modes
- [tools/task-tools.md](../tools/task-tools.md) — ScheduleWakeup for /loop
- [reference/cli-reference.md](../reference/cli-reference.md) — CLI model selection and session flags
