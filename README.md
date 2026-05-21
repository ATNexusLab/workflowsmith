# WorkflowSmith

WorkflowSmith is an enterprise-grade AI workflow system.

It defines one canonical workflow source for senior software engineering work and compiles that source into harness-specific distributions. Codex is the first compiled and validated harness. Other harnesses are added only after the canonical workflow and compiler contract are stable.

## Current Milestone

The active milestone is `0.0.0`.

`0.0.0` is a clean foundation release. It establishes product identity, architecture, governance, repository layout, and validation. It does not ship the complete workflow or a production Codex distribution.

## Product Model

WorkflowSmith has three product layers:

1. Canonical workflow source in `workflow/`
2. Compiler contracts in `compiler/`
3. Harness distributions in `dist/`

The canonical source stays harness-agnostic. Harness-specific behavior belongs in compiler contracts and compiled distribution directories.

## Repository Map

- `workflow/` - canonical workflow source and schema notes.
- `compiler/` - compiler contracts and target mapping rules.
- `dist/` - compiled harness outputs; `dist/codex/` is the first target.
- `docs/` - architecture, development process, governance, roadmap, and ADRs.
- `.github/` - issue forms and pull request templates.
- `scripts/` - repository validation.
- `workflowsmith.yml` - root product manifest.

## Development

Run validation before opening or merging a pull request:

```sh
sh scripts/validate.sh
```

All meaningful changes should move through issue, branch, pull request, validation, and merge. Architectural and process changes require an ADR.

## Documentation

- [Architecture](docs/architecture.md)
- [Development Process](docs/development-process.md)
- [Roadmap](docs/roadmap.md)
- [GitHub Governance](docs/governance/github.md)
- [Decision Records](docs/decisions/README.md)
