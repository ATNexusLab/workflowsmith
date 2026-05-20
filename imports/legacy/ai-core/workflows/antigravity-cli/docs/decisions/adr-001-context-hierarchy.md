<!-- type: adr | section: decisions -->
# ADR-001: Context Hierarchy: 3-Tier GEMINI.md System

**Status:** Accepted  
**Date:** 2025

## Context

Gemini CLI is a terminal-first agent environment that injects repository and user instructions into model interactions. Those instructions define conventions, execution rules, and project context that shape every response.

A single global instruction file is insufficient. Personal defaults need to follow the user across all repositories, while each repository also needs local constraints such as language rules, workflows, and architecture conventions. In larger repositories and monorepos, subdirectories may need additional specialization without forcing duplicate configuration at the workspace root.

For this ADR, a **tier** is one layer of instruction loading, and **JIT subdirectory loading** means dynamically discovering extra instruction files based on the current working directory at runtime.

The architecture therefore needs a context system that is portable, composable, and location-aware.

## Decision

Gemini CLI uses a three-tier hierarchical instruction model based on `GEMINI.md` files.

1. **Global tier**: `~/.gemini/GEMINI.md`
   - Personal baseline instructions.
   - Loaded in every session regardless of repository.
2. **Workspace tier**: `./GEMINI.md` at the project root.
   - Repository-specific instructions.
   - Extends or narrows the global baseline for that workspace.
3. **JIT subdirectory tier**: any `GEMINI.md` found on ancestor paths between the current working directory and the workspace root.
   - Loaded dynamically when the CLI is started from a nested directory.
   - Supports localized specialization inside monorepos or deep module trees.

The loading model is **additive, not replacing**. Lower tiers do not discard higher tiers; they extend them. A session may therefore contain global, workspace, and one or more JIT-discovered subdirectory instruction files at the same time.

Instruction files may be composed with `@import` syntax. Imports are resolved with a maximum depth of 5 and must detect circular references so that an instruction graph cannot recurse indefinitely.

Upward traversal is bounded by `memoryBoundaryMarkers`, which default to `['.git']`. These markers define where upward discovery stops, preventing accidental leakage across unrelated directories.

The instruction filename is configurable through `context.fileName`. The default is `GEMINI.md`, but the system may be configured to recognize alternative names such as `AGENTS.md`, `CONTEXT.md`, or an array of allowed filenames.

Subagents are explicitly outside this inheritance chain. They start with fresh context and do not automatically inherit the parent session's loaded `GEMINI.md` files.

## Consequences

- ✅ Personal conventions apply automatically in every session without extra flags or setup.
- ✅ Repositories can define local behavior without mutating the user's global baseline.
- ✅ Nested modules in monorepos can attach specialized instructions through JIT subdirectory discovery.
- ✅ Modular composition via `@import` allows instruction reuse without copying large blocks of text.
- ⚠️ Every loaded tier consumes context window space, so instruction files must stay concise and intentional.
- ⚠️ Debugging unexpected behavior may require checking all active tiers, not just the repository root.
- ⚠️ Because subagents start fresh, any critical parent instructions must be restated when delegating work.

## Alternatives Considered

### Single project file only

A single workspace instruction file would simplify discovery and reduce context loading complexity.

It was rejected because it removes the user's portable personal baseline. Users would need to copy the same conventions into every repository, which increases drift and setup friction.

### Global file only

A single global instruction file would make behavior consistent everywhere.

It was rejected because repository-specific rules would either be impossible to express or would conflict with one another across projects.

### Explicit `--context` flag per session

A command-line flag would let users opt into a context file manually for each session.

It was rejected because it adds routine friction to normal workflows, is easy to forget, and weakens the guarantee that project rules are present on every invocation.
