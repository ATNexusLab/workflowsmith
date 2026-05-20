---
name: gemini-instructions
description: Use to create or update GEMINI.md, common/ files, agents/*.md, and skills/*/SKILL.md for the modular Gemini CLI, validating scope, frontmatter, and explicit loading.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# Gemini Instructions

## When to Use

- Create or update the modular configuration in `~/.gemini/`
- Migrate monolithic instructions to the layered architecture (`GEMINI.md` / `common/` / `agents/` / `skills/`)
- Audit frontmatter, duplication, explicit loading, and sub-agent isolation
- Create new agents, skills, or shared fragments without breaking the single canonical source rule
- Review whether an instruction belongs in the correct layer before editing

## Modular Architecture — Overview

The Gemini CLI configuration is organized into **4 layers with distinct responsibilities**:

| Layer | Location | Responsibility | What it should contain |
|---|---|---|---|
| **Global surface** | `~/.gemini/GEMINI.md` | Minimal global context | routing, persona, language rules, agent roster, genuinely cross-cutting global principles |
| **Shared protocols** | `~/.gemini/common/*.md` | Canonical protocols reused by multiple agents/skills | test contract, closeout, task completion, engineering principles |
| **Agents** | `~/.gemini/agents/*.md` | Isolated sub-agent context | persona, workflow, boundaries, escalation, and **explicit loading** of required dependencies |
| **Skills** | `~/.gemini/skills/*/SKILL.md` | Reusable procedural playbooks | when to use, workflow, examples, validation checklist |

**Architecture goal:** keep `GEMINI.md` thin, move shared protocols to `common/`, and make agents and skills load dependencies explicitly instead of duplicating content.

## When to Use Each Layer

| If the instruction answers... | Put it in... | Practical rule |
|---|---|---|
| "How does the main session route, speak, and decide language?" | `GEMINI.md` | Global surface — lean and stable |
| "Is this protocol/checklist used by more than one agent or skill?" | `common/` | Single canonical source |
| "Does a sub-agent need to act independently from a cold start?" | `agents/` | The agent file must be self-contained |
| "Is this knowledge a reusable on-demand playbook?" | `skills/` | Reusable procedure, not global policy |

### Quick Decision Rule

- **Global routing, base persona, language, roster** → `GEMINI.md`
- **Shared protocols** → `common/`
- **Agent behavior and operational stance** → `agents/`
- **Reusable procedural knowledge** → `skills/`

## Critical Gemini CLI Rules

### 1. `@import` — Static Composition Between Files

Use `@import` when you want to **statically compose shared content** within an instruction file.

Syntax:

```md
@./common/test-contract.md
@/home/theo/.gemini/common/closeout-protocol.md
```

Rules:

- The `@import` directive must appear **alone on its line**
- Supports both **relative** and **absolute** paths
- Maximum depth: **5 levels** of nesting
- **Ignored inside fenced code blocks**
- Use for static composition; for runtime operational loading, prefer `read_file`

**When to use:** consolidate static surfaces without copying content.
**When not to use:** for depending on a skill or fragment that needs to be explicitly loaded by an agent at runtime.

### 2. Skill Loading — Two Equivalent Forms

There are **two valid ways** to load a skill:

1. `activate_skill` — **preferred in the main session**
2. `read_file ~/.gemini/skills/{name}/SKILL.md` — **explicit and required in sub-agents** when inference is less reliable

Examples:

```text
activate_skill testing-contract
read_file ~/.gemini/skills/testing-contract/SKILL.md
```

Rules:

- Referencing the skill in text only **has no effect**
- In sub-agents, treat `read_file` as the safe default path
- If an agent depends on a skill to execute correctly, the agent file itself must state **when and how to load it**

### 3. Loading Fragments from `common/`

Files in `common/` are the canonical source for shared protocols. They can be used in two ways:

- **Static composition** with `@import`
- **Explicit loading** with `read_file ~/.gemini/common/<fragment>.md`

