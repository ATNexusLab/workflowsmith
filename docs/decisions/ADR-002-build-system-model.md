# ADR-002: Build System Model

**Status:** Accepted

## Context

AxiomForge content must work in at least three harnesses — Copilot, Claude, and Antigravity CLI — that have different instruction file formats, loading mechanisms, and directory expectations. For example:

- Copilot loads instructions from `.github/copilot-instructions.md` and skill files from specific locations.
- Claude loads from `CLAUDE.md` and `~/.claude/` directories.
- Antigravity CLI has its own hook-based configuration model.

Maintaining three separately edited copies of the same workflow content produces drift. After any update to a rule or skill, the author would need to manually propagate the change to all three harness-specific files — and verify that nothing was missed or paraphrased incorrectly.

## Decision

One canonical copy per workflow unit, stored in AxiomForge. Each target harness gets a **pattern adapter** — a document that describes the mapping rules from canonical schema fields to that harness's native format. A build step reads canonical content plus the relevant adapter rules and writes the harness-specific output.

```
AxiomForge canonical content
        ↓
  [adapter: rules for target harness]
        ↓
  harness-specific build artifact
```

Key constraints:

- Build artifacts are **ephemeral** — they are not committed to this repository. They live in the target harness environment.
- Each harness adapter lives in `build/adapters/<harness-name>/`.
- Adding support for a new harness requires writing an adapter and an ADR — not modifying canonical content.
- The build step is run from within the current active harness (the one available at build time) to produce output for the target harness.

Phase 1 establishes the `build/` directory structure and documents the adapter interface. No adapters or build runners are implemented until Phase 2 or later.

## Consequences

- Content authors write once. Adapter authors maintain the translation rules for their harness.
- Harness-specific format changes require only adapter updates, not canonical content edits.
- The `build/` directory is a first-class part of the repository structure, documented in `docs/architecture.md`.
- Build artifacts must not be committed here — `.gitignore` or equivalent should exclude any generated output directory.
- A new harness requires an ADR before its adapter is created, ensuring the decision is intentional and traceable.
