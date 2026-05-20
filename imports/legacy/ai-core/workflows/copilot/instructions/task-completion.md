<!-- REFERENCE ONLY — Not an active instruction surface. No `applyTo` frontmatter.
     The live baseline is: ~/.copilot/copilot-instructions.md (repo root).
     This file is a standalone reference extract for readability only. -->

# Task Completion Protocol

Applicable to **all agents, in all projects**. No task is declared complete until all checks pass with exit code 0. Runs **once** at the "Ready for Review" stage — not at every intermediate step.

## 1. Command Discovery

Before running any check, read the project manifest (`package.json`, `pyproject.toml`, `Cargo.toml`, `Makefile`, `pubspec.yaml`, `go.mod`, `Gemfile`) and map available scripts to the required checks:

| Check | Expected script examples |
|-------|--------------------------|
| **lint** | `lint`, `lint:check`, `biome:lint`, `eslint`, `ruff check`, `cargo clippy` |
| **typecheck** | `typecheck`, `type-check`, `tsc`, `tsc:check`, `mypy`, `pyright`, `cargo check` |
| **format** | `format`, `format:check`, `biome:format`, `prettier`, `ruff format --check`, `cargo fmt --check` |
| **build** | `build`, `build:prod`, `compile`, `cargo build`, `python -m build` |
| **tests** | `test`, `test:run`, `test:ci`, `pytest`, `cargo test` |

## 2. Fallback — Commands Not Found

If the manifest **does not exist** or the relevant script **is not defined**:

1. **Pause the task immediately.**
2. Inform the user exactly which commands are missing.
3. Ask: _"What command should I use for [check] in this project?"_
4. **Do not proceed** without user-confirmed commands.

> Never assume, invent, or hardcode command names.

## 3. Execution Order

Run checks **strictly in this order**, one at a time:

```
lint → typecheck → format → build → tests
```

Each check run with the script discovered in the manifest, prefixed with the project's package manager (`bun run`, `npm run`, `pnpm`, `cargo`, `uv run`, etc.).

## 4. Failure Loop

If **any check fails**:

1. Analyze the error output.
2. Fix the problem in the code.
3. Re-run **that check and all subsequent ones** in the defined order.
4. Repeat until all pass.

> Never advance to the next check while the current one is failing.
> Never report the task as complete while there is a failure.

> **Zero tolerance:** any file touched during the task must have all its errors resolved — not just errors introduced by the task. Pre-existing errors in modified files become the agent's responsibility. No exceptions.

## 5. Completion Criteria

Task **complete** only when:

- `lint` → exit code **0**
- `typecheck` → exit code **0**
- `format` → exit code **0**
- `build` → exit code **0**
- `tests` → exit code **0**
- **Test Contract** (three axes) covered on the touched feature — see section below
- **Mandatory Closeout** executed — see section below

> Never report partial completion. Never ask the user to accept pending errors. If there are errors that could not be fixed, declare an explicit blocker with the reason — never pretend completion.

---

> **NOTE — `~/.copilot` repository specifically:**
> This repository contains only Markdown configuration files. There is no package manifest and no
> executable build pipeline. All five TCP checks (lint → typecheck → format → build → tests) are
> **n/a** for this repo. Record each as "n/a" in the Closeout block and continue directly to the
> Closeout checklist.