Use `read_file` when the agent needs to load the protocol as an operational dependency; use `@import` when the goal is only to compose a textual surface.

### 4. Sub-Agent Context Isolation (**CRITICAL**)

> **Sub-agents invoked via `@agent` do not inherit the main session's `GEMINI.md`.**

Mandatory implications:

- Every agent in `agents/*.md` must work from a **cold start**
- Do not rely on implicit context, previously activated skills, or rules "already known" by the main session
- The agent must bring its own persona, workflow, boundaries, and loading instructions
- If the agent needs `spec-writing`, `testing-contract`, or fragments from `common/`, this must be explicit in the agent file

**Golden rule:** each agent must be **self-contained**. If the agent file is read in isolation, it must still work correctly.

### 5. Protection Against Sub-Agent Recursion

Sub-agents **cannot invoke other sub-agents**. Only the main session orchestrates.

Therefore:

- `@principal`, `@engine`, and `@creative` execute their own scope
- If an agent needs another domain, it returns the result to the main session
- Never document chains like "`@engine` calls `@creative`" inside agent files

## Anti-Duplication Rule

Each protocol must have **a single canonical source**.

| Content | Canonical source |
|---|---|
| 3-axis test contract | `~/.gemini/common/test-contract.md` |
| 9-item closeout checklist | `~/.gemini/common/closeout-protocol.md` |
| 5-check completion protocol | `~/.gemini/common/task-completion.md` |
| Code conventions + engineering principles | `~/.gemini/common/engineering-principles.md` |

Rules:

- **Agents load from `common/`; they do not copy**
- **Skills point to `common/` when content is already canonical there**
- `GEMINI.md` must not become a monolithic file again with duplicated tables
- If a protocol changed, update the **canonical source** and adjust loading points — do not replicate the patch across multiple files

Correct example:

- `skills/testing-contract/SKILL.md` explains **when to use** the contract and points to `common/test-contract.md`
- `agents/engine.md` loads `read_file ~/.gemini/common/test-contract.md` when entering implementation/testing mode

## Recommended Pattern by File Type

### `GEMINI.md`

`GEMINI.md` must be the **minimal global surface**. It is not the place for long protocols.

It should primarily contain:

- global routing rules
- base persona
- language rules
- agent roster
- genuinely cross-cutting global principles

Avoid placing in `GEMINI.md`:

- complete OWASP tables
- extensive closeout checklists
- operational protocols that already live in `common/`

### `agents/*.md`

Each agent must be **self-sufficient** and explicitly declare how it loads its dependencies.

A good agent:

- explains its role and boundaries
- defines workflow and exit criteria
- indicates which skills to load (`activate_skill` or `read_file`)
- indicates which fragments in `common/` it needs to load
- never assumes inheritance of context from the main session

### `skills/*/SKILL.md`

Skills are reusable playbooks. They **do not replace** agents, and must not become dumps of global policy.

A good skill:

- explains **when to use**
- provides the procedure
- points to the canonical source in `common/` when one exists
- avoids duplicating agent persona or global policy

## Frontmatter — Mandatory Validation

### Valid Fields

Use only documented Gemini CLI fields:

- `name`
- `description`
- `kind`
- `tools` (`string[]`)
- `mcpServers`
- `model`
- `temperature`
- `max_turns`
- `timeout_mins`

### Prohibited or Invalid Fields

- `version`
- `memory`
- any field outside the valid list above

### Additional Rules

- `tools` must list only valid names that are actually used
- **`grep`** is the correct name — not `grep_search`
- **`fetch`** is the correct name — not `web_fetch`
- **`save_memory` is not a valid tool** and must not appear in frontmatter
- Use the smallest possible set of fields; do not add ornamental metadata

### Valid Example — Skill

```yaml
---
name: testing-contract
description: Use before implementing or reviewing tests with the 3-axis contract.
kind: skill
---
```

### Valid Example — Agent

