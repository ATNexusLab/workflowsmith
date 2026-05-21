# Build System

This directory contains the WorkflowSmith build system structure: schema definitions and the harness adapter interface.

## What the Build System Does

WorkflowSmith stores workflow instructions in a canonical format — one copy per workflow unit, harness-agnostic. The build system translates that canonical content into the format each target harness expects.

```
canonical content (this repository)
        ↓
adapter rules for a target harness
        ↓
harness-specific build artifact (not committed here)
```

See [ADR-002](../docs/decisions/ADR-002-build-system-model.md) for the full decision and constraints.

## Directory Structure

| Directory | Purpose |
|---|---|
| `schema/` | Canonical schema definitions and the workflow unit template |
| `adapters/` | One subdirectory per harness adapter (none yet) |

## Current Status

**Phase 1 — Structure only.** No adapters are implemented. No build runner exists. This directory establishes the interface so that Phase 2 work has a stable foundation to build on.

Adding an adapter requires:
1. An ADR documenting the adapter design for that harness.
2. A subdirectory in `build/adapters/<harness-name>/`.
3. A `README.md` in that subdirectory describing the mapping rules.

## Build Artifacts

Build artifacts are **not committed to this repository**. They are generated on demand in the target harness environment. If a `.gitignore` rule is needed to prevent accidental commits of generated output, add it before running a build.
