---
name: copilot-instructions
description: Use to create or update copilot-instructions.md, SKILL.md, .agent.md, and .instructions.md files with the correct scope, frontmatter, and usage rules.
user-invocable: true
disable-model-invocation: false
triggers:
  - "create or update copilot-instructions.md"
  - "create or update SKILL.md or .agent.md"
  - "configure path-specific instructions (.instructions.md)"
license: MIT
---

# Copilot Instructions

## When to Use

- Create or update a repository `.github/copilot-instructions.md`
- Create or update a reusable `SKILL.md`
- Create or update a specialized `.agent.md`
- Configure file-path-specific instructions with `.instructions.md`
- Audit instruction files for scope, frontmatter, duplication, or language drift

## Core Principle

Instruction files are reusable contract surfaces, not ad-hoc prompts. Keep durable framework guidance in skills, agent-specific execution stance in `.agent.md`, repository-wide policy in `copilot-instructions.md`, and file-scoped exceptions in `.instructions.md`.

Scope layers are cumulative by default: personal-home instructions and global skills form the
baseline, then repository-wide instructions, path-specific instructions, and repo-local skills add
specialization or constraints. A repo-local skill does **not** replace the matching global skill
unless the repository contract explicitly says so.

## Instruction Surfaces in the Copilot Ecosystem

| Type | File | Scope |
|------|------|-------|
| Global | `~/.copilot/copilot-instructions.md` | All user sessions in this environment |
| Repository | `.github/copilot-instructions.md` | The entire repository |
| Path-specific | `.github/instructions/*.instructions.md` with `applyTo` in frontmatter | Matching files only |
| Skill | `skills/<name>/SKILL.md` | Reusable domain guidance loaded on demand |
| Agent | `agents/<name>.agent.md` | Isolated agent context when the runtime supports it |

## Language and Scope Rules

- Follow the active repository instruction contract first.
- In this repository, all repository-owned instruction surfaces are written in **English**: `copilot-instructions.md`, `.instructions.md`, `SKILL.md`, and `.agent.md`.
- When touching a legacy mixed-language instruction file, migrate it fully instead of extending mixed-language content.
- Commands, file paths, identifiers, and code examples stay in English unless a repository contract explicitly says otherwise.
- Keep examples CLI-first and repo-relative. Do not drift into VS Code-specific workflow unless the
  file is intentionally runtime-bound to that environment.

## Context Gates and Skill Composition

- Check repository docs when they can materially change the instruction contract, examples, or
  workflow. Keep this cheap: read the minimum set of repo-local files needed.
- Consider `obsidian-memory` only if repo docs still leave a real historical gap. For trivial
  instruction edits, skip memory silently.
- Start from the relevant global baseline skill(s), then add repo-local skills or path-specific
  instructions that narrow the work.
- Load multiple skills when the instruction task spans multiple concerns. For example,
  `copilot-instructions` + `architecture-reading` is normal when you must understand an existing
  repo contract before updating the instruction surfaces.
- When docs, memory, skills, or routing were genuinely part of the decision, keep that trail
  inspectable with the compact observability note:

```text
Docs: checked <repo-relative paths> | skipped — <reason>
Memory: used <scope/reason> | skipped — <reason>
Skills: global=<comma list or none>; local=<comma list or none>
Route: main session | @engine | @creative | @principal | @engine + @creative
```

Skip the note for trivial fast-path edits where those gates were never meaningfully in play.

## Format: `copilot-instructions.md`

A repository-wide instruction file should define:

```markdown
# [Project Name] — Copilot Instructions

## Context
[What the project is, the primary stack, and response language expectations]

## Conventions
[Code conventions, naming, mandatory patterns]

## Response Protocol
[How the agent should work — steps, approvals, logging]

## Agent Roster
[Available agents and when to use each]

## Never Do
[Explicit anti-patterns for this repository]
```

## Format: `SKILL.md`

A skill holds reusable procedural knowledge. Minimum required frontmatter:

```yaml
---
name: skill-name
description: One precise sentence describing when to use the skill.
license: MIT
---
```

Optional fields depend on the runtime. Add runtime-specific metadata only when the file is intentionally bound to that runtime.

A `SKILL.md` body should contain:
- **When to Use** — precise triggers
- **Workflow or Checklist** — executable steps
- **Examples or Templates** — concrete patterns, not theory only
- **Validation Checklist** — how to confirm the skill output is complete
- **Never Do** — explicit anti-patterns when the domain needs them

Skills stay canonical and reusable. Do not turn them into agent wrappers or copies of repository-wide policy.

## Format: `.agent.md`

An agent file defines an isolated persona with its own workflow. Required frontmatter:

```yaml
---
name: agent-name
description: [Persona]. Use when [precise trigger].
tools: ["read", "search", "edit"]
---
```

