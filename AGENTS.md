# Repository Guidelines

## Project Structure & Module Organization

WorkflowSmith is a plain-text source-of-truth repository for AI workflow instructions. Active, promoted guidance lives in the top-level domain directories:

- `core/`: baseline routing policy and output contracts.
- `agents/`: agent definitions, currently including `agents/principal.md`.
- `skills/`: task-specific skill instructions, such as `skills/review/review-code.md`.
- `memory/`: versioned memory indexes and references.
- `checklists/`: reusable completion and review checklists.
- `docs/`: explanatory documentation for repository concepts.
- `imports/`: raw or extracted legacy workflow material. Treat `imports/legacy/` as inactive reference material until selected content is reviewed and promoted.
- `scripts/`: lightweight repository checks.

## Build, Test, and Development Commands

This repository has no package build step. Use the validation script before submitting changes:

```sh
sh scripts/validate.sh
```

The script verifies that required foundation files and legacy import markers exist and are non-empty. For quick navigation, use `rg --files` to list tracked content and `rg "term" core agents skills docs` to search promoted policy areas.

## Coding Style & Naming Conventions

Most source files are Markdown. Use ATX headings (`#`, `##`), concise paragraphs, and direct instructional language. Prefer fenced code blocks with language tags for commands, for example:

```sh
sh scripts/validate.sh
```

Name Markdown files with lowercase kebab-case, as in `routing-policy.md` or `final-answer.md`. Shell scripts should be POSIX-compatible where practical; `scripts/validate.sh` uses `#!/bin/sh`, `set -eu`, and simple loops.

## Testing Guidelines

There is no dedicated test framework or coverage target. Validation is currently structural: run `sh scripts/validate.sh` after edits to promoted files or import markers. When adding new scripts, keep checks deterministic, fast, and readable enough to audit in one pass.

## Commit & Pull Request Guidelines

The current history is small and includes both an initial commit and a Conventional Commit-style message (`feat: ...`). Prefer concise, present-tense commit messages with prefixes such as `docs:`, `feat:`, `fix:`, or `chore:` when useful.

Pull requests should explain what changed, why it was promoted or imported, and which files are authoritative versus reference-only. Include the validation result, link related issues when available, and call out any policy behavior changes that affect agents, skills, routing, memory, or final-answer requirements.

## Agent-Specific Instructions

Preserve the repository principle: import first, normalize second, promote last. Do not treat raw legacy content as active policy unless it has been intentionally moved into `core/`, `agents/`, `skills/`, `memory/`, or `checklists/`.
