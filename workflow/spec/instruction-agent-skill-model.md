# Instruction, Agent, And Skill Model

## Metadata

- id: `instruction-agent-skill-model`
- kind: `contract`
- status: `draft`
- version: `0.1.0`
- owner: `WorkflowSmith`

## Purpose

WorkflowSmith separates always-on behavior, execution roles, and specialized
capabilities so workflow content stays reviewable and harness-agnostic.

## Canonical Unit Types

### Instruction

An instruction is durable behavior guidance with broad or high-precedence
effect.

Use an instruction for rules that should apply across many tasks, agents, or
skills, such as planning before execution, preserving unrelated user changes,
reporting validation, and respecting project authority.

An instruction must not contain a long task procedure, harness-specific command
surface, or specialized workflow that only applies in narrow cases.

### Agent

An agent is an execution role.

Use an agent when WorkflowSmith needs a named responsibility with boundaries,
available resources, handoff expectations, and completion criteria.

An agent must follow applicable instructions and may invoke skills. It must not
be a storage place for broad behavior rules or reusable procedures that belong
in instructions or skills.

### Skill

A skill is a specialized capability invoked by a clear trigger.

Use a skill for reusable procedures such as writing an ADR, reviewing a pull
request, validating a user interface, consulting a documentation source, or
preparing release notes.

A skill must define:

- when to use it;
- required inputs or context;
- the operating procedure;
- expected output;
- validation or closeout requirements.

## Translation Rule

Canonical units describe product behavior. Harness distributions translate those
units into harness-native surfaces such as instruction files, command files,
role prompts, skill directories, rules, memory, or connector configuration.

The distribution must preserve traceability to the canonical source. It must not
become an independent source of product behavior.
