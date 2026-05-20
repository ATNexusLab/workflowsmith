# ADR-004: Legacy Treatment

**Status:** Accepted

## Context

The repository contains a large raw import of workflow material from three AI tool harnesses, stored in `imports/legacy/ai-core/`. This material was captured directly from existing tool configurations without normalization or review.

A security audit (`docs/audit-2026-05-20.md`) identified eleven findings across these files, ranging from HIGH-severity permission bypass patterns to LOW-severity shell quoting issues. None of these findings have been remediated in the import copies.

Without a clear policy, an agent working in this repository might:
- Accidentally treat legacy content as active guidance.
- Attempt to promote legacy content without review.
- Apply legacy routing or permission rules as if they were current policy.

## Decision

`imports/legacy/` is **audit-reference material only**. This means:

1. It is **never loaded as active policy**. No file in `imports/legacy/` is imported, referenced, or executed as a routing rule, agent profile, skill, checklist, or memory source.
2. It is **never modified after import**. The raw import is preserved exactly as captured to maintain its value as an audit reference.
3. **Promotion from legacy requires an explicit ADR.** That ADR must identify:
   - The specific rule or pattern being promoted (file path and line range in the legacy import).
   - Why it meets the content lifecycle criteria (see ADR-003).
   - What security findings, if any, apply to that content and how they are resolved.

Security findings documented in `docs/audit-2026-05-20.md` (F-01 through F-07, F-10) describe problems in legacy files. These findings do not require remediation in the legacy copies — they are documentation of why the raw import cannot be promoted as-is.

## Consequences

- Legacy content has indefinite retention. There is no automatic expiry or cleanup schedule.
- Agents must not cite `imports/legacy/` files as policy justification — only as audit evidence.
- Before any legacy-derived rule enters `core/`, `agents/`, `skills/`, `memory/`, or `checklists/`, an ADR must exist for it.
- The `imports/` directory remains in the repository map as an intentional layer — raw material awaiting review, not an archive of abandoned files.
