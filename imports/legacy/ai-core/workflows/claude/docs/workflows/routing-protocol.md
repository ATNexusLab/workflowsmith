# Routing Protocol

The 8-step skill-first execution flow that determines how Claude Code routes every task — from fast-path local edits to multi-agent parallel execution.

---

## The 8-Step Flow

```
1. Local fast path
2. Project Documentation Gate
3. Preference Gate (Tier 1 — mandatory)
4. Context Gate (Tier 2 — lazy)
5. Build skill stack
6. Verbalize decisions
7. Invoke skills
8. Dispatch to agent
```

---

### Step 1 — Local Fast Path

**Question:** Is this a simple, local, history-independent task?

Fast-path criteria (all must be true):
- Single file, ≤ 3 lines changed
- No new file created
- No structural or architectural impact
- No domain-specific knowledge required

**If yes:** Execute directly. Skip steps 2–8.

**If no:** Continue to step 2.

---

### Step 2 — Project Documentation Gate

**Question:** Do project docs constrain this task?

Check (read minimum necessary):
- `README.md` — stack, conventions, commands
- `docs/`, `docs/decisions/`, `docs/adr/` — architectural constraints
- `CONTRIBUTING.md` — contribution conventions
- `docs/lessons.md`, migration docs — if relevant

Stop reading as soon as you have enough context. Only escalate to the vault for historical gaps after exhausting local docs.

---

### Step 3 — Preference Gate (Tier 1, Mandatory)

**For all non-trivial tasks:**

```
obsidian-get_note_content("knowledge/user-preferences.md")
```

This file accumulates all confirmed user preferences. It informs routing, code style, tool selection, and communication decisions.

**Skip only for:** trivial fast-path work (single-line edits, quick lookups, pure explanations).

---

### Step 4 — Context Gate (Tier 2, Lazy)

**After loading preferences**, check vault context only if one of these triggers applies:
- Local context + repo docs still insufficient after Tier 1
- Recurring work on a project with a history gap the repo doesn't explain
- Decision needs prior art or learned patterns not in the repo
- User explicitly says "remember what we did in X"

If none apply: skip Tier 2 entirely.

---

### Step 5 — Build Skill Stack

Identify applicable global skills from `~/.claude/skills/`:

| Domain | Global skill |
|---|---|
| Architecture / Specs | `spec-writing` |
| Backend / DB | `database-design` |
| Infra / Docker / Ops | `devops-patterns` |
| Security / Audit | `security-audit` |
| Test strategy, writing tests | `testing-patterns` |
| Test contracts (3 axes) | `testing-contract` |
| Refactoring | `refactoring` |
| Performance | `performance-analysis` |
| Technical documentation | `technical-writing` |
| UX / UI / Flows | `ux-specification` |
| Brand / Design system | `brand-identity` |
| Visual frontend (always composed) | `ux-specification` + `brand-identity` |
| API design | `api-design` |
| Growth / Conversion / Copy | `growth-marketing` |
| Mobile (RN, Flutter, Swift, Kotlin) | `mobile-patterns` |
| GitHub operations | `github-operations` |
| Web research | `web-research` |
| Memory access | `obsidian-memory` |
| Understanding unfamiliar code | `architecture-reading` |
| Creating CLAUDE.md / SKILL.md | `claude-instructions` |

Then add **local repo skills** from `skills/` if present. Local skills are additive by default — they narrow or extend the global skill, not replace it.

**Composition is normal.** A full-stack feature loads `database-design` + `api-design` + `ux-specification` + `brand-identity` + `testing-contract`.

---

### Step 6 — Verbalize Decisions

For non-trivial tasks, emit this block before any output:

```
Docs: checked <repo-relative paths> | skipped — <reason>
Memory: used <scope/reason> | skipped — <reason>
Skills: global=<comma list or none>; local=<comma list or none>
Route: main session | @engine | @creative | @principal | @engine + @creative
```

If this block is absent on a non-trivial task, the protocol was violated.

**Example:**
```
Docs: checked README.md, docs/decisions/
Memory: used knowledge/user-preferences.md
Skills: global=database-design, testing-contract; local=none
Route: @engine
```

---

### Step 7 — Invoke Skills

Call each skill via the `Skill` tool before generating any response:

```
Skill("database-design")
Skill("testing-contract")
```

Skills provide domain-specific procedural knowledge. They do not execute implementation — they brief Claude on how to approach the domain.

---

### Step 8 — Dispatch to Agent

The main session does not generate implementation code. Dispatch to the appropriate specialist:

| Agent | Domain |
|---|---|
| `@engine` | Backend, DB, infra, security, performance, testing, refactoring |
| `@creative` | UX/UI, frontend, brand, copy, mobile, technical writing |
| `@principal` | Architecture specs, ADRs, plans, project bootstrapping |

**Cross-domain tasks:** launch `@engine` + `@creative` in parallel when execution is divided:

```
Agent(@engine, "implement the API endpoints and DB schema")
Agent(@creative, "implement the frontend components and user flow")
```

**Main session exceptions** (execute directly without agent dispatch):
- Purely conversational or explanatory responses
- Searches, file reads, quick diagnostics
- Single-file change, ≤ 3 lines, no new file, no structural impact
- Orchestration tasks (routing between agents, assembling results)

---

## Routing Table Summary

| Input domain | Agent | Baseline skill(s) |
|---|---|---|
| Architecture / Specs | `@principal` | `spec-writing` |
| Backend / DB | `@engine` | `database-design` |
| Infra / Docker / Ops | `@engine` | `devops-patterns` |
| Security / Audit | `@engine` | `security-audit` |
| UX / UI / Copy / Mobile | `@creative` | `ux-specification` |
| Performance / Profiling | `@engine` | `performance-analysis` |
| Visual frontend (always) | `@creative` | `ux-specification` + `brand-identity` |

---

## Composition Examples

### Full-stack feature
```
Skills: global=database-design, api-design, ux-specification, brand-identity, testing-contract
Route: @engine + @creative (parallel)
@engine scope: DB schema, API endpoints, tests
@creative scope: UI components, user flows
```

### API with security review
```
Skills: global=api-design, security-audit, testing-contract
Route: @engine
```

### Technical documentation update
```
Skills: global=technical-writing
Route: @creative
```

### Architecture decision
```
Skills: global=spec-writing, architecture-reading
Route: @principal
```

---

## Anti-Patterns

- **Main session generates code:** violates the orchestration-only rule
- **Skipping verbalization:** no decision trail, protocol violated
- **Loading all skills for every task:** skill stack should match the actual domain
- **@principal orchestrating others:** @principal is for isolated planning only — it cannot spawn other agents
- **Tier 2 without a trigger:** lazy means actually lazy — don't load vault context just in case

---

## Related

- [rules/rules-catalog.md](../rules/rules-catalog.md) — `routing.md` global rule
- [agents/agent-roster.md](../agents/agent-roster.md) — agent capabilities and escalation
- [skills/skills-catalog.md](../skills/skills-catalog.md) — all 19 skills
- [workflows/planning-protocol.md](planning-protocol.md) — mandatory planning gate (step 0)