```yaml
---
name: engine
description: System Architect. Use for backend, data, infra, security, performance, and git.
tools: ["read_file", "grep", "glob", "replace", "run_shell_command", "fetch"]
max_turns: 12
timeout_mins: 20
---
```

## Workflow for Creating or Updating Instructions

### 1. Identify the Correct Layer

Before editing, decide whether the change belongs in `GEMINI.md`, `common/`, `agents/`, or `skills/`.

### 2. Verify Whether a Canonical Source Already Exists

If the content already exists in `common/`, **do not duplicate it**. Update the canonical source or only the loading point.

### 3. Define the Loading Strategy

Consciously choose between:

- `@import` for static composition
- `activate_skill` for skill loading in the main session
- `read_file` for explicit skill loading or for loading fragments from `common/`

### 4. Validate Agent Self-Containment

For any file in `agents/`, confirm:

- it works without inheriting `GEMINI.md`
- it does not depend on a child sub-agent
- it knows how to load its skills/fragments
- it does not delegate orchestration to another agent

### 5. Validate the Frontmatter

Confirm:

- only valid fields are present
- tool names are correct
- no `version`, `memory`, `grep_search`, `web_fetch`, or `save_memory` exist

### 6. Review Duplication and Drift

Verify that the edit:

- keeps `GEMINI.md` slim
- keeps `common/` as the single source for shared protocols
- avoids copying skill workflow into an agent without necessity
- avoids language drift and unnecessary metadata

## Checklist — New Agent or Skill

### For a New `agents/*.md`

- [ ] The scope genuinely belongs to an agent, not a skill or fragment in `common/`
- [ ] The agent works from a cold start
- [ ] The agent does not depend on inherited `GEMINI.md`
- [ ] The agent does not attempt to invoke another sub-agent
- [ ] Dependencies are loaded explicitly with `read_file` or `activate_skill`
- [ ] Frontmatter uses only valid fields
- [ ] Tools use correct names (`grep`, `fetch`) and do not include `save_memory`

### For a New `skills/*/SKILL.md`

- [ ] The skill is a reusable playbook, not an agent wrapper
- [ ] The skill does not duplicate a protocol already canonized in `common/`
- [ ] The body explains when to use, workflow, and validation
- [ ] Frontmatter uses only valid fields
- [ ] If a canonical source exists in `common/`, the skill points to it

### For a New Fragment in `common/`

- [ ] The content is genuinely shared by multiple agents/skills
- [ ] A single canonical file exists for the protocol
- [ ] Consumers load the fragment via `@import` or `read_file` instead of copying

## Optional Extension — Path-Specific Instructions in Repositories

In project repositories, `.instructions.md` remains valid for path-based rules. It **is not part of the central `~/.gemini/` architecture**, but follows the same discipline: correct scope, no duplication, and no invalid frontmatter.

Example:

```yaml
---
applyTo: "**/*.test.ts"
---

# Instructions for TypeScript Tests

[Conventions specific to this file class]
```

## Never Do

- Do not turn `GEMINI.md` into a monolith again
- Do not duplicate shared protocols outside of `common/`
- Do not document agents as if they inherit context from the main session
- Do not rely on a textual skill reference without `activate_skill` or `read_file`
- Do not invent chaining between sub-agents
- Do not use `grep_search`, `web_fetch`, or `save_memory` in frontmatter
- Do not add `version`, `memory`, or other fields outside the valid list

## Operational Summary

When in doubt about where something belongs:

1. **Global routing/persona/language/roster?** → `GEMINI.md`
2. **Shared protocol?** → `common/`
3. **Self-sufficient sub-agent behavior?** → `agents/`
4. **Reusable playbook?** → `skills/`

When in doubt about loading:

1. **Main session + skill** → `activate_skill`
2. **Sub-agent + skill** → `read_file ~/.gemini/skills/{name}/SKILL.md`
3. **Shared fragment** → `read_file ~/.gemini/common/<fragment>.md` or `@import`

When in doubt about duplication:

- Choose **a single canonical source in `common/`** and have consumers load from it.
