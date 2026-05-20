# Custom Commands

There are 4 global custom commands in `~/.claude/commands/`. Each is a Markdown file that Claude executes as a user prompt when invoked by its slash name.

---

## Creating a Command

1. Create a file at `~/.claude/commands/<name>.md` (global) or `.claude/commands/<name>.md` (project-local):

```markdown
---
description: What this command does — shown in /help
---

Prompt body. Use $ARGUMENTS for user-provided arguments.
```

2. The command is immediately available as `/<name>` — no restart needed.

**Filename rules:**
- Lowercase, hyphens for spaces: `my-command.md` → `/my-command`
- Nested directories create namespaced commands: `db/migrate.md` → `/db:migrate`
- No `.md` extension in the invocation name

---

## The 4 Global Custom Commands

### `/bootstrap-project`

**File:** `~/.claude/commands/bootstrap-project.md`
**Description:** Bootstrap a new project — invokes @principal to create CLAUDE.md, detect the stack, and define conventions.

**What it does:**
1. Scans the repo for manifest files (`package.json`, `Cargo.toml`, `pyproject.toml`, `Dockerfile`, `.github/workflows/`, etc.)
2. Infers stack, package manager, and toolchain without asking
3. Asks only about what could not be inferred
4. Creates `CLAUDE.md` at the project root with: stack, conventions, exact lint/typecheck/format/build/test commands, folder structure

**When to use:** At the start of any new project, or when onboarding a repo that lacks a project CLAUDE.md.

**Invocation:** `/bootstrap-project`

**Design note:** The command instructs Claude not to duplicate rules already in `~/.claude/CLAUDE.md` — the generated CLAUDE.md is additive and project-scoped only.

---

### `/closeout`

**File:** `~/.claude/commands/closeout.md`
**Description:** Run the mandatory Closeout Protocol — validates docs, ADR, CHANGELOG, migrations, and vault before declaring the task complete.

**What it does:**
Runs all 9 items of the Closeout Protocol checklist and emits the required verbatim output format:

```
Closeout:
- Repo docs:      [applied in <path> / n/a]
- ADR:            [applied / n/a]
- CHANGELOG:      [applied / n/a]
- Setup/run:      [applied / n/a]
- Migration:      [applied / n/a]
- Vault prefs:    [<slug> / n/a]
- Vault patterns: [<slug> / n/a]
- Vault decision: [<slug> / n/a]
- Vault session:  [<slug> / n/a]
```

**When to use:** At the end of any implementation session, after all checks pass. The Closeout Protocol is also enforced by `~/.claude/rules/closeout.md` — this command makes it easy to trigger explicitly.

**Invocation:** `/closeout`

---

### `/run-audit`

**File:** `~/.claude/commands/run-audit.md`
**Description:** Run a full security audit on `$ARGUMENTS` — invokes @engine with the security-audit skill.

**What it does:**
Runs a full OWASP-aligned security audit on the specified target. Delivers:
- Findings classified by severity: Critical / High / Medium / Low / Informational
- Threat surfaces and attack vectors per finding
- Recommended fixes detailed enough to act on immediately
- Areas outside scope that warrant follow-up

**When to use:** Before any release, when auditing a specific module, or as part of a security review cycle.

**Invocation:** `/run-audit src/auth/` or `/run-audit the payment flow`

If invoked without arguments, Claude asks for the target before proceeding.

---

### `/start-spec`

**File:** `~/.claude/commands/start-spec.md`
**Description:** Start a new spec — invokes @principal to create an ADR, Tech Spec, or plan.md.

**What it does:**
1. Asks for: problem statement, personas/stakeholders, acceptance criteria (given/when/then), constraints
2. Surfaces any ambiguity before writing — does not produce a doc with unresolved questions
3. Produces the right output type:
   - **ADR or Tech Spec** → saved to `docs/decisions/` in the repo (architectural/cross-cutting decisions)
   - **Execution plan** → `plan.md`, ordered by dependency, with responsible agent and acceptance criteria per task

**When to use:** Before any non-trivial implementation. Creating the spec upfront is cheaper than implementation rework.

**Invocation:** `/start-spec`

---

## `$ARGUMENTS` Patterns

```markdown
# Zero arguments — command is self-contained
/closeout
/bootstrap-project

# One target argument
/run-audit src/auth/

# Multi-word argument (everything after the command name)
/run-audit the user authentication module and all JWT handling
```

Within the command body:
```markdown
Audit target: $ARGUMENTS

If $ARGUMENTS is empty, ask for the target before proceeding.
```

---

## When to Use a Command vs a Skill vs a Rule

| Scenario | Use |
|---|---|
| Reusable prompt with optional arguments | Command (`.claude/commands/`) |
| Domain-specific multi-step workflow (automatically routed) | Skill (`~/.claude/skills/*/SKILL.md`) |
| Always-on constraint or convention | `CLAUDE.md` rule |
| File-type convention (triggers on path match) | `.claude/rules/<topic>.md` |

Commands are best for: one-shot tasks with a clear output, things you want to invoke explicitly by name, and workflows you want to hand to users with a simple `/command` interface.

---

## Related

- [commands/commands-overview.md](commands-overview.md) — discovery, format, substitutions
- [commands/commands-catalog.md](commands-catalog.md) — all built-in commands
- [skills/skill-format.md](../skills/skill-format.md) — extended SKILL.md format (model, effort, hooks, context)
- [workflows/closeout-protocol.md](../workflows/closeout-protocol.md) — what /closeout runs
