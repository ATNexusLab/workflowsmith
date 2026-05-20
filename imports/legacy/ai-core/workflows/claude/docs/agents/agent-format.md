# Agent Format

An agent is defined by a single markdown file with YAML frontmatter. The file lives in `~/.claude/agents/` (global) or `<repo>/agents/` (project-local).

---

## Frontmatter Schema

```yaml
---
name: <string>           # Identifier used in @name mentions and routing
description: >           # One-paragraph description — used for automatic routing decisions
  <text>
model: sonnet | opus | haiku
color: blue | purple | orange | (any named color)
isolation: worktree      # Optional — omit for no isolation
tools: Read, Edit, Write, Bash, Grep, Glob, WebSearch, TodoRead, TodoWrite
---
```

### Fields

| Field | Required | Notes |
|---|---|---|
| `name` | Yes | Short identifier; used in `@name` invocations and routing table |
| `description` | Yes | Used by the routing system to select the right agent for a task |
| `model` | Yes | `sonnet`, `opus`, or `haiku` |
| `color` | No | Terminal UI display color — no functional effect |
| `isolation` | No | `worktree` creates a git worktree per invocation; omit for none |
| `tools` | Yes | Comma-separated list of tools the agent can use |

### Available tools

`Read`, `Grep`, `Glob`, `Edit`, `Write`, `Bash`, `WebSearch`, `WebFetch`, `TodoRead`, `TodoWrite`

Restrict tools to what the agent actually needs. A documentation agent does not need `Bash`. An audit agent should not have `Write`.

---

## Body Structure

The agent body follows this structure. Section titles are conventions, not enforced.

```markdown
# <AgentName> — <Role Title>

## Identity

[1–3 sentences: what this agent is, what it operates on, what it does not do.]
[Reference the canonical skill and CLAUDE.md instead of duplicating them here.]

## Operating Model

[How the agent approaches a task: what it reads first, what decisions it makes,
what it delegates back to the main session.]

## Canonical Skill Map

| Domain | Canonical skill | Agent role |
|---|---|---|
| [domain] | [skill-name] | [what the agent adds beyond the skill] |

## Execution Rules

[Behavioral rules specific to this agent. Do not duplicate CLAUDE.md rules.
Rules here are agent-specific additions or constraints.]

## Escalation Protocol

[When and how to stop and report back to the main session rather than continuing:
- Ambiguous scope
- Architectural decisions needed
- Blocked on a constraint only the user can resolve]

## Never Do

[Hard prohibitions specific to this agent's domain.
Do not list rules already in CLAUDE.md — they apply to all agents.]
```

---

## The Thin-Wrapper Pattern

Agents should be thin wrappers over canonical skills. The skill holds the domain expertise; the agent adds:
- Operating stance (what to read first, how to approach the problem)
- Skill composition (which skills to invoke for which sub-tasks)
- Escalation protocol (when to stop and report)
- Hard prohibitions specific to its domain

Do not duplicate skill content in the agent file. Reference it instead:
```markdown
## Operating Model
Invoke the canonical domain skill and add only technical synthesis,
prioritization, and execution direction.
```

This keeps agents maintainable — updating the skill updates behavior everywhere.

---

## Minimal Valid Agent

```yaml
---
name: auditor
description: >
  Security auditor. Use to review code, configurations, and dependencies
  for vulnerabilities without making any changes.
model: sonnet
color: red
tools: Read, Grep, Glob
---

# Auditor — Security Reviewer

## Identity

Read-only security review agent. Analyzes code for vulnerabilities using the
`security-audit` skill. Does not edit files.

## Operating Model

1. Invoke the `security-audit` skill for the threat model and OWASP surface checklist.
2. Read the target files and apply the checklist.
3. Report findings with severity and recommended fixes.
4. Do not implement fixes — report to the main session.

## Escalation Protocol

- Finding requires architectural change: flag explicitly, do not implement.
- Scope is unclear: stop and report options to the main session.

## Never Do

- Never edit, write, or delete any file.
- Never report a finding without a severity level.
```

---

## Real Examples

### `@engine` (System Architect)

```yaml
---
name: engine
description: >
  System Architect. Use for end-to-end technical work across architecture,
  backend, data, DevOps, performance, security, testing, review, and git
  operations. Acts as a thin wrapper over canonical skills and the global CLAUDE.md.
model: sonnet
color: blue
isolation: worktree
tools: Read, Grep, Glob, Edit, Write, Bash, TodoRead, TodoWrite
---
```

### `@creative` (Product Lead)

```yaml
---
name: creative
description: >
  Product Lead. Use for UX, frontend/mobile, brand identity, conversion copy,
  and human-facing documentation. Acts as a thin wrapper over canonical skills
  and keeps a high bar against generic AI aesthetics and copy.
model: sonnet
color: purple
isolation: worktree
tools: Read, Grep, Glob, Edit, Write, Bash, WebSearch, TodoRead, TodoWrite
---
```

### `@principal` (Bootstrap & Spec Writer)

```yaml
---
name: principal
description: >
  Bootstrap & Spec Writer. Use for two specific scenarios: (1) setting up a
  new project by creating CLAUDE.md in the repo root, detecting the stack,
  and defining conventions; (2) producing a spec or plan as a persistent
  document before execution. Does not orchestrate or delegate — output is
  always a document.
model: sonnet
color: orange
tools: Read, Grep, Glob, Edit, Write, TodoRead, TodoWrite
---
```

Note: `@principal` has no `isolation` key (no worktree) and no `Bash` tool — it only produces documents.

---

## Validation Checklist

- [ ] `name` is short, lowercase, and unique
- [ ] `description` accurately describes when to use this agent (routing depends on it)
- [ ] Tool list is minimal — only what the agent needs
- [ ] Body does not duplicate CLAUDE.md rules
- [ ] Body does not duplicate skill content — references skills instead
- [ ] Escalation protocol covers the main failure modes
- [ ] Never-Do list is agent-specific (not a copy of CLAUDE.md's Never-Do)

---

## Related

- [agents/agents-overview.md](agents-overview.md) — how agents work, isolation, invocation
- [agents/agent-roster.md](agent-roster.md) — the 3 built-in agents in detail
- [skills/skill-format.md](../skills/skill-format.md) — writing the skills agents invoke
