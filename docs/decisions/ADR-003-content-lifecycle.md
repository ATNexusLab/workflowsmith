# ADR-003: Content Lifecycle

**Status:** Accepted

## Context

`docs/ai-core-source-of-truth.md` describes a three-state model (raw import → normalized draft → promoted standard) informally. Without explicit entry criteria for each state, "promoted" has no checkable meaning. Agents cannot determine whether a piece of content belongs in an active policy directory, and validation scripts cannot enforce the boundary.

This ADR formalizes the three states and defines what must be true before content can move between them.

## Decision

Content in WorkflowSmith has three lifecycle states. Each state has explicit entry criteria:

### `draft`

Content that has been authored or normalized but has not yet been reviewed for active policy use.

**Entry criteria:**
- File exists in a feature branch or in a staging area outside active policy directories.
- File contains valid canonical schema frontmatter with `status: draft` (see ADR-001).
- No review has been completed or recorded.

### `reviewed`

Content that has passed at least one explicit review pass with no blocking findings.

**Entry criteria:**
- All `draft` criteria are met.
- A review is recorded (in a PR, checklist run, or ADR) and all blocking findings are resolved.
- The `status` field in frontmatter is updated to `reviewed`.

### `promoted`

Content that is accepted as active policy and lives in a canonical policy directory.

**Entry criteria:**
- All `reviewed` criteria are met.
- The content lives in `core/`, `agents/`, `skills/`, `memory/`, or `checklists/`.
- The `status` field in frontmatter is `promoted`.
- The content is traceable to either an imported source or an explicit repository decision (ADR or PR record).

---

Content in `imports/` is below the `draft` state — it does not have canonical schema frontmatter and cannot be promoted without first going through the full lifecycle. This is a direct consequence of ADR-004 (Legacy Treatment).

## Consequences

- The `scripts/validate.sh` can be extended to check that all files in active policy directories have `status: promoted` in their frontmatter.
- A content item removed from a policy directory reverts to `reviewed` (or `draft` if its review record is no longer valid) — it does not disappear from the lifecycle.
- Promotion is always intentional: it requires an explicit state change and a traceable decision.
- Raw legacy imports in `imports/legacy/` are permanently pre-draft unless a dedicated ADR promotes a specific item through the full lifecycle.
