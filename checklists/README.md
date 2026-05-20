# Checklists

This directory contains reusable completion and review checklists.

## What a Checklist Is

A checklist is a canonical workflow unit of `type: checklist`. It is a short, ordered list of items to verify before declaring a task or output complete. Checklists are used at the end of a workflow step — they do not describe how to do the work, only how to confirm it was done correctly.

## Checklist vs. Skill

| | Checklist | Skill |
|---|---|---|
| **When used** | End of a task, before finalizing output | During a task, to guide execution |
| **Format** | Ordered list of checkable items | Narrative instructions with decision rules |
| **Output** | Pass/fail confirmation | Behavioral guidance |

Use a checklist when you need to verify a completed result. Use a skill when you need guidance on how to perform a task.

## Format

Checklists are Markdown files with canonical frontmatter (see `build/schema/workflow-unit.template.md`). The body is an ordered list of items written as statements to confirm, not questions to answer.

## Current Checklists

- `final-answer.md` — checklist to run before giving a final answer in any workflow task.

## Adding a Checklist

1. Copy `build/schema/workflow-unit.template.md`.
2. Set `type: checklist`, `status: draft`, and choose a unique `id`.
3. Write the body as an ordered list of confirmation statements.
4. Follow the content lifecycle (ADR-003) before promoting to this directory.
