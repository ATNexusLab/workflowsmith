# AxiomForge Roadmap

This roadmap tracks the path from the v0.1.0 foundation to the v1.0.0 stable release.
Sprint scope is derived from the acceptance criteria in [`docs/specs/requirements.md`](docs/specs/requirements.md).

Sprints are one week each. Dependencies are strict: each sprint cannot begin until the previous
one is complete and `sh scripts/validate.sh` exits 0.

---

## v0.1.0 — Foundation (released 2026-05-20)

The foundation phase established the architecture, governance model, and repository conventions.
All decisions from this phase remain authoritative until explicitly superseded.

**Delivered:**
- Four-layer architecture (Schema, Content, Build, Validation) — `docs/architecture.md`
- ADR-001 through ADR-005: schema, build system, content lifecycle, legacy treatment, versioning
- Canonical workflow unit template and adapter interface stub — `build/`
- Promoted content: `core/routing-policy.md`, `core/output-contracts.md`, `agents/principal.md`,
  `skills/review/review-code.md`, `checklists/final-answer.md`, `memory/index.md`
- Repository validation script — `scripts/validate.sh`
- Security audit with 11 findings; resolved: F-04 (HIGH), F-08 (LOW), F-09 (LOW)
- Draft v1 requirements — `docs/specs/requirements.md`

---

## v1.0.0 — First Stable Release (target: 2026-07-01)

v1.0.0 is feature-complete when all acceptance criteria in `docs/specs/requirements.md` are met:
`axiomforge.yml` present, all four agents promoted, 13 skill domains covered, six harness
distributions committed under `dist/`, all HIGH/MEDIUM security findings resolved, and public
documentation complete.

### Sprint 1 — Governance (2026-05-27 → 2026-06-02)

Resolve all open architectural decisions before any v1 content work begins. Every subsequent
sprint depends on having stable contracts for distribution layout, manifest format, content types,
and validation scope.

| Deliverable | Description |
|---|---|
| `docs/decisions/ADR-006-distribution-model.md` | Supersedes ADR-002. `dist/` is committed, not ephemeral. Defines per-harness directory layout and official-source evidence format. |
| `docs/decisions/ADR-007-manifest-spec.md` | `axiomforge.yml` contract: required fields, ordering semantics, schema validation decision. |
| `docs/decisions/ADR-008-v1-content-types.md` | Amends ADR-001. Decides whether distribution support files (manifests, matrices, templates) are canonical workflow unit types or non-canonical. |
| `docs/decisions/ADR-009-validation-responsibilities.md` | Extends the validation layer contract for v1: frontmatter checks, manifest presence, dist completeness, security scan scope. |
| `axiomforge.yml` (stub) | Root manifest populated with v1 targets. Empty harness/dist sections filled by subsequent sprints. |

**Blocking dependency:** none — Sprint 1 is the foundation for all subsequent sprints.

---

### Sprint 2 — Agents & Core Skills (2026-06-03 → 2026-06-09)

Complete the canonical agent roster and promote the first batch of required skills. All content
goes through the full draft → reviewed → promoted lifecycle within the sprint. Legacy imports
in `imports/` provide reference material; nothing is promoted without explicit lifecycle review.

| Deliverable | Description |
|---|---|
| `agents/builder.md` (promoted) | Builder/Engineer agent. Responsibilities: technical implementation, refactoring, tests, engineering changes. Read from legacy `engine.md` references across all three source harnesses. |
| `agents/creative.md` (promoted) | Creative/Product agent. Responsibilities: UX, frontend experience, product framing, technical communication, user-facing writing. |
| `agents/reviewer.md` (promoted) | Reviewer/Auditor agent. Read-only by default. Responsibilities: correctness, regressions, security review, maintainability, missing validation. |
| Skills batch 1 (6 files, promoted) | `skills/spec/spec-writing.md`, `skills/architecture/architecture-reading.md`, `skills/implementation/refactoring.md`, `skills/testing/testing-patterns.md`, `skills/testing/testing-contract.md`, `skills/security/security-audit.md` |
| `scripts/validate.sh` update | Extended to verify: all files in `agents/`, `skills/`, `core/` carry `status: promoted` frontmatter; `axiomforge.yml` exists and is non-empty. |

**Blocking dependency:** Sprint 1 ADRs accepted.

---

### Sprint 3 — Remaining Skills & Policies (2026-06-10 → 2026-06-16)

Complete the 13-domain skill catalog, add the rigor-level policy, and finalize `axiomforge.yml`
with all canonical content IDs. The `harness-translation` skill produced here is the working guide
used to author distributions in Sprint 4.

| Deliverable | Description |
|---|---|
| Skills batch 2 (5 files, promoted) | `skills/api/api-design.md`, `skills/data/database-design.md`, `skills/devops/devops-patterns.md`, `skills/performance/performance-analysis.md`, `skills/writing/technical-writing.md` |
| Skills batch 3 (2 files, promoted) | `skills/harness/harness-translation.md` (mapping canonical workflow to harness-native surfaces), `skills/memory/memory-governance.md` (knowledge and memory governance) |
| `core/rigor-policy.md` (promoted) | Defines Fast, Standard, and Rigorous rigor levels, automatic routing triggers, planning requirements per level, and validation expectations. |
| `checklists/release.md` (promoted) | Maintainer release checklist: CHANGELOG update, validate.sh pass, security findings resolved, tagging, publishing. |
| `axiomforge.yml` (finalized) | All canonical content IDs added. Harness targets and dist directory targets declared. Validation requirements section populated per ADR-009. |

**Blocking dependency:** Sprint 2 complete. `harness-translation` skill must be promoted before Sprint 4 distribution authoring begins.

