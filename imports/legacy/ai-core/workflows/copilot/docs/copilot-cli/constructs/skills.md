# Skills

Label: **Official reference** with **generic adaptation** notes

Skills are task-specific instruction modules that Copilot can load when they are relevant. They are a lighter-weight way to add workflow intelligence than a custom agent, and a more targeted tool than always-on custom instructions.

## What a skill is

Official docs define a skill as a folder containing a `SKILL.md` file and, optionally, scripts or other resources that Copilot can use while the skill is active.

The Agent Skills specification is an open standard, so the concept is intentionally portable across multiple AI systems.

## Supported locations

| Scope | Official locations |
| --- | --- |
| Project | `.github/skills/`, `.claude/skills/`, `.agents/skills/` |
| Personal | `~/.copilot/skills/`, `~/.agents/skills/` |

The command reference also lists additional discovery locations such as plugin directories and extra paths from `COPILOT_SKILLS_DIRS`.

## Required structure

Each skill lives in its own subdirectory. Official guidance recommends lowercase directory names with hyphens.

Minimum structure:

```text
skills/
  my-skill/
    SKILL.md
```

Requirements for `SKILL.md`:

- file name must be exactly `SKILL.md`
- Markdown body with YAML frontmatter
- required frontmatter fields: `name`, `description`
- optional fields include `license` and, in command-reference material, `allowed-tools`, `user-invocable`, and `disable-model-invocation`

## Scripts and resources

When a skill is invoked, Copilot discovers the files inside the skill directory and makes them available alongside the instructions.

That means a skill can include:

- helper scripts
- examples
- supplementary Markdown
- reference data needed for the workflow

If you pre-approve tools in the skill frontmatter with `allowed-tools`, official docs warn to do so carefully. Pre-approving `shell` or `bash` removes an approval boundary and can let a compromised skill or prompt injection run commands without the usual confirmation step.

## How skills are used

Skills can be used in two ways:

- automatic invocation when Copilot judges the skill relevant from its description
- explicit invocation by naming the skill in a prompt or through `/skills` commands

Useful CLI commands include:

- `/skills list`
- `/skills info SKILL-NAME`
- `/skills reload`
- `/skills add`
- `/skills remove`

## Skill versus custom instructions

Use custom instructions when the guidance should apply to almost every task.

Use a skill when:

- the instructions are detailed enough to be distracting if always loaded
- the workflow only matters for certain task types
- you want a reusable procedure with optional resources or scripts

## Generic adaptation guidance

When translating from another ecosystem, a skill is often the right target when the foreign surface looks like one of these:

- a named procedure or playbook
- a reusable review or debugging workflow
- a task-specific style guide
- a prompt module that should not shape every session

If the foreign construct adds new executable capability rather than a new workflow, it is usually closer to an MCP server than a skill.

## Repo example

This repository has a populated [skills](../../skills) tree. It is a good example of a personal skill library under `~/.copilot`, but its contents are still repo-local examples rather than official defaults.

## Sources

- [Adding agent skills for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills)
- [About agent skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)