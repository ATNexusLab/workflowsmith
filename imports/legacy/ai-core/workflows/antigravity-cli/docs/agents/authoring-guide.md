<!-- topic: authoring guide | section: agents -->
# Authoring Guide for Effective Agents

> **Quick Reference**
> - Put cross-project agents in `~/.gemini/agents/` and project-only agents in `.gemini/agents/`.
> - Use descriptive kebab-case filenames and keep the filename aligned with the `name` field.
> - Write the `description` field first; it is the most important part of reliable routing.
> - Start with inherited tools and restrict them only when isolation is genuinely needed.
> - Create an agent for isolated delegated work; create a skill for guidance that the parent should load and apply itself.

## Decide where the agent should live

Use location to express scope.

| Location | Choose it when | Outcome |
|---|---|---|
| `~/.gemini/agents/` | The agent is a personal utility you want available across projects | The agent is user-level and reusable everywhere |
| `.gemini/agents/` | The agent depends on one repository, one workflow, or one project's conventions | The agent is workspace-specific |

In a workspace, both locations are active. If a workspace agent and a user-level agent share the same name, the workspace version overrides the user-level version for that workspace.

## Use descriptive file naming

Name the file in **kebab-case** and keep it aligned with the `name` field.

```yaml
---
name: release-reviewer
description: Reviews release notes, version bumps, and packaging metadata before publication.
---
```

Store that agent as `release-reviewer.md`. Matching the filename and the `name` field makes manual invocation, maintenance, and discovery simpler.

## Write the description field first

`description` is the most critical authoring decision because Gemini CLI reads it for automatic dispatch.

### What a strong description includes

A strong description names:

- The domain it handles
- The task types it should receive
- The output or decision it is expected to produce

### What weak descriptions look like

Avoid descriptions such as `general purpose helper`, `does many engineering tasks`, or `use for anything complex`. Those descriptions are too vague to route reliably.

### Example: weak versus strong

| Weak | Strong |
|---|---|
| `General purpose release helper.` | `Reviews release notes, version bumps, and packaging metadata before publication.` |
| `Frontend agent.` | `Audits web UI changes for accessibility regressions, interaction bugs, and missing responsive states.` |

## Choose tools with a bias toward sufficiency

Start by omitting `tools`, which means the agent inherits all parent tools. Restrict tool access only when the agent needs deliberate isolation, such as read-only review, externally constrained execution, or a compliance boundary.

Use explicit restriction when the limitation is part of the agent's purpose. For example, a review-only agent may intentionally omit write-capable tools.

Even when you grant `tools: ["*"]`, recursive subagent invocation remains blocked.

## Choose a model only when there is a clear reason

If the default parent model is already appropriate, leave `model` unset. Set `model` only when the agent's workload consistently benefits from a different trade-off.

| Model choice | Good fit |
|---|---|
| Faster or cheaper model | Classification, triage, repetitive batch transforms, or narrow formatting work |
| Parent default or stronger model | Ambiguous tasks, long-form synthesis, architectural reasoning, or quality-sensitive review |

Once an agent sets `model`, that model applies to the subagent run. The parent session's `--model` flag does not override it.

## Write the body as if the agent starts cold

Subagents do not inherit the parent `GEMINI.md` context automatically. Write the Markdown body so the agent can operate correctly without hidden assumptions. Include the minimum essential policy, scope, and output contract the worker needs every time it runs.

Good agent bodies usually define:

- What the agent is responsible for
- What it must not do
- What shape the result should take
- Any special safety or quality rules that are unique to that worker

## Decide whether you need an agent or a skill

Agents and skills solve different problems.

| Use an agent when... | Use a skill when... |
|---|---|
| You want a specialized worker with its own isolated context | You want the parent session to load a playbook or framework and then act directly |
| The task benefits from delegation or parallelism | The task benefits from guidance, checklists, or domain rules inside the current session |
| The worker may need its own tool or model policy | The parent should keep control and apply the framework itself |

A useful rule is: if the work should happen in a separate worker, create an agent. If the work should remain in the parent but follow a structured method, create a skill.

## Common antipatterns

### Vague descriptions that cause routing failures

If the router cannot tell why an agent exists, it will not select it reliably.

### Over-restricting tools so the agent cannot do its job

Tool restrictions should enforce intent, not accidentally sabotage the worker.

### Creating an agent for work that should be a skill

If the parent session should keep the context and simply follow a framework, author a skill instead of adding delegation overhead.

### Forgetting that subagents do not inherit parent context

Hidden assumptions in the parent session become silent failures in the subagent. If the agent needs a policy every time, write it into the agent body.

## Minimal agent template

```yaml
---
name: release-reviewer
description: Reviews release notes, version bumps, and packaging metadata before publication.
tools: ["*"]
temperature: 0.1
timeout_mins: 15
---

# Release Reviewer

You review release artifacts for consistency.

Required output:
- version consistency check
- missing release-note items
- packaging or distribution risks
```

## Validate the agent after writing it

Test the agent with an explicit `@agent-name` invocation and a small, representative task. If routing matters, also test a natural-language request that should select the agent automatically. Tight feedback on description quality is the fastest way to improve an agent definition.
