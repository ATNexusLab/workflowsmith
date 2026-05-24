# ADR-0005: Instructions, Agents, And Skills

## Status

Accepted

## Context

WorkflowSmith needs precise names for the behavioral material that modern AI
software engineering harnesses expose as local instructions, agent roles, and
skills or reusable capabilities.

ADR-0004 established that the canonical workflow must support local
instructions, project guidance, memory, skills, rules, and recovery mechanisms.
It did not define the boundary between those concepts.

Without a boundary, instructions, agents, and skills tend to become large
mixed-purpose files. That makes review difficult, hides product decisions in
assistant tooling, and creates repeated cleanup work to split oversized files
after they already exist.

The workflow also needs a policy for automatic fixes. Useful automation such as
formatters and linter autofix should be allowed, but not in a way that mixes
unrelated cleanup into product changes.

## Decision

WorkflowSmith will treat `instruction`, `agent`, and `skill` as explicit
canonical workflow unit kinds.

An instruction is durable behavior guidance with broad or high-precedence
effect. It governs how work is performed.

An agent is an execution role with a responsibility, scope, available resources,
handoff obligations, and completion criteria. Agents follow instructions and may
use skills.

A skill is a specialized capability invoked by a trigger. It defines when to use
the capability, what inputs it needs, how to perform the work, what output is
expected, and how the result is validated.

Canonical source remains modular. Harness distributions translate canonical
units into harness-native surfaces and must preserve traceability back to the
canonical source. A distribution is not a parallel product authority.

Automatic formatting and linter fixes are allowed by default only within the
accepted scope of work or files touched for that work. Broad cleanup requires a
separate issue, accepted scope, or explicit authorization.

Canonical authoring must keep units small. Oversized units require an explicit
size-budget exception so reviewers can see why the unit was not split.

## Consequences

- The workflow unit schema includes `instruction`, `agent`, and `skill`.
- Future workflow content should use those names directly instead of mapping
  them through generic policy, role, or procedure names.
- The canonical source can define reusable behavior without assuming any
  particular Codex, Claude, Cursor, Devin, Windsurf, Copilot, or other harness
  file layout.
- Harness contracts and distributions must document how these unit kinds map to
  harness-native instruction, agent, skill, rule, memory, or command surfaces.
- Validation enforces basic modularity budgets for canonical source units.
