# Canonical Source

This directory contains the canonical WorkflowSmith workflow.

Content here must be harness-agnostic. Codex-specific behavior belongs in
`compiler/` or `dist/codex/`.

The complete workflow is intentionally deferred beyond 0.0.0. Framework
specifications that define how the workflow is structured live in
`workflow/spec/`.

## Structure

As the workflow develops through milestone 0.1.0 and beyond, this directory
will contain:

- `agents/` — canonical agent definitions
- `skills/` — canonical skill definitions
- `hooks/` — canonical hook definitions
- `commands/` — canonical command definitions
- `rules/` — canonical rules
