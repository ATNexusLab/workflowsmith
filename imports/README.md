# Imports

This directory stores raw workflow imports before they become active repository policy.

Imported material is not automatically part of `core/`, `agents/`, `skills/`, `memory/`, or `checklists/`. Treat it as audit evidence until a later normalization and promotion step explicitly moves selected content into the active repository structure.

## Rules

- Preserve raw imports without rewriting their behavior.
- Keep source, date, scope, and status metadata with every import.
- Do not run imported hooks, scripts, or commands as part of import.
- Promote one workflow area at a time after review.

