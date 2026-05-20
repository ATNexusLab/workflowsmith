<!-- topic: authoring-guide | section: skills -->
# Authoring Guide

## Quick Reference

> - Put personal reusable skills in `~/.gemini/skills/<name>/SKILL.md` and workspace-only skills in `.gemini/skills/<name>/SKILL.md`.
> - Keep the `<name>` directory aligned with the `name` frontmatter value, preferably in kebab-case.
> - Write `description` as a task matcher: say what problem the skill solves and when to use it.
> - Keep skills focused; if a skill grows past roughly 500 lines, split it into narrower skills.
> - Use a skill for on-demand procedural knowledge, not for always-on rules or isolated delegated execution.

## Choose the Right Location

Choose the skill's location based on scope.

| Location | Use when |
|---|---|
| `~/.gemini/skills/<name>/SKILL.md` | The skill is personal and should be available across projects |
| `.gemini/skills/<name>/SKILL.md` | The skill is specific to one workspace or repository |

A workspace skill is appropriate when the playbook depends on repository conventions, local tooling, or team-specific procedures. A user-global skill is appropriate when the knowledge is reusable across many projects.

## Align Directory Name and Skill Name

Use the same kebab-case value for both the directory name and the `name` frontmatter field whenever possible.

| Element | Recommended value |
|---|---|
| Directory | `web-research/` |
| Frontmatter `name` | `web-research` |

This is a convention, not an engine requirement, but it keeps discovery, commands, and maintenance predictable.

## Write a Description for Auto-Activation

The `description` field is the most important authoring decision because Gemini CLI shows it in skill listings and may use it to auto-activate the skill.

### Description Rules

- Be specific about the problems the skill solves.
- Use `Use when...` or `Activate for...` phrasing.
- Name the task types or scenarios explicitly.
- Prefer concrete terms over vague claims like "helps with many things."

### Example Descriptions

| Quality | Example |
|---|---|
| Strong | `Use when you need to validate technical claims against official documentation, compare API versions, or confirm SDK behavior.` |
| Weak | `Helpful research skill for many tasks.` |

A strong description improves both manual discoverability and automatic matching.

## Structure the Body for Action

The body of `SKILL.md` should read like a high-signal playbook.

| Body element | What it should do |
|---|---|
| Brief intro | Explain what the skill is for and when it should be loaded |
| Step-by-step guide | Tell the model exactly how to approach the task |
| Examples and patterns | Show concrete output formats, commands, or decision patterns |
| Key principles or constraints | Capture non-negotiable rules, quality bars, or exclusions |

A good skill gives the model an operational procedure, not just background information.

## Keep Skills Focused

Skills should be narrow enough that loading them is cheap and relevant. If a skill grows beyond roughly 500 lines, split it into smaller skills by task boundary.

Examples of healthy splits:

- Separate API design guidance from database migration guidance.
- Separate security audit procedures from performance benchmarking procedures.
- Separate authoring rules for one documentation artifact from another unrelated artifact.

## Skill vs. Agent

Choose a skill when the current session needs a playbook. Choose an agent when the task needs its own isolated worker.

| Choose | When |
|---|---|
| Skill | You need procedural knowledge, a checklist, or a reference framework loaded into the parent context |
| Agent | You need isolated execution, separate context, delegation, or parallel work |

A skill teaches the current session how to work. An agent performs work in a different context window.

## Skill vs. GEMINI.md

Choose a skill when the knowledge is specialized and only relevant for certain task types. Choose `GEMINI.md` when the guidance should always be present.

| Choose | When |
|---|---|
| `GEMINI.md` | The rule is ambient: persona, repository conventions, or always-needed instructions |
| Skill | The rule is deep but conditional: specialist knowledge loaded only when needed |

A useful test is frequency: if the guidance should shape nearly every prompt, it belongs in `GEMINI.md`, not in a skill.

## Common Antipatterns

| Antipattern | Why it fails |
|---|---|
| Missing or malformed frontmatter | Gemini CLI silently skips the skill |
| Text before the opening `---` | Gemini CLI silently skips the skill |
| Vague description | Auto-activation becomes unreliable or activates the wrong skill |
| Oversized skill | The skill bloats context and becomes harder to maintain |
| Using a skill for always-needed context | The guidance belongs in `GEMINI.md`, not in an on-demand module |

A good skill is discoverable, specific, scoped, and cheap to load.
