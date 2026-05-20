# CLAUDE.md Format

`CLAUDE.md` is the primary instruction file for Claude Code. It is read at session start and injects persistent behavioral rules, conventions, and routing logic into every interaction.

Claude Code looks for `CLAUDE.md` at multiple locations (scope layers). Each location is additive — deeper layers narrow or extend the global baseline.

---

## File Locations

| Location | Scope | When active |
|---|---|---|
| `~/.claude/CLAUDE.md` | Personal-home baseline | Always — every session, every project |
| `<repo-root>/CLAUDE.md` | Project repo-wide | When Claude Code is opened inside that repo |
| `<repo-root>/.claude/rules/<topic>.md` | Path-specific | When the current file matches the `paths:` frontmatter |

See [core/scope-layers.md](scope-layers.md) for full precedence rules.

---

## `@-import` Syntax

CLAUDE.md files can import other instruction files using the `@` syntax at the end of the file:

```markdown
@rules/routing.md
@rules/task-completion.md
@rules/test-contract.md
@rules/closeout.md
```

Imported files are resolved relative to the current `CLAUDE.md`'s location. The import syntax:
- Is placed at the end of the file
- Uses `@<relative-path>` (no quotes)
- Can import any number of files
- The imported file's content is injected as if it were written inline

The global `~/.claude/CLAUDE.md` uses this to keep the main file concise while sourcing detailed rule files from `~/.claude/rules/`.

---

## Recommended Sections

A well-structured CLAUDE.md contains these sections in order:

```markdown
# [Context / Project name]

[One-paragraph description of what this configuration governs.]

## Language Rules

[What language for code, comments, UI, docs. Default: English.]

## Agent Behavior

[Key behavioral rules: ask before scope assumptions, explain before implementing, etc.]

### Automation Defaults

[Whether routing is automatic or explicit. Composition rules.]

## Scope Layers & Precedence

[How local config adds to global baseline. Link to scope-layers.md.]

### Routing Matrix

[Domain → agent → skill mapping table.]

## Code Conventions

| Convention | Application |
|---|---|
| camelCase | variables, functions |
| PascalCase | classes, components |
| kebab-case | file names |

## Engineering Principles

[Design, quality, security, performance principles — brief list.]

## Never Do

[Hard prohibitions: no secrets in code, no commits without approval, etc.]

---
@rules/routing.md
@rules/task-completion.md
@rules/test-contract.md
@rules/closeout.md
```

---

## Annotated Example — Global `~/.claude/CLAUDE.md`

The actual global CLAUDE.md for this setup:

```markdown
# Global Instructions

Personal global instructions — apply to **all** sessions and projects.

## Language Rules
Everything is in **English** by default — communication, documentation, UI text,
comments, and code.
> Per-project language overrides are configured in the repo's CLAUDE.md.
> Code is always in English — variables, functions, classes, file names, inline comments.

## Memory — Obsidian Vault
Vault access: Obsidian Local REST API at https://127.0.0.1:27124
The vault serves as personal cross-project memory — not an activity log.
[Two-tier read gate: Tier 1 mandatory, Tier 2 lazy...]

## Mandatory Planning Protocol
Applies to every non-trivial task. Steps:
1. Create GitHub issue (gh issue create)
2. Invoke @principal to write execution plan
3. Execute with assigned agents

## Agent Behavior
- Simple and direct solutions before complex ones
- Ask before assuming scope
- Main session is sole orchestration layer

### Routing Matrix — Level 0 (Deterministic)
| Input Domain | Agent | Skill(s) |
|---|---|---|
| Architecture / Specs | @principal | spec-writing |
| Backend / DB | @engine | database-design |
| ...

## Code Conventions
| camelCase | variables, functions |
...

## Engineering Principles
Clean Code, SOLID, DRY, KISS, YAGNI...

## Never Do
- Hardcode secrets
- Implement with ambiguous scope
- Start non-trivial task without GitHub issue + plan
...

---
@rules/routing.md
@rules/task-completion.md
@rules/test-contract.md
@rules/closeout.md
```

---

## Creating a Project CLAUDE.md

Use the `/bootstrap-project` command to auto-generate a project CLAUDE.md:

```
/bootstrap-project
```

This triggers `@principal` to:
1. Scan the repo for manifest files (`package.json`, `Cargo.toml`, etc.)
2. Infer the stack, package manager, and toolchain
3. Create `CLAUDE.md` with the detected configuration

Alternatively, create it manually with this minimal template:

```markdown
# Project: <name>

<One sentence: what this repo is, for whom.>

## Stack

- Language: TypeScript / Node.js 20
- Package manager: bun
- Framework: Hono

## Commands

| Check | Command |
|---|---|
| lint | `bun run lint` |
| typecheck | `bun run typecheck` |
| format | `bun run format:check` |
| build | `bun run build` |
| tests | `bun run test` |

## Conventions

- All API routes under `src/routes/`
- DB queries only in `src/db/`
- No business logic in route handlers

## Never Do

- Direct DB access from route handlers
- Hardcode environment-specific URLs
```

---

## What Belongs in CLAUDE.md vs Other Files

| Content type | Where it goes |
|---|---|
| Global behavioral rules (always apply) | `~/.claude/CLAUDE.md` |
| Project-specific stack and commands | `<repo>/CLAUDE.md` |
| Domain procedural knowledge | `~/.claude/skills/<name>/SKILL.md` |
| File-type-specific conventions | `<repo>/.claude/rules/<topic>.md` (with `paths:`) |
| Agent behavior and identity | `~/.claude/agents/<name>.md` |
| Runtime tool wiring | `mcp.json`, `settings.json` |

---

## Rules

- Never duplicate global rules in project CLAUDE.md — they're always active
- Keep project CLAUDE.md strictly additive and project-scoped
- Use `@-imports` to keep the file short; detailed rules live in `rules/`
- The file is read at session start — changes take effect in the next session

---

## Related

- [core/scope-layers.md](scope-layers.md) — how layers stack and interact
- [agents/agent-format.md](../agents/agent-format.md) — agent `.md` file format
- [skills/skill-format.md](../skills/skill-format.md) — SKILL.md file format
- [rules/rules-overview.md](../rules/rules-overview.md) — path-specific rules
