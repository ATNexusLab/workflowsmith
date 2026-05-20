# copilot.config — Repo Instructions

This repository IS the Copilot configuration for the user's environment.
Sessions working here are editing the agent/skill ecosystem itself — not application code.

---

## What This Repo Contains

```
copilot-instructions.md     ← global user-level instructions (all sessions)
agents/                     ← custom agent definitions (.agent.md files)
skills/                     ← custom skill definitions (SKILL.md + assets)
instructions/               ← reference documents (not active instruction surfaces)
docs/                       ← decisions (ADRs), environment patterns, reference docs
hooks/                      ← lifecycle hook definitions
```

The global `copilot-instructions.md` defines routing, task completion protocol, test contract,
and closeout protocol. It is the **source of truth** for cross-cutting invariants.
When in doubt about a rule, that file wins.

## Scope Caveat

This repository is a special case because it is both the user's `~/.copilot` home and a Git repository.

The root `copilot-instructions.md` is the personal-home layer. This file is the repo-scoped contract for this repository only.

Behavior observed here must be revalidated in a normal project repository before being generalized.

---

## Instruction Language

All repository-owned instruction surfaces are authored in **English**:

- `copilot-instructions.md`
- `.instructions.md`
- `SKILL.md`
- `.agent.md`

When you touch a legacy instruction file that is not in English, migrate it instead of extending mixed-language content.

---

## Ecosystem Map

Exactly **3 agents** exist in this ecosystem:

| Agent | Domain |
|---|---|
| `@engine` | Backend, infra, database, security, performance, ops, code review, git |
| `@creative` | Frontend (web + mobile), UX, brand, copy, conversion, documentation |
| `@principal` | Bootstrap, specs (ADRs, Tech Specs, Architecture Notes) |

**No other agent entity exists.** References to "Strategist", "@orchestrator", or any fourth
agent in `.agent.md` files are bugs — find and remove them.

The **main session** is the sole orchestrator. Agents report to it, not to each other.

---

## Agent-Skill Relationship

Agents run in **isolated context windows**. They do NOT automatically inherit skill content
loaded by the main session. When an agent mode references a skill (e.g., "follow the `brand-identity` skill"),
the agent is expected to invoke that skill in its own context or read `SKILL.md` directly.

**Convention:** Agent modes are **thin wrappers** — skill reference + agent-specific additions only.
Verbatim copy of skill content into an agent mode creates two sources of truth that will diverge.
The skill is canonical; the agent mode points to it and adds what only the agent can provide.
Global skills remain the baseline layer; repo-local skills and path-specific instructions add
specialization or constraints unless the repo contract explicitly declares an override.
When more than one concern is active, compose multiple skills instead of forcing a single-skill
reading of the task.

---

## Observability — Addendum for This Repo

The 4-line decision trail format (defined in the global `copilot-instructions.md` Skill-First Protocol) applies here unchanged. Additional constraints specific to this repo:

- Use `none` explicitly when a layer was not used (`global=none`, `local=none`).
- Both `global=` and `local=` may list multiple comma-separated skills; composition is expected when the task spans multiple concerns.
- Use concrete repo-relative paths and short reasons; avoid vague placeholders such as "checked docs" or "used memory if needed".
- `Route:` reports the final owner after routing, not every option that was considered.

---

## Invariants

Before declaring done, verify the thin wrapper rule, sole-orchestrator invariant, and ADR ownership as described in `## Agent-Skill Relationship` above and the global `copilot-instructions.md`. The "When Editing Agent Files" checklist below operationalizes all these checks.

---

## Task Completion Protocol — This Repo

This repository contains only Markdown configuration files. There is no build system, package manager, or test suite.

For work done here, the TCP checks (`lint → typecheck → format → build → tests`) are all **n/a**. Record this in Closeout and continue. Only pause if the user adds a manifest or toolchain.

---

## When Editing Agent Files

Before declaring done on any `.agent.md` edit, run this checklist:

1. **Ghost entities** — grep for agent names. Only `@engine`, `@creative`, `@principal` are valid references.
2. **ADR/routing cross-references** — verify any mention of ADRs, skill routing, or escalation against `copilot-instructions.md` as source of truth.
3. **Thin wrapper rule** — confirm no mode contains verbatim skill content. If it looks like a copy-paste from a `SKILL.md`, it should be a reference instead.
4. **Language** — `.agent.md`, `SKILL.md`, `.instructions.md`, and repo instruction files in this repository are written in English.
5. **Closeout** — even config edits go through Closeout Protocol (most items will be n/a; record that explicitly).
