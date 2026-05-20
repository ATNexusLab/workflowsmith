# ADR-005: Versioning Strategy

**Status:** Accepted

## Context

AxiomForge is a source-of-truth repository whose content is read by adapters and translated into harness-specific artifacts. For this to work reliably, three distinct versioning concerns must be addressed:

1. **Unit-level versioning** — each canonical workflow unit carries a version. Without clear rules for when that version changes, adapters cannot know whether a content update is safe to absorb or requires an adapter update.

2. **Schema versioning** — the canonical schema (ADR-001) itself evolves. When a new required field is added or an existing field is renamed, every unit in the repository and every adapter that reads those units is affected. Adapters need a way to declare which schema version they support and refuse incompatible content gracefully.

3. **Repository release versioning** — AxiomForge as a product needs a release model. Harness environments that pin to a version of AxiomForge need clear signals for when upgrading is safe and what changed.

Without a formal versioning strategy, any change to a unit or the schema is silent to all downstream consumers.

## Decision

### 1. Unit-Level Versioning (Semver)

Every canonical workflow unit carries a `version` field (semver string, e.g., `1.0.0`).

**Bump rules:**

| Change type | Bump | Examples |
|---|---|---|
| Removes or renames a field, changes behavioral semantics in a breaking way | **Major** | Rename `id` to `uid`; remove a required section; change a policy rule in a way that invalidates prior adapter output |
| Adds a new optional field; adds non-breaking behavior; additive clarification | **Minor** | Add a new optional frontmatter field; extend a skill with a new optional section |
| Fixes a defect, typo, or clarification with no behavioral change | **Patch** | Fix a sentence; correct a broken cross-reference; formatting only |

A content unit's version is independent of the schema version and of the repository release version. A patch fix to a skill does not require a repository major release.

---

### 2. Schema Versioning

The canonical schema defined in ADR-001 carries its own version, declared in `build/schema/VERSION`. This is a plain-text file containing a single semver string (e.g., `1.0.0`).

Every canonical workflow unit includes a `schema_version` field in its frontmatter. This field declares which schema version the unit was authored against.

```yaml
schema_version: 1.0.0
```

**Schema bump rules:**

| Change | Bump | Adapter impact |
|---|---|---|
| New required field added; existing field renamed or removed; allowed values reduced | **Major** | Adapters must update before reading content at the new schema version |
| New optional field added; allowed values extended | **Minor** | Adapters written for v1.x can read v1.y safely (forward compatible) |
| Documentation fix, clarification, no field change | **Patch** | No adapter impact |

**Compatibility contract:**
- An adapter that declares support for schema `v1.x` MUST handle any unit with `schema_version: 1.*.*`.
- An adapter encountering a unit with a `schema_version` major version higher than its declared support MUST refuse to process it and report an incompatibility error.
- An adapter encountering an unknown `schema_version` minor version MUST treat unknown optional fields as ignored and proceed.

The current schema version is tracked in `build/schema/VERSION`. The ADR for the schema change records why the major version was bumped. Schema major bumps require an ADR.

---

### 3. Repository Release Versioning

AxiomForge uses git tags following semver (`v1.0.0`, `v1.1.0`, etc.) and maintains a `CHANGELOG.md` following the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format.

**Release bump rules:**

| Change | Bump | Examples |
|---|---|---|
| Schema major bump; removal of promoted units; breaking change to repository structure | **Major** | Schema v1 → v2; `core/` directory renamed |
| New promoted units; schema minor bump; new ADR that changes routing behavior | **Minor** | New skill or agent promoted; new optional schema field |
| Fixes to existing promoted units; documentation improvements; validation script fixes | **Patch** | Security fix in routing policy; typo in an ADR; validate.sh hardening |

**Release process:**
1. Update `CHANGELOG.md` under `## [Unreleased]` throughout development.
2. At release time: move `[Unreleased]` to a new `## [vX.Y.Z] - YYYY-MM-DD` section.
3. Create a git tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`.
4. Push the tag: `git push origin vX.Y.Z`.

The initial Phase 1 state is tagged as `v0.1.0` — a pre-release that establishes the architecture foundation without stable workflow content.

---

## Consequences

- `build/schema/VERSION` is a required file. `scripts/validate.sh` should check for its presence.
- Every canonical workflow unit MUST include `schema_version` in its frontmatter. The `build/schema/workflow-unit.template.md` is updated to include this field.
- `CHANGELOG.md` is a required file in the repository root.
- Existing promoted units that predate this ADR should be updated to include `schema_version: 1.0.0`.
- Schema major bumps require a new ADR — they are not made silently.
- Adapters declare their supported schema version in their `build/adapters/<harness>/README.md`. This is an informal declaration in Phase 1; it may become a machine-readable contract in a later phase.
