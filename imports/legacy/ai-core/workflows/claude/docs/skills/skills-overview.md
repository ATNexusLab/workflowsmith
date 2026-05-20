# Skills — Overview

Skills are reusable markdown files that inject domain-specific procedural knowledge into a session. When invoked, a skill's content becomes active context — the current session (or agent) follows its steps, checklists, and conventions.

---

## What a Skill Is

A skill file (`SKILL.md`) defines:
- **When to use it** — the conditions under which this skill applies
- **What to do** — step-by-step workflow, checklists, and patterns
- **What not to do** — domain-specific anti-patterns

Skills are not agents. A skill does not execute in isolation — it provides procedural knowledge to whoever invoked it (the main session or an agent). The agent or session then applies that knowledge to the task.

---

## Global vs Local Skills

| Location | Scope |
|---|---|
| `~/.claude/skills/<name>/SKILL.md` | Global — available in every session, every project |
| `<repo>/skills/<name>/SKILL.md` | Project-local — active only inside that repo |

Local skills are **additive by default**. They add project-specific steps, constraints, or patterns on top of the matching global skill. A local `database-design` skill does not replace the global one — both are active, with the local adding project context.

A local skill replaces the global one only when the repo's `CLAUDE.md` explicitly says so.

---

## Invoking a Skill

Skills are invoked via the `Skill` tool in the main session:

```
Skill({ skill: "technical-writing" })
```

The routing protocol specifies which skills to load for which domains. For non-trivial tasks, the main session builds a skill stack before dispatching to an agent:

1. Identify which global skills apply to this domain
2. Invoke each relevant skill via the `Skill` tool
3. Dispatch to the appropriate agent with the skills already loaded

---

## Skill Routing

Skills are selected based on the domain of the task. The routing table in `~/.claude/rules/routing.md` maps domain → skill → agent. This routing is automatic for non-trivial tasks.

Examples:
- API design task → `api-design` skill → `@engine`
- Documentation task → `technical-writing` skill → `@creative`
- Visual UI work → `ux-specification` + `brand-identity` skills → `@creative`
- Security audit → `security-audit` skill → `@engine`

---

## Skill Composition

Multiple skills can be active simultaneously when a task spans multiple domains.

**Composed examples:**
- Full-stack feature: `database-design` + `api-design` + `ux-specification` + `testing-patterns`
- Visual UI implementation: `ux-specification` + `brand-identity` (this pair is the default for frontend work)
- Secure API: `api-design` + `security-audit` + `testing-contract`

Composition is the default when multiple concerns are active. Don't artificially reduce a multi-domain task to a single skill.

---

## Skill vs CLAUDE.md vs Agent

Knowing what belongs where prevents duplication:

| Content type | Where it goes |
|---|---|
| Behavioral rules for all sessions (always apply) | `CLAUDE.md` |
| Domain procedural knowledge (steps, checklists, patterns) | `SKILL.md` |
| Agent identity, operating stance, and escalation | `agents/<name>.md` |
| Project-specific conventions that narrow a skill | `<repo>/skills/<name>/SKILL.md` |
| File-type-specific rules | `.claude/rules/<topic>.md` with `paths:` |

**The rule:** if it's "how to think about X" or "steps to take when doing X" — it's a skill. If it's "always do Y regardless of task" — it's CLAUDE.md. If it's "this agent approaches problems this way" — it's an agent file.

---

## Building Skills with Subdirectories

Skills can have sub-files for supporting material:

```
skills/spec-writing/
├── SKILL.md          ← main skill file (required)
├── patterns/
│   └── common-patterns.md
└── references/
    ├── adr-template.md
    ├── arch-notes-template.md
    └── tech-spec-template.md
```

The `SKILL.md` can reference these files with relative paths or the skill content can instruct the model to read them for specific templates.

---

## Validation Checklist

Before publishing a skill:
- [ ] `when_to_use` field is specific enough for automatic routing
- [ ] Body has: When to Use → Steps → Examples → Validation Checklist → Never Do
- [ ] Contains at least one concrete example
- [ ] Does not duplicate rules from CLAUDE.md
- [ ] Does not contain agent-level behavior (escalation, identity)
- [ ] Steps are actionable — a developer can follow them without other resources

---

## Related

- [skills/skill-format.md](skill-format.md) — SKILL.md frontmatter and body structure
- [skills/skills-catalog.md](skills-catalog.md) — all 19 global skills
- [workflows/routing-protocol.md](../workflows/routing-protocol.md) — how skills are selected and composed
- [agents/agents-overview.md](../agents/agents-overview.md) — how agents use skills
