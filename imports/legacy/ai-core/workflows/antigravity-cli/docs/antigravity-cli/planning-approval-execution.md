<!-- topic: planning-approval-execution | section: antigravity-cli -->
# Antigravity Planning, Approval, and Execution

This is the canonical user-facing explanation of the **plan -> approval -> execution** lifecycle in this repository.

## Quick Reference

> - Planning is the deliberate, read-only phase.
> - Approval is the explicit handoff between planning and action.
> - Execution starts only after direct approval or an approved plan.
> - Use [../advanced/plan-mode.md](../advanced/plan-mode.md) for low-level plan-mode mechanics.

## Canonical lifecycle

| Phase | What happens | Primary page |
|---|---|---|
| Frame the task | Decide whether the work is safe to execute directly or needs a reviewable plan first | This page |
| Plan | Research, inspect the repo, and write the proposed approach without changing the workspace | [../advanced/plan-mode.md](../advanced/plan-mode.md) |
| Approve or revise | Review the plan, confirm scope, or send it back for changes | This page |
| Execute and close out | Apply the approved work, validate it, and summarize what changed | This page |

## 1. Frame the task

Use planning first when the work is multi-step, risky, migration-heavy, or still ambiguous.

Direct execution is fine when the change is already small, clear, and explicitly approved.

## 2. Plan

During planning, the session should gather context, identify risks, and produce a Markdown plan that another human can review.

That planning phase is the right time to settle:

- scope
- ordering
- dependencies
- risks
- open questions

For the exact plan-mode tool behavior, storage path, and approval mechanics, use [../advanced/plan-mode.md](../advanced/plan-mode.md).

## 3. Approval

Approval is the boundary that turns a proposal into authorized work.

A good approval check answers:

- Is the scope correct?
- Are the tradeoffs acceptable?
- Are the risky steps called out?
- Is execution now authorized?

Discussion alone is not approval. If the plan changes materially, review it again.

## 4. Execute and close out

After approval, execute the agreed steps, validate the result, and report what changed.

Execution should stay aligned to the approved scope. If the work expands materially, return to planning instead of silently drifting.

## Headless and interactive runs

The same lifecycle applies in both modes:

- **Interactive:** a human reviews and approves the planning boundary directly.
- **Headless:** plan-mode transitions can be auto-approved, but the plan artifact is still the boundary between planning and execution.

## Related pages

- Use [workflow-authoring.md](workflow-authoring.md) when you want to save part of this lifecycle as a reusable command, skill, or agent.
- Use [../advanced/plan-mode.md](../advanced/plan-mode.md) for the detailed mechanics of entering, exiting, and storing plans.
