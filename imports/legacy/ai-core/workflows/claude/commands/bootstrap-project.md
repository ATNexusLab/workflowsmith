---
description: Bootstrap a new project — invokes @principal to create CLAUDE.md, detect the stack, and define conventions.
---

Bootstrap this project.

Scan the repository for manifest files (`package.json`, `Cargo.toml`, `pyproject.toml`, `pubspec.yaml`, `Dockerfile`, `.github/workflows/`, `prisma/`, `migrations/`) and infer the stack, package manager, and toolchain before asking any questions.

Confirm only what could not be inferred from those files.

Then create `CLAUDE.md` at the project root containing:
- Confirmed stack and package manager
- Project-specific conventions (naming, module structure, patterns)
- Exact commands for lint, typecheck, format, build, and test
- Folder structure and module boundaries

Do not duplicate rules that are already in the global `~/.claude/CLAUDE.md`. Keep the file additive and project-scoped.
