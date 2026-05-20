# Agents — Overview

Agents are isolated Claude instances that the main session dispatches work to. Each agent has its own model configuration, tool list, and optionally a dedicated git worktree. Agents do not share conversation history with the main session — they receive a self-contained prompt and return a single result.

---

## Concepts

### What an agent is

An agent is a Claude Code sub-process defined by a markdown file in `~/.claude/agents/` (or `<repo>/agents/`). When invoked, it:
1. Starts with a clean context (no main session history)
2. Receives only what the invocation prompt contains
3. Uses its own tool list (not the main session's full tool set)
4. Runs until the task is complete
5. Returns a result to the main session

### The main session

The main session (what you interact with directly) is the sole orchestration layer. It:
- Reads context, plans work, and decides which agents to use
- Dispatches tasks to agents with fully self-contained prompts
- Synthesizes results from agents before responding to the user
- Never delegates orchestration to agents — agents execute, they don't orchestrate

### Isolation modes

| Mode | Value | Behavior |
|---|---|---|
| No isolation | (no `isolation` key) | Agent shares the main working directory |
| Worktree | `isolation: worktree` | A new git worktree is created for the agent; changes are isolated to that branch |

Worktree isolation is the default for `@engine` and `@creative`. It prevents agents from accidentally modifying in-progress work in the main branch.

When a worktree agent makes no changes, the worktree is automatically cleaned up. If changes are made, the worktree path and branch are returned to the main session.

---

## Model Selection

Each agent specifies its model in the frontmatter:

| Value | Model | When to use |
|---|---|---|
| `sonnet` | claude-sonnet-4-6 | Default for most tasks — strong balance of capability and speed |
| `opus` | claude-opus-4-7 | Complex reasoning, architectural decisions, high-stakes analysis |
| `haiku` | claude-haiku-4-5 | Fast, lightweight tasks — simple lookups, formatting, quick edits |

The main session and all three built-in agents use `sonnet` by default.

---

## Tool Lists

Agents have restricted tool sets defined in their frontmatter. This is intentional — minimal tools reduce the blast radius of agent mistakes.

| Agent | Tools |
|---|---|
| `@engine` | Read, Grep, Glob, Edit, Write, Bash, TodoRead, TodoWrite |
| `@creative` | Read, Grep, Glob, Edit, Write, Bash, WebSearch, TodoRead, TodoWrite |
| `@principal` | Read, Grep, Glob, Edit, Write, TodoRead, TodoWrite |

`@creative` includes `WebSearch` because documentation and design work often needs external references. `@principal` excludes `Bash` because it only produces documents, never executes commands.

---

## Invoking an Agent

The main session invokes agents via the `Agent` tool (internally) or using the `@agent-name` mention syntax in prompts:

```
@engine [CONTEXT NEEDED TO SELF-CONTAIN THE TASK] [TASK DESCRIPTION]
```

Because agents start cold, the invocation prompt must include all relevant context:
- What the task is and why it matters
- Which files are involved (file paths, not just "the auth module")
- What the desired outcome looks like
- What has already been tried or ruled out
- Any constraints or conventions to follow

**Never write:** `@engine fix the bug` — the agent has no idea what bug you mean.

**Write instead:** `@engine The POST /auth/login route at src/routes/auth.ts:42 returns 200 on failed login. It should return 401. Fix the status code and add the missing error body. Conventions: all errors follow ErrorResponse from src/types.ts.`

---

## Parallel Execution

Multiple agents can run simultaneously when tasks are independent:

```
Dispatch @engine and @creative in parallel:
- @engine: implement the API endpoint (backend scope)
- @creative: write the API documentation (docs scope)
```

The main session waits for both results before proceeding.

---

## The `Agent` Tool

The main session dispatches agents using the `Agent` tool with these parameters:

| Parameter | Description |
|---|---|
| `description` | 3–5 word label for the task (shown in UI) |
| `prompt` | The full self-contained task instruction |
| `subagent_type` | Which agent to use (`engine`, `creative`, `principal`, etc.) |
| `run_in_background` | Set to `true` for fire-and-forget; default is wait for result |
| `isolation` | Override isolation mode (`"worktree"` or omit) |

---

## When NOT to Use Agents

Agents have overhead. Don't use them for:
- Tasks that take fewer than a few tool calls
- Lookups where you already know the answer
- Simple single-file changes ≤ 3 lines
- Conversational questions

The main session handles these directly without spawning agents.

---

## Related

- [agents/agent-format.md](agent-format.md) — how to define an agent in a `.md` file
- [agents/agent-roster.md](agent-roster.md) — the 3 built-in agents
- [tools/built-in-tools.md](../tools/built-in-tools.md) — the `Agent` tool parameters
- [workflows/routing-protocol.md](../workflows/routing-protocol.md) — when and how agents are selected
