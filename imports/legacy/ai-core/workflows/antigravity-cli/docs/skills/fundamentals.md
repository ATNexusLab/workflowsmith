<!-- topic: fundamentals | section: skills -->
# Skills Fundamentals

## Quick Reference

> - A skill is a Markdown instruction document with YAML frontmatter that Antigravity CLI loads on demand.
> - `GEMINI.md` is ambient and always loaded; a skill is activated only when needed.
> - Agents run in isolated context windows; skills add specialized guidance to the current session.
> - A skill is not a subagent: it cannot call tools, execute code, or own runtime state.
> - Antigravity CLI uses the internal `activate_skill` tool to load a skill, and loaded skills survive context compression.

## What a Skill Is

A skill is a `SKILL.md` file: a Markdown instruction document with YAML frontmatter that packages specialized procedural knowledge for Antigravity CLI. When the CLI activates a skill, it injects that file's body into the model's context so the current session gains a focused playbook for the task at hand.

Use skills for knowledge that is too detailed to keep in always-on instructions but valuable enough to load when a matching task appears. Typical examples include framework-specific workflows, security audit checklists, documentation playbooks, and domain procedures.

## Skills vs. GEMINI.md

`SKILL.md` and `GEMINI.md` solve different context problems.

| Mechanism | Loading model | Best for |
|---|---|---|
| `GEMINI.md` | Ambient: loaded automatically as persistent session context | Persona, repository-wide conventions, durable rules, and always-needed guidance |
| `SKILL.md` | On demand: loaded only when a skill is activated | Deep specialist playbooks, complex procedures, and task-specific frameworks |

The practical difference is scope and timing. `GEMINI.md` is always part of the session's baseline behavior. A skill is added only when Antigravity CLI or the user explicitly activates it.

## Skills vs. Agents

Skills and agents are also different mechanisms.

| Mechanism | Context model | Execution model | Best for |
|---|---|---|---|
| Skill | Injected into the current session's context | No independent execution | Giving the current session a framework, checklist, or procedure |
| Agent | Runs in an isolated context window | Independent delegated work | Parallel research, scoped implementation, or large tasks that benefit from separation |

A skill changes how the current session thinks. An agent creates another worker with its own context window.

## A Skill Is Not a Subagent

A skill is purely instructional text. It has no execution context, cannot invoke tools, cannot inspect the filesystem by itself, and cannot run in parallel as a delegated worker.

This matters operationally: activating a skill does not create a new actor. It only loads guidance into the existing session so the current model can follow that playbook while using the tools already available to the session.

## Activation and Runtime Behavior

Antigravity CLI loads skills through the internal `activate_skill` tool. That mechanism is what actually reads the selected `SKILL.md` content and places it into the model's active context.

A skill can be activated in two ways:

- Manually, when the user runs a skill activation command.
- Automatically, when Antigravity CLI decides a skill's description matches the current task.

Once loaded, the skill lives in the system context layer rather than as ordinary conversational text. Because of that placement, an active skill survives context compression and remains available after the session trims older conversation history.

## When to Use Skills

Skills are most useful when the task needs specialized guidance but does not need a separate worker.

| Use case | Why a skill fits |
|---|---|
| Complex procedural knowledge | A skill can encode a step-by-step playbook that would be noisy in always-on instructions |
| Specialized domains | A skill can hold domain-specific checklists, terminology, and decision rules |
| Framework workflows | A skill can capture how to work effectively with a specific tool, framework, or documentation format |

Use a skill when you want the current session to adopt a framework. Use another mechanism when you need persistent ambient rules or an isolated execution context.
