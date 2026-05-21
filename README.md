# WorkflowSmith

WorkflowSmith is a source-of-truth repository for AI workflow instructions.

The repository is intentionally small. It exists to make AI operating rules, agents, skills, memory references, and checklists auditable and versioned before they are reused across tools.

## Purpose

- Keep core AI workflow policy in plain text.
- Prepare imports from Copilot, Claude, and Antigravity CLI.
- Separate raw imported material from promoted repository standards.
- Avoid inventing final workflows before existing workflows are reviewed.

## Requirements

See [`docs/specs/requirements.md`](docs/specs/requirements.md) for the draft v1 requirements: product scope, harness targets, canonical workflow expectations, distribution model, safety requirements, and v1 acceptance criteria.

## Architecture

See [`docs/architecture.md`](docs/architecture.md) for the full description of WorkflowSmith's four-layer model (Schema, Content, Build, Validation), the directory contract, the content lifecycle, and the build system design.

## Repository Map

- `docs/` — explanatory documentation, ADRs, and the architecture reference.
- `docs/decisions/` — Architecture Decision Records (ADRs) for every key architectural choice.
- `core/` — baseline routing and output policy.
- `agents/` — agent profile definitions.
- `skills/` — task-specific skill instructions.
- `memory/` — versioned memory indexes and references.
- `checklists/` — reusable completion and review checklists.
- `build/` — canonical schema templates and harness adapter interface.
- `imports/` — raw imported workflow material (audit reference only, never active policy).
- `scripts/` — lightweight repository validation checks.

## Operating Principles

1. Import first, normalize second, promote last.
2. Preserve original workflow intent during imports.
3. Prefer one clear rule over several overlapping rules.
4. Keep automation small enough to audit quickly.
5. Version every promoted workflow change.
6. Document every architectural decision as an ADR in `docs/decisions/`.

## Decision Records

| ADR | Title |
|---|---|
| [ADR-001](docs/decisions/ADR-001-canonical-schema.md) | Canonical Schema Definition — required frontmatter fields for every workflow unit |
| [ADR-002](docs/decisions/ADR-002-build-system-model.md) | Build System Model — canonical source + adapter per harness + ephemeral build artifact |
| [ADR-003](docs/decisions/ADR-003-content-lifecycle.md) | Content Lifecycle — draft → reviewed → promoted with explicit transition criteria |
| [ADR-004](docs/decisions/ADR-004-legacy-treatment.md) | Legacy Treatment — `imports/legacy/` is audit reference only, never active policy |
| [ADR-005](docs/decisions/ADR-005-versioning-strategy.md) | Versioning Strategy — unit semver, schema versioning, and repository release model |

## Validation

Run:

```sh
sh scripts/validate.sh
```

The validator checks that the required foundation files and raw legacy import markers exist and are non-empty. It can be run from any directory.

## Imported Legacy Snapshot

The first raw import is stored at `imports/legacy/ai-core/`.

It contains inactive reference snapshots for Copilot, Claude, and Antigravity CLI from `/home/theoodawara/Projetos/AI-core/workflows`. Nothing in that import is promoted into active policy until a later review step moves selected content into `core/`, `agents/`, `skills/`, `memory/`, or `checklists/`.

## Next Import Step

Audit one imported workflow at a time. Start by comparing the imported routing and closeout rules, then promote only the smallest shared rule that is clear, reusable, and traceable to the raw import.
