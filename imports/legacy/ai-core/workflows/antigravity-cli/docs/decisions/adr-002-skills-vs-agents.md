<!-- type: adr | section: decisions -->
# ADR-002: Skills vs Agents: Capability Separation

**Status:** Accepted  
**Date:** 2025

## Context

Gemini CLI exposes two extension mechanisms that both customize model behavior: **skills** and **agents**. They can appear similar because both are written as markdown-backed artifacts and both affect how work is performed. In practice, they solve different architectural problems.

A **skill** is passive knowledge injection. It teaches the model a pattern, method, or workflow by loading a `SKILL.md` document into context.

An **agent** is an active execution unit. It runs as a subprocess with its own tool permissions, model selection, and turn budget so it can perform work independently of the parent session.

Without a hard separation, the extension model becomes harder to reason about. Users would not know whether an artifact merely changes reasoning or is allowed to execute tools and consume a separate model budget.

## Decision

Gemini CLI maintains a strict capability boundary:

### Skills teach

Skills are passive instruction bundles.

- A skill is defined by a file named exactly `SKILL.md`.
- The file must include frontmatter with at least `name` and `description`.
- A skill describes how to perform a technique, follow a pattern, or evaluate a task.
- A skill has no subprocess, no tool execution, and no independent runtime budget.
- Skills are loaded by model-directed activation or by extension packaging.

In short, a skill changes what the model knows.

### Agents do

Agents are active execution units.

- An agent is defined by a markdown file in `.gemini/agents/` or `~/.gemini/agents/` with YAML frontmatter.
- Agent frontmatter may define `name`, `description`, `kind`, `tools`, `model`, `max_turns`, and related execution controls.
- Agents receive their own context window, tool access policy, and model call budget.
- Agents are invoked to perform work, not merely to describe it.
- Subagents cannot invoke other subagents. Recursion protection is unconditional.
- Agents do not inherit the parent session's `GEMINI.md` context automatically.

In short, an agent changes what can execute.

This separation is the architectural contract: use a skill when the system needs reusable guidance, and use an agent when the system needs bounded autonomous execution.

## Consequences

- ✅ The mental model is explicit: skills teach, agents do.
- ✅ Security review is simpler because tool access exists only on the agent side.
- ✅ Skills are cheap when inactive because they do not create subprocesses or consume a separate execution budget.
- ✅ Agents can be tightly scoped through frontmatter-defined tool allowlists and runtime settings.
- ⚠️ Skills cannot automate anything by themselves; workflows that require action must route through an agent.
- ⚠️ Agent definitions must be context-complete because parent session instructions are not inherited.
- ⚠️ Recursion protection prevents agent trees; orchestration must stay in the main session.

## Alternatives Considered

### Unified plugin model

A single plugin abstraction would reduce the number of concepts users must learn.

It was rejected because it conflates passive knowledge with active execution. That would blur the security model, the performance model, and the user's expectations around what a plugin is allowed to do.

### Make skills executable

Skills could have been extended so they also declare tools and run tasks directly.

It was rejected because the purpose of a skill is declarative guidance. Turning skills into executors would make activation side effects harder to audit and would duplicate the role already served by agents.

### Make agents the only extension point

The system could require every customization to be packaged as an agent.

It was rejected because many concerns are instructional rather than operational. Requiring a subprocess and tool contract for every reusable workflow would add unnecessary complexity and cost.
