# AxiomForge Architecture

This document describes the canonical architecture of AxiomForge — what it is, how it is organized, and why. It is written for a contributor who has no prior context. Every term is defined the first time it appears.

For the decisions that produced this architecture, see the [ADRs in `docs/decisions/`](decisions/README.md).

---

## Overview

AxiomForge is a **source-of-truth repository for AI excellence workflow instructions**. Its purpose is to keep the rules that govern AI agent behavior — routing policies, agent profiles, skills, checklists, and memory indexes — in a single versioned location, written in plain text, and auditable by any contributor.

The problem it solves: AI workflow instructions tend to exist in multiple places at once (inside tool-specific configuration files, inside personal dotfiles, inside project-local files) and diverge silently. AxiomForge is the one place where the canonical form of each instruction lives. A build step translates that canonical form into the format each tool expects.

---

## The Four Layers

AxiomForge is organized around four layers. Each layer has a single responsibility and a primary directory.

### 1. Schema Layer

**Responsibility:** Define what a canonical workflow unit must contain.  
**Primary directory:** `build/schema/`  
**Does NOT:** store workflow content, implement adapters, or run builds.

A **canonical workflow unit** is any piece of workflow instruction that has been authored in the canonical format. The schema defines its required and optional fields. See [ADR-001](decisions/ADR-001-canonical-schema.md) for the full field specification.

### 2. Content Layer

**Responsibility:** Store canonical workflow units in their lifecycle state.  
**Primary directories:** `core/`, `agents/`, `skills/`, `memory/`, `checklists/`  
**Does NOT:** contain harness-specific files, build artifacts, or raw unreviewed imports.

Content in this layer is always in one of three states: `draft`, `reviewed`, or `promoted`. Only `promoted` content is active policy. See [ADR-003](decisions/ADR-003-content-lifecycle.md) for transition criteria.

### 3. Build Layer

**Responsibility:** Translate canonical content into harness-specific output.  
**Primary directory:** `build/adapters/`  
**Does NOT:** store canonical content or execute at import time.

A **harness adapter** is a document that describes the mapping rules from canonical schema fields to a specific tool's native format (e.g., Copilot, Claude, Antigravity CLI). A build step reads canonical content + adapter rules and writes the harness-specific output as an ephemeral artifact. See [ADR-002](decisions/ADR-002-build-system-model.md).

No adapters are implemented yet. Adding one requires an ADR.

### 4. Validation Layer

**Responsibility:** Verify structural integrity of the repository.  
**Primary directory:** `scripts/`  
**Does NOT:** validate content meaning or enforce semantic correctness — only structure.

The primary validation script is `scripts/validate.sh`. It checks that required foundation files exist and are non-empty.

---

## Directory Contract

Every top-level directory has a defined purpose and an invariant — something that must always be true about its contents.

| Directory | Purpose | Invariant |
|---|---|---|
| `core/` | Baseline routing and output policy | All files are `promoted` canonical workflow units of `type: policy` |
| `agents/` | Agent profile definitions | All files are `promoted` canonical workflow units of `type: agent` |
| `skills/` | Task-specific skill instructions | All files are `promoted` canonical workflow units of `type: skill` |
| `memory/` | Versioned memory indexes and references | All files are `promoted` canonical workflow units of `type: memory-index` |
| `checklists/` | Reusable completion and review checklists | All files are `promoted` canonical workflow units of `type: checklist` |
| `docs/` | Explanatory documentation and ADRs | Human-readable reference; not loaded as active policy |
| `docs/decisions/` | Architecture Decision Records | One ADR per architectural decision; immutable once accepted |
| `build/` | Build system structure and adapter interface | No canonical content; no harness-specific artifacts committed here |
| `build/schema/` | Canonical schema templates and field specs | Schema definitions only; no workflow content |
| `build/adapters/` | One subdirectory per harness adapter | No adapters until an ADR authorizes one |
| `imports/` | Raw imported workflow material | Audit reference only; never active policy (see ADR-004) |
| `imports/extracted/` | Candidate extractions from raw imports | Pre-draft staging material; not canonical until converted to frontmatter-bearing workflow units |
| `scripts/` | Repository validation scripts | POSIX-compatible shell only; must exit 0 on a valid repo |

---

## Canonical Workflow Unit

A **canonical workflow unit** is a Markdown file with a YAML frontmatter block at the top. The frontmatter defines metadata that adapters read; the Markdown body contains the actual instruction content.

Example frontmatter:

```yaml
---
id: skill-spec-writing
type: skill
status: promoted
version: 1.0.0
tags:
  - planning
  - adr
see-also:
  - skill-architecture-reading
---
```

Required fields: `id`, `type`, `status`, `version`. Optional fields: `tags`, `replaces`, `see-also`.

See [ADR-001](decisions/ADR-001-canonical-schema.md) for the full field specification and allowed values. See `build/schema/workflow-unit.template.md` for the copyable template.

---

## Content Lifecycle

Content moves through three states before becoming active policy.

| State | Location | Meaning |
|---|---|---|
| `draft` | Feature branch or staging | Authored, not yet reviewed |
| `reviewed` | Feature branch, all findings resolved | Review completed, no blocking issues |
| `promoted` | `core/`, `agents/`, `skills/`, `memory/`, or `checklists/` | Active policy; traceable to an import or decision |

Transition from one state to the next requires explicit action — updating the `status` field in frontmatter and recording the decision. Content in `imports/legacy/` is pre-draft: it does not have canonical frontmatter and cannot skip the lifecycle.

See [ADR-003](decisions/ADR-003-content-lifecycle.md) for transition criteria.

---

## Build Model

The build model solves the multi-harness problem: one canonical workflow unit must work in several AI tools that read instructions in different formats.

```
AxiomForge canonical content   (this repository)
          ↓
  adapter for target harness   (build/adapters/<harness>/)
          ↓
  harness-specific artifact    (ephemeral, not committed here)
```

Adding a new harness means adding an adapter — not editing canonical content. Build artifacts are generated on demand and are not stored in this repository.

See [ADR-002](decisions/ADR-002-build-system-model.md) for the full model and constraints.

---

## What Belongs Here

- Shared routing rules (`core/`)
- Output contracts (`core/`)
- Agent profiles (`agents/`)
- Skills (`skills/`)
- Checklists (`checklists/`)
- Memory indexes (`memory/`)
- ADRs and explanatory documentation (`docs/`)
- Schema templates and adapter interface (`build/`)
- Repository validation scripts (`scripts/`)
- Raw import snapshots, as audit reference (`imports/`)

## What Does Not Belong Here

- Large multi-agent systems that cannot be audited quickly
- Tool-specific automation that only works in one harness (put it in the adapter, not in `core/`)
- Generated or build artifact files
- New workflow rules invented before existing imported sources are reviewed
- Secrets, credentials, or tool API keys

## Root Harness Files

The repository root contains harness-specific bootstrap files such as `AGENTS.md`. These files are read directly by the current active harness before the canonical content layer is loaded. They are not canonical workflow units — they do not have schema frontmatter and are not subject to the content lifecycle.

Root harness files are transitional artifacts. In a later phase, adapters will generate equivalent harness-specific files from canonical content, at which point these root files may be replaced or removed.

*For the original formulation of these boundaries, see `docs/ai-core-source-of-truth.md`.*
