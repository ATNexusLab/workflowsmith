# ADR-001: Canonical Schema Definition

**Status:** Accepted

## Context

WorkflowSmith is a source-of-truth repository that must translate workflow units across multiple AI harnesses (Copilot, Claude, Antigravity CLI, and future tools). Each harness reads instructions in its own format and from its own file locations.

Without a shared schema, an adapter has no stable contract to read from. If each content file is free-form Markdown, an adapter must guess what fields are present, whether a unit is ready to use, and what kind of unit it is. This makes adapters fragile and content unauditable.

The schema must be harness-agnostic — no Copilot-specific fields, no Claude-specific fields at this layer. Harness specifics belong only in adapters.

## Decision

A canonical workflow unit is a Markdown file with a YAML frontmatter block that contains a defined set of required and optional fields.

**Required fields:**

| Field | Type | Allowed values |
|---|---|---|
| `id` | string | Unique slug, lowercase kebab-case (e.g., `skill-spec-writing`) |
| `type` | enum | `agent`, `skill`, `policy`, `checklist`, `memory-index` |
| `status` | enum | `draft`, `reviewed`, `promoted` |
| `version` | string | Semver (e.g., `1.0.0`) — version of this unit |
| `schema_version` | string | Semver (e.g., `1.0.0`) — schema version this unit was authored against |

The current schema version is tracked in `build/schema/VERSION`. See ADR-005 for versioning rules and compatibility contracts.

**Optional fields:**

| Field | Type | Description |
|---|---|---|
| `tags` | list of strings | Thematic labels for discovery |
| `replaces` | string | `id` of the unit this supersedes |
| `see-also` | list of strings | Related unit `id` values |

A content item without all required fields cannot be promoted. Adapters may rely on these fields being present in any promoted content.

The canonical schema template lives at `build/schema/workflow-unit.template.md`.

## Consequences

- Adapters have a stable contract: they read canonical frontmatter fields and translate them into harness-specific format.
- Content without required frontmatter cannot enter `core/`, `agents/`, `skills/`, `memory/`, or `checklists/` in `promoted` status.
- The `scripts/validate.sh` can be extended to enforce frontmatter presence on promoted files.
- Legacy imports in `imports/` do not have this frontmatter — they are not schema-compliant and cannot be promoted without going through the content lifecycle.
- A new `type` value requires an update to this ADR before it is used.
