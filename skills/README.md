# Skills

This directory contains task-specific skill instructions — behavioral patterns an agent loads when a task matches a specific domain or type.

## What a Skill Is

A skill is a canonical workflow unit of `type: skill`. It provides detailed guidance for a particular kind of task: when to use it, how to execute it, and what the output should look like. A skill is loaded for the duration of a task, then unloaded.

## Skill vs. Agent

| | Skill | Agent |
|---|---|---|
| **Describes** | How to handle a specific task type | A persistent session role |
| **Loaded** | When a task matches the skill's trigger | When the agent role is selected |
| **Scope** | Duration of a specific task | Whole session |

## Directory Structure

Skills are organized into subdirectories by domain:

```
skills/
└── <domain>/
    └── <skill-name>.md
```

For example: `skills/review/review-code.md`. Use lowercase kebab-case for all directory and file names.

## Required Sections

A skill definition must include:

- **Trigger** — the conditions under which this skill should be loaded.
- **Behavior** — what the agent does when this skill is active.
- **Output** — the expected form of the result.

## Current Skills

| Domain | Skill | File |
|---|---|---|
| review | Code review | `skills/review/review-code.md` |

## Adding a Skill

1. Create a domain subdirectory if it does not exist.
2. Copy `build/schema/workflow-unit.template.md`.
3. Set `type: skill`, `status: draft`, and choose a unique `id`.
4. Write Trigger, Behavior, and Output sections.
5. Follow the content lifecycle (ADR-003) before promoting to this directory.