Critical rules for `.agent.md`:
- **Clear and sufficient** — persona, limits, workflow, escalation, and exit criteria must be explicit
- **Thin wrapper when a canonical skill exists** — reference the skill and add only agent-specific behavior
- **Minimal tools** — list only the tools the agent actually needs
- **No editor assumptions** — do not assume VS Code panels, commands, or editor-only affordances unless the file is intentionally runtime-bound
- **Strong perspective** — the agent should have a clear role and decision lens

A `.agent.md` body should contain:
- Identity and role
- Discovery questions (if applicable)
- Step-by-step workflow
- Escalation protocol
- Never-do rules

## Format: Path-Specific Instructions

```yaml
---
applyTo: "**/*.test.ts"
---

# Instructions for TypeScript test files

[Conventions specific to this file class]
```

## Repository-Specific Ecosystem Rules

When editing this repository's own instruction ecosystem:
- Exactly **3 agents** are valid: `@engine`, `@creative`, and `@principal`
- The main session is the only orchestrator
- Do not invent or document ghost agents such as `Strategist` or `@orchestrator`

## When to Use Each Type

| Scenario | Instruction type |
|----------|------------------|
| Repository-wide conventions | `copilot-instructions.md` |
| Rules for a specific file class | Path-specific `.instructions.md` |
| Reusable domain knowledge | `SKILL.md` |
| Persona with a complete workflow | `.agent.md` |

## Quality Checklist

For any instruction file you create or edit:
- [ ] Frontmatter includes `name` and `description`
- [ ] Content language follows the active repository contract (English in this repository)
- [ ] No TODOs or empty placeholders remain
- [ ] Instructions are executable, not just conceptual
- [ ] Content does not duplicate another instruction surface unnecessarily
- [ ] Runtime-specific metadata appears only when intentionally required
- [ ] Mark the file as experimental only when it is genuinely unvalidated
- [ ] Global vs local skill layering is described as baseline + additive unless the repo contract explicitly overrides it
- [ ] Multi-skill composition remains allowed when relevant
- [ ] Observability wording is visible when material and omitted when trivial
- [ ] Examples stay CLI-first instead of assuming editor-only affordances

## Workflow

### 1. Identify the instruction scope

Decide where the instruction belongs:
- Affects the whole repository → `.github/copilot-instructions.md`
- Affects a specific file class or path → `.instructions.md`
- Defines reusable domain guidance → `SKILL.md`
- Defines a persona with execution stance → `.agent.md`

### 2. Determine the governing contract and language

Read the relevant repository instructions before editing. Confirm the required language, valid agent roster, and any path-specific constraints.

If project docs, ADRs, usage guides, or local instruction files can constrain the change, read the
minimum set and keep the decision explainable. Only escalate to `obsidian-memory` if those local
docs still leave a genuine historical gap.

### 3. Write the YAML frontmatter

Use the matching format above. `name` and `description` are the minimum required fields.

### 4. Structure the body intentionally

For **skills**:
1. When to Use
2. Workflow / Procedure
3. Examples or Templates
4. Validation Checklist
5. Never Do (when needed)

For **agents**:
1. Persona
2. Methodology
3. Escalation Protocol
4. Workflow
5. Never Do

### 5. Validate thin-wrapper boundaries

- Keep reusable procedures in the skill, not in the agent wrapper
- Keep repo-wide policy in `copilot-instructions.md`, not duplicated across every skill
- Keep path-specific rules in `.instructions.md`
- Keep global skills as the baseline layer and describe repo-local skills as additive unless the
  repository contract explicitly defines an override
- Allow multi-skill composition when the task genuinely spans multiple concerns; do not force a
  one-skill-only model into the wording

### 6. Place the file in the correct location

```bash
# In this repository:
agents/name.agent.md
skills/name/SKILL.md
```

## Never Do

- Do not teach a language policy that conflicts with the active repository contract
- Do not duplicate a skill verbatim inside an agent wrapper
- Do not split one policy across multiple conflicting instruction files
- Do not add runtime-specific metadata or editor assumptions without a clear reason
- Do not invent unsupported agents in this repository

## Examples

### Minimal valid `SKILL.md`

```markdown
---
name: my-skill
description: Use when you need [usage context]. Provides [what it delivers].
license: MIT
---

# My Skill

## When to Use

- Situation A that justifies the skill
- Situation B that justifies the skill

## Steps

### 1. First step
Actionable description.

### 2. Second step
Actionable description.

## Validation Checklist

- [ ] Criterion 1
- [ ] Criterion 2
```

### Minimal valid `.agent.md`

```markdown
---
name: my-agent
description: Agent role. Use when you need [context].
tools: ["read", "search", "edit", "todo"]
user-invocable: true
---

# My Agent

## Persona

[1-3 lines describing the persona and its central principle]

## Methodology

[Domain-specific operating sections]

## Escalation Protocol

[When and how to escalate]

## Workflow

[Numbered steps]

## Never Do

[Explicit prohibitions]
```

If the file is deliberately runtime-bound, add only the runtime-specific metadata that is actually required.