---

### Sprint 4 — Security Hardening & Distributions 1–3 (2026-06-17 → 2026-06-23)

Resolve all open HIGH and MEDIUM security findings as safe opt-in templates committed to `dist/`.
Author full distribution scaffolds for Claude, GitHub Copilot, and Antigravity using the
`harness-translation` skill as the working guide.

**Security remediation — open findings resolved as safe templates:**

| Finding | Severity | File | Remediation |
|---|---|---|---|
| F-01 | HIGH | `dist/claude/hooks/auto-approve-permissions.js` | Whitelist-based; not unconditional allow |
| F-02 | HIGH | `dist/antigravity/hooks/plan-first.js` | `XDG_RUNTIME_DIR` sentinel; not world-writable `/tmp` |
| F-03 | HIGH | `dist/copilot/hooks/block-git-write.sh` | Fail-closed fallback when `jq`/`python3` absent |
| F-05 | HIGH | `dist/antigravity/hooks/worktree-cleanup.js` | `execFileSync` array form; no hardcoded paths |
| F-06 | MEDIUM | `dist/claude/hooks/worktree-cleanup.js` | `execFileSync` array form; no string interpolation |
| F-07 | MEDIUM | `dist/copilot/hooks/guardrails.sh` | Extracted from inline JSON to standalone script |

All hook templates: disabled by default, documented with trigger, required permissions, and failure behavior.

**Distribution scaffolds — each directory includes:**
manifest, README (usage notes), translated workflow assets, safe hook templates, MCP/tool template
with placeholders only, traceability record, equivalence matrix, gap notes.

| Distribution | Notes |
|---|---|
| `dist/claude/` | Claude Code native surfaces: CLAUDE.md, slash commands, hooks, MCP templates |
| `dist/copilot/` | GitHub Copilot native surfaces: `copilot-instructions.md`, prompt files; agent concept documented as gap |
| `dist/antigravity/` | Antigravity/Gemini CLI native surfaces: GEMINI.md layout; F-10 regex gaps noted in gap notes |

`scripts/validate.sh` update: dist completeness checks (manifest, README, traceability, equivalence
matrix required per harness directory) and basic secret scan (credentials, personal absolute paths).

**Blocking dependency:** Sprint 3 complete, `harness-translation` promoted.

---

### Sprint 5 — Distributions 4–6, Documentation & v1 Release (2026-06-24 → 2026-07-01)

Complete the three remaining distributions, finalize all public documentation, run the full
validation and security scan, and tag v1.0.0.

| Deliverable | Description |
|---|---|
| `dist/codex/` | Full scaffold. Codex official-source gaps explicitly marked. |
| `dist/opencode/` | Full scaffold. OpenCode official-source gaps explicitly marked. |
| `dist/openclaude/` | Full scaffold (`Gitlawb/openclaude`). Assumptions labeled as such throughout; equivalence matrix reflects limited official documentation. |
| `docs/security-model.md` | Formal security model: principles, how `scripts/validate.sh` enforces them, resolved and open finding history. |
| `docs/contributing.md` | Maintainer workflow guide: authoring a skill, updating a distribution, cutting a release. |
| `docs/scenarios.md` | 11 representative workflow scenarios from `docs/specs/requirements.md`: rigor level, responsible agent, applicable skills, expected output shape. |
| `README.md` (updated) | v1 scope, all six distributions, installation model, validation command. |
| `docs/decisions/ADR-010-v1-release.md` | Records the v1 release decision: what was resolved, what was deferred to v1.1+, known accepted gaps. Immutable once accepted. |
| `CHANGELOG.md` | Move [Unreleased] to [1.0.0] dated 2026-07-01. |
| `v1.0.0` git tag | Annotated tag. Release closes when `sh scripts/validate.sh` exits 0 and all HIGH/MEDIUM findings are resolved. |

**Blocking dependency:** Sprints 1–4 complete; `sh scripts/validate.sh` exits 0; all HIGH/MEDIUM security findings resolved in templates.

---

## Deferred to v1.1+

The following items are explicitly out of scope for v1.0.0. They are recorded here to prevent
scope creep and to preserve decision context for the next cycle.

- **Build runner automation** — `dist/` is manually authored in v1. ADR-006 notes where future automation could take over.
- **Unit-level versioning friction** — ADR-005 per-unit semver may conflict with release-oriented maintenance cadence. ADR-007 reduces the friction; a full resolution is deferred.
- **MCP server supply-chain review** — `npx -y` patterns in legacy hook templates require a separate audit pass before being recommended as defaults.
- **Machine-readable adapter contracts** — ADR-005 notes these are informal in Phase 1. A formal adapter contract schema is deferred.
- **F-10 full remediation** — regex gaps in `block-git-write.sh` are noted in Copilot gap notes but not fully fixed in v1 (awareness-only finding per the audit).

---

## Dependency Chain

```
Sprint 1 — Governance (ADRs 6–9 + axiomforge.yml stub)
    └── Sprint 2 — Agents & Core Skills
            └── Sprint 3 — Remaining Skills & Policies (harness-translation unblocks Sprint 4)
                    └── Sprint 4 — Security Hardening & Distributions 1–3
                            └── Sprint 5 — Distributions 4–6 + Docs + v1.0.0 release
```

---

## Tracking

GitHub issue: [#5 — Create v1 roadmap and sprint plan](https://github.com/ATNexusLab/axiomforge/issues/5)

Sprint progress is tracked by opening a GitHub issue per sprint at the start of each week and
closing it when all deliverables are promoted and `sh scripts/validate.sh` exits 0.
