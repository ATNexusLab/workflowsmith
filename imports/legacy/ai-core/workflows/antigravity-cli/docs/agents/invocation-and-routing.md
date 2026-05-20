<!-- topic: invocation and routing | section: agents -->
# Agent Invocation and Routing

> **Quick Reference**
> - `@agent-name` forces a specific agent, regardless of description quality.
> - Automatic routing reads all agent descriptions and chooses the best match.
> - The parent delegates work; the subagent returns with `complete_task`.
> - Multiple agents can run in the same turn when the work is parallelizable.
> - Fleet-style fan-out always starts from the parent because subagents cannot recurse.

## Explicit invocation

`@agent-name` is the direct invocation syntax. When you use it, Gemini CLI invokes that named agent even if another agent would have been a better automatic match.

```text
@release-reviewer Check whether the changelog and version bump are internally consistent.
```

Use explicit invocation when you already know which specialist you want, when you are testing an agent, or when you need deterministic routing.

## Implicit automatic routing

Gemini CLI can invoke an agent automatically from natural-language requests. It does this by reading the `description` field of every available agent and selecting the best match.

Automatic routing is only as good as the descriptions it can compare. If two agents sound equally broad, routing quality drops. If one agent names the exact task types it handles, that agent is more likely to be selected correctly.

## Writing descriptions for reliable routing

Good routing starts with a specific `description` field.

### Be concrete about what the agent handles

Name the domain, the artifact, and the kind of output.

| Better description | Why it routes well |
|---|---|
| `Reviews dependency updates, lockfile changes, and package version conflicts before release.` | Names the inputs and the decision context |
| `Maps service dependencies and traces likely root causes for backend failures.` | Names the system shape and the troubleshooting outcome |

### List specific task types

Spell out the classes of work the agent should receive, such as `API schema review`, `release note editing`, or `UI accessibility audit`.

### Avoid vague descriptions

Descriptions like `general purpose`, `helps with many tasks`, or `does engineering work` give the router little signal. Those descriptions make auto-dispatch unreliable.

## Parent-to-subagent communication

The parent session owns orchestration. The communication contract is simple:

1. The parent chooses an agent explicitly or through auto-routing.
2. The parent delegates the task into the subagent's isolated context.
3. The subagent performs the work.
4. The subagent calls `complete_task` with its result.
5. The parent resumes with that returned output in its own context.

`complete_task` output flows back to the parent context as the handoff boundary between worker and orchestrator.

## Parallel dispatch

Gemini CLI can invoke multiple agents in the same turn when the work can be split into independent tracks. Common examples include codebase analysis by subsystem, documentation review by chapter, or batch triage across many files.

Parallel dispatch works best when each agent gets:

- A narrow, independent scope
- Clear acceptance criteria
- No shared mutable state that would require turn-by-turn coordination

## Fleet pattern

A **fleet pattern** is parent-driven fan-out: the parent dispatches `N` agents in parallel for batch work, waits for each result, and then merges the returned outputs.

Typical fleet uses include:

- Reviewing a large batch of changes by directory or service
- Researching multiple sources in parallel
- Transforming many independent documents with the same output contract

Because recursion protection is unconditional, the fleet pattern always starts from the parent session. A subagent cannot dispatch another layer of subagents, even if its tool list looks unrestricted.
