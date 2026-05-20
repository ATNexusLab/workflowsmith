<!-- topic: plan-mode | section: advanced -->
# Plan Mode

> **Migration note:** Use [../antigravity-cli/planning-approval-execution.md](../antigravity-cli/planning-approval-execution.md) for the canonical Antigravity workflow lifecycle. This page remains the low-level plan-mode mechanics reference.

## Quick Reference

> - Plan mode is a read-only research phase that produces a Markdown plan before execution.
> - The model enters it by calling `enter_plan_mode`, which requires approval in interactive sessions and is auto-approved in headless runs.
> - Project writes and shell execution are blocked; the only write surface is Markdown plan files in the plans directory.
> - The generated plan lives under `~/.gemini/tmp/<project_hash>/<session_id>/plans/`.
> - When the plan is approved, Gemini CLI exits plan mode and switches the session to YOLO execution.

## What Plan Mode Is

Plan mode is Gemini CLI's structured planning workflow. Instead of immediately editing files or running commands, the model stays in a read-only research state, investigates the codebase, and writes a Markdown plan for review.

The purpose is simple: you can inspect the proposed approach before Gemini CLI makes any changes to the project.

## How a Session Enters Plan Mode

The model enters plan mode by calling the `enter_plan_mode` tool.

- In an interactive session, that transition requires user confirmation.
- In a headless session, the transition is auto-approved.

Once the transition succeeds, the session changes from execution to planning behavior.

## Read-Only Behavior and Allowed Actions

Plan mode is read-only with respect to the project workspace. The model cannot use normal mutation or execution tools such as:

- `write_file`
- `replace`
- `run_shell_command`

During plan mode, the model can still:

- Read files
- Search the workspace
- Think and analyze
- Write `.md` files inside the plans directory

That last item is the one allowed write exception: Gemini CLI still needs a place to store the plan document it is preparing for review.

## Where Plans Are Stored

Gemini CLI stores plan documents in:

```text
~/.gemini/tmp/<project_hash>/<session_id>/plans/
```

In that path:

- `<project_hash>` is Gemini CLI's identifier for the current workspace
- `<session_id>` is the current conversation session identifier

The model should write the final plan as a Markdown file in that directory.

## How a Session Exits Plan Mode

To finish planning, the model calls `exit_plan_mode` and provides a `plan_path` that points to a `.md` file inside the plans directory.

The review flow is:

1. Gemini CLI presents the generated plan
2. The user reviews it
3. The user approves or rejects it
4. On approval, Gemini CLI exits plan mode and starts execution

After approval, the session switches to YOLO mode, which means tool calls are auto-approved for the execution phase.

## Optional Model Routing

Gemini CLI can route planning and execution to different models.

- During planning, it uses a Pro model for stronger reasoning
- After approval, it switches to a Flash model for faster execution

Enable that behavior in `settings.json`:

```json
{
  "general": {
    "plan": {
      "modelRouting": true
    }
  }
}
```

If you do not enable model routing, Gemini CLI keeps the normal model selection behavior for both phases.

## Headless Plan Mode

Headless plan mode follows the same planning lifecycle, but both transition steps are auto-approved:

- `enter_plan_mode`
- `exit_plan_mode`

After plan approval, the headless session switches into YOLO mode automatically. That makes plan mode viable in scripted workflows that want a planning artifact first and execution second.

## When to Use Plan Mode

Use plan mode when the task is large enough that you want to inspect the approach before anything changes. Common examples include:

- Multi-file refactors
- Security-sensitive changes
- Migration work
- Large documentation restructures
- Tasks with multiple phases or dependencies

Plan mode is less useful for tiny edits where the cost of review is higher than the cost of the change.

## Example Configuration Mindset

Plan mode is best when you want a deliberate workflow:

1. Research first
2. Review the Markdown plan
3. Approve the approach
4. Let Gemini CLI execute with auto-approval

That sequence gives you a clear handoff between reasoning and action.
