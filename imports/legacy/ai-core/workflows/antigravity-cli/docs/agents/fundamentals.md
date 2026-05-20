<!-- topic: fundamentals | section: agents -->
# Agents Fundamentals

> **Quick Reference**
> - An agent is a Markdown file with YAML frontmatter plus instructions that define a specialized worker.
> - A subagent runs in its own context window; the parent context, including parent `GEMINI.md`, is not inherited.
> - Gemini CLI uses agents for delegation, parallelism, and specialization.
> - The only documented discovery paths are `.gemini/agents/*.md` and `~/.gemini/agents/*.md`.
> - Subagents finish with `complete_task` and cannot invoke other subagents.

## What agents and subagents are

An **agent** is a Markdown file that defines a reusable worker. The file starts with YAML frontmatter that declares metadata such as the agent name, description, model, and tool scope. The Markdown body below the frontmatter is the agent's operating instruction.

A **subagent** is that agent running on behalf of a parent session. The parent decides to delegate work, the subagent executes the task in isolation, and then the subagent returns its result to the parent.

```yaml
---
name: release-reviewer
description: Reviews release notes and checks versioning changes before publication.
---
```

## Isolation model

Each subagent runs in its **own context window**. The parent session does not stream its current working memory into the child. That isolation has three practical consequences:

1. The parent must delegate with enough context for the subagent to succeed.
2. The subagent does **not** inherit the parent `GEMINI.md` context automatically.
3. Tool access is scoped per agent, not assumed from the parent session.

Isolation is a feature, not a limitation. It prevents accidental prompt bleed, keeps specialist instructions focused, and allows parallel work without the parent context becoming noisy.

## Why agents exist

Gemini CLI uses agents for three main reasons.

### Delegation

The parent session can hand a bounded task to a worker that was written specifically for that task type.

### Parallelism

The parent can dispatch multiple agents in the same turn when work can be split into independent units.

### Specialization

An agent can carry narrow instructions, a tool policy, and model settings that fit one class of work better than a general session prompt.

## Discovery and precedence

Gemini CLI documents exactly two agent discovery paths:

| Scope | Documented path | Typical use |
|---|---|---|
| Workspace | `.gemini/agents/*.md` | Project-specific agents that only make sense inside one repository or workspace |
| User level | `~/.gemini/agents/*.md` | Personal agents available across projects |

No other path is documented in this reference. In particular, `~/.agents/` is **not** an official path for this documentation set.

Both discovery tiers are active in a workspace. If user-level and workspace agents have different names, both are available. If they share the same name, the workspace definition overrides the user-level definition inside that workspace.

## Invocation modes

Gemini CLI can invoke an agent in two ways.

### Explicit invocation

Use `@agent-name` to force a specific agent. This bypasses description matching and tells Gemini CLI exactly which worker to run.

### Natural-language dispatch

Gemini CLI can also choose an agent automatically by reading agent descriptions and selecting the best match for the current request. Description quality is therefore part of the routing contract, not just documentation.

## Parent and subagent lifecycle

The parent session owns orchestration. A typical flow is:

1. The parent selects an agent explicitly or through automatic routing.
2. Gemini CLI starts the subagent in an isolated context.
3. The subagent performs the delegated work with its scoped tools.
4. The subagent calls `complete_task` to return the result.
5. The parent session resumes and continues from the returned result.

`complete_task` is **exclusive to subagents**. It is the mechanism a subagent uses to hand control and results back to the parent.

## Recursion protection

Subagents cannot invoke other subagents. This recursion block is unconditional and remains in force even when an agent has `tools: ["*"]` or otherwise appears to have full tool access.

The parent may dispatch several agents in parallel, but every fan-out starts from the parent session. A subagent cannot create its own child fleet.
