<!-- topic: skill-md-format | section: skills -->
# SKILL.md Format Reference

## Quick Reference

> - A skill file must be named exactly `SKILL.md`, with matching case.
> - YAML frontmatter must be the first content in the file and must start with `---`.
> - Only `name` and `description` are officially documented engine fields, and both are required.
> - Extra frontmatter fields are allowed as user metadata but ignored by Gemini CLI's skill engine.
> - Missing, malformed, or displaced frontmatter causes the skill to be silently skipped.

## Required Filename

Gemini CLI only recognizes files named exactly `SKILL.md`. The name is case-sensitive.

These examples are valid and invalid:

| Filename | Result |
|---|---|
| `SKILL.md` | Recognized |
| `Skill.md` | Ignored |
| `skill.md` | Ignored |
| `my-skill.md` | Ignored |

## Frontmatter Rules

A valid skill file starts with YAML frontmatter fenced by `---` lines. The opening fence must be the first text in the file. There can be no blank lines, comments, or prose before it.

```markdown
---
name: my-skill
description: Use when you need a focused playbook for a specific task.
---
```

Gemini CLI silently skips the file if any of the following is true:

- The file has text before the opening `---`
- The frontmatter block is missing
- The frontmatter is malformed YAML
- A required field is missing

## Officially Documented Frontmatter Fields

Only two frontmatter fields are officially documented by the Gemini CLI skill engine.

| Field | Type | Required | Purpose |
|---|---|---|---|
| `name` | `string` | Yes | Display name used by Gemini CLI |
| `description` | `string` | Yes | Shown in `/skills list` and used for auto-activation matching |

### `name`

`name` is the skill's display identifier. In practice, most skills use a short kebab-case value because it works well in commands and matches the directory name cleanly.

### `description`

`description` tells Gemini CLI what the skill is for. The CLI shows it in skill listings, and the model may use it to decide when to auto-activate the skill for a task.

## Additional Frontmatter Fields

You may include additional metadata fields such as `triggers`, `license`, `authors`, or other custom keys. These fields are legal YAML and can be useful for humans or for conventions in your own repository.

Gemini CLI's skill discovery engine ignores those extra fields. They do not change discovery, precedence, or runtime behavior.

```yaml
---
name: web-research
description: Use when you need to validate technical claims against official documentation.
triggers:
  - "compare SDK versions"
license: MIT
---
```

In this example, `triggers` and `license` are user metadata, not official engine fields.

## Body Content

Everything after the closing frontmatter fence is arbitrary Markdown. Gemini CLI treats that Markdown body as the skill's content and injects it into the active model context when the skill is activated.

The engine does not require a specific heading structure, but the body should be written as high-signal instructional text.

## Recommended Body Structure

A practical `SKILL.md` body usually works best with this structure:

| Section | Purpose |
|---|---|
| Overview | State what the skill is for and when to use it |
| Key responsibilities | Define what the skill covers and what it does not cover |
| Step-by-step guidance | Give the operational procedure the model should follow |
| Examples | Show concrete patterns, commands, or output formats |

This structure is a writing recommendation, not an engine requirement.

## Complete Valid Example

```markdown
---
name: release-notes
description: Use when you need to draft changelog entries, release notes, or version summaries from repository changes.
triggers:
  - "write release notes"
license: MIT
---
# Release Notes Skill

## Overview

Use this skill to turn code or documentation changes into concise, user-facing release notes.

## Key Responsibilities

- Group changes under standard changelog headings.
- Call out breaking changes explicitly.
- Prefer concrete user impact over internal implementation detail.

## Procedure

1. Identify the version or change set being documented.
2. Group changes into Added, Changed, Fixed, Removed, Deprecated, or Security.
3. Write one bullet per user-visible change.
4. Keep implementation-only detail out of the summary unless it affects operators.

## Examples

- Added: OAuth login with Google and GitHub.
- Fixed: Token refresh no longer fails after daylight-saving transitions.
```

That example is valid because the file is named `SKILL.md`, the frontmatter comes first, both required fields are present, and the Markdown body follows the closing fence.
