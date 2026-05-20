# Skills Reference

> **Migration note:** This section remains the detailed reference for skill mechanics, but Antigravity-first readers should start from [../antigravity-cli/workflow-authoring.md](../antigravity-cli/workflow-authoring.md) to decide where new workflow behavior belongs and use [../antigravity-cli/index.md](../antigravity-cli/index.md) for the preferred navigation layer and migration guidance.

This section explains how Gemini CLI discovers, activates, and authors `SKILL.md` files for its on-demand skills system.

## Quick Reference

> - Skills are on-demand instructional modules, not ambient project memory.
> - Only files named exactly `SKILL.md` are considered skills.
> - Workspace skills require `/trust` before Gemini CLI can activate them.
> - Use `/skills` in-session to inspect and manage active skills.
> - Use the task table below to load the right reference page quickly.

## Load by Task

| Load when you need to… | Module |
|---|---|
| Understand what skills are and how they differ from GEMINI.md/agents | [fundamentals.md](fundamentals.md) |
| Understand SKILL.md frontmatter fields | [skill-md-format.md](skill-md-format.md) |
| Understand how skills are discovered and which path wins | [discovery-and-precedence.md](discovery-and-precedence.md) |
| Install, activate, or manage skills | [commands-reference.md](commands-reference.md) |
| Write an effective SKILL.md | [authoring-guide.md](authoring-guide.md) |
