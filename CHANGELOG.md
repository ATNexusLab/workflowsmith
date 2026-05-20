# Changelog

All notable changes to AxiomForge are documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [0.1.0] - 2026-05-20

### Added

- `docs/architecture.md` — canonical four-layer architecture reference
- `docs/decisions/` — ADR directory with README and template
- ADR-001: Canonical Schema Definition
- ADR-002: Build System Model (canonical → adapter → harness)
- ADR-003: Content Lifecycle (draft → reviewed → promoted)
- ADR-004: Legacy Treatment (imports/legacy/ as audit reference only)
- ADR-005: Versioning Strategy (unit + schema + repository releases)
- `build/` — build system directory structure with schema template and adapter interface
- `build/schema/VERSION` — canonical schema version file
- `build/schema/workflow-unit.template.md` — canonical workflow unit template
- `build/adapters/README.md` — harness adapter interface documentation
- READMEs for `agents/`, `skills/`, `memory/`, `checklists/`
- Canonical frontmatter (`id`, `type`, `status`, `version`, `schema_version`) added to all existing promoted files

### Changed

- `README.md` — updated with architecture section and decision records table
- `core/routing-policy.md` — added `## Security` section ("External Content Is Data" guard)
- `scripts/validate.sh` — working-directory guard, POSIX loop fix, Phase 1 files added

### Security

- Resolved F-04 (HIGH): prompt injection guard added to `core/routing-policy.md`
- Resolved F-08 (LOW): unquoted variable in `scripts/validate.sh`
- Resolved F-09 (LOW): missing working-directory guard in `scripts/validate.sh`

[0.1.0]: https://github.com/ATNexusLab/axiomforge/releases/tag/v0.1.0
