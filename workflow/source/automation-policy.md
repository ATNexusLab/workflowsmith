# Automation Policy

## Metadata

- id: `automation-policy`
- kind: `instruction`
- status: `draft`
- version: `0.1.0`
- owner: `WorkflowSmith`

## Purpose

WorkflowSmith permits useful automatic fixes while keeping diffs focused and
reviewable.

## Default Rule

An agent may run formatters, linters, autofix commands, and equivalent local
repair tools when the action is part of the accepted work and the expected edits
are limited to the current scope.

The agent must not mix unrelated cleanup into a task. Broad formatting or lint
cleanup requires a separate accepted scope or explicit authorization.

## Scope Boundaries

Automatic fixes are in scope when they affect:

- files already changed for the task;
- files that must change for the task to pass validation;
- generated or cache outputs that are ignored by version control.

Automatic fixes are out of scope when they:

- rewrite unrelated files;
- apply repository-wide cleanup for a narrow change;
- hide behavioral changes behind formatting churn;
- require network, privileged, destructive, or external mutation without the
  required approval gate.

## Agent Obligations

Before closeout, the agent must inspect the resulting diff and report the
validation command and outcome.

If an automatic tool changes files outside the accepted scope, the agent must
stop, inspect the diff, and either revert only its own unrelated changes or ask
for an expanded scope before continuing.
