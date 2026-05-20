---
description: Set up a new project — generates .github/copilot-instructions.md with detected stack, conventions, and commands.
agent: principal
---

Bootstrap this project.

Scan the repository for manifest files (`package.json`, `Cargo.toml`, `pyproject.toml`, `pubspec.yaml`, `Dockerfile`, `.github/workflows/`, `prisma/`, `migrations/`) and infer the stack, package manager, and toolchain before asking any questions.

Confirm only what could not be inferred from those files.

Then create `.github/copilot-instructions.md` containing:
- Confirmed stack and package manager
- Project-specific conventions (naming, module structure, patterns)
- Exact commands for lint, typecheck, format, build, and test
- Folder structure and module boundaries

Do not duplicate rules that are already in the global `~/.copilot/copilot-instructions.md`. Keep the file additive and project-scoped.
