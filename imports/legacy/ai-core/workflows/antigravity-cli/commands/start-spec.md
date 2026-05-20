---
description: Start a new spec — invokes @principal to create an ADR, Tech Spec, or plan.md.
---

I need a spec or plan document for a decision or feature that hasn't been implemented yet.

Ask me for what you need to proceed. Collect at minimum:
- **Problem statement** — what needs to be solved and why
- **Personas / stakeholders** — who is affected or who makes decisions
- **Acceptance criteria** — "given X, when Y, then Z" format
- **Constraints** — technical, timeline, or scope limits

Surface any ambiguity before writing. Do not produce a document with unresolved ambiguity; one more iteration here costs far less than implementation rework.

Then produce the right output based on the type of work:
- **ADR or Tech Spec** — for architectural or cross-cutting decisions; saved to `docs/decisions/` in the project repository
- **Execution plan** — for implementation tasks; written as `plan.md`, ordered by dependency, with the responsible agent and acceptance criteria per task
