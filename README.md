# AxiomForge

AxiomForge is a source-of-truth repository for AI workflow instructions.

The repository is intentionally small. It exists to make AI operating rules, agents, skills, memory references, and checklists auditable and versioned before they are reused across tools.

## Purpose

- Keep core AI workflow policy in plain text.
- Prepare imports from Copilot, Claude, and Antigravity CLI.
- Separate raw imported material from promoted repository standards.
- Avoid inventing final workflows before existing workflows are reviewed.

## Repository Map

- `docs/` explains the source-of-truth model.
- `core/` stores baseline routing and output policy.
- `memory/` indexes versioned memory sources.
- `agents/` stores agent definitions.
- `skills/` stores task-specific skills.
- `checklists/` stores repeatable review checklists.
- `imports/` stores raw imported workflow material before promotion.
- `scripts/` stores lightweight repository checks.

## Operating Principles

1. Import first, normalize second, promote last.
2. Preserve original workflow intent during imports.
3. Prefer one clear rule over several overlapping rules.
4. Keep automation small enough to audit quickly.
5. Version every promoted workflow change.

## Validation

Run:

```sh
sh scripts/validate.sh
```

The validator checks that the required foundation files and raw legacy import markers exist and are non-empty.

## Imported Legacy Snapshot

The first raw import is stored at `imports/legacy/ai-core/`.

It contains inactive reference snapshots for Copilot, Claude, and Antigravity CLI from `/home/theoodawara/Projetos/AI-core/workflows`. Nothing in that import is promoted into active policy until a later review step moves selected content into `core/`, `agents/`, `skills/`, `memory/`, or `checklists/`.

## Next Import Step

Audit one imported workflow at a time. Start by comparing the imported routing and closeout rules, then promote only the smallest shared rule that is clear, reusable, and traceable to the raw import.
