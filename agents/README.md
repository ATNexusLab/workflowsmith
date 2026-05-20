# Agents

This directory contains agent profile definitions — canonical descriptions of AI agent roles used in AxiomForge workflows.

## What an Agent Definition Is

An agent definition is a canonical workflow unit of `type: agent`. It describes a specific agent role: what the agent is responsible for, what rules it operates under, and what its default behavior is when no specialized skill is active.

An agent definition does NOT contain task-specific instructions — those belong in skills. An agent definition describes the role; a skill describes the behavior for a particular type of task.

## Agent vs. Skill

| | Agent | Skill |
|---|---|---|
| **Describes** | A persistent role and its operating rules | A task-specific behavior pattern |
| **Loaded** | When the agent is selected for a session | When a task matches the skill's trigger |
| **Scope** | Whole session | Duration of a specific task |

## Required Fields

An agent definition must include these sections in its Markdown body:

- **Responsibility** — what this agent is accountable for.
- **Operating Rules** — explicit constraints on the agent's behavior.
- **Default Behavior** — what the agent does when no skill is active.

## Current Agents

- `principal.md` — the default agent for AxiomForge workflow work. Used when no more specific agent is selected.

## Adding an Agent

1. Copy `build/schema/workflow-unit.template.md`.
2. Set `type: agent`, `status: draft`, and choose a unique `id`.
3. Write Responsibility, Operating Rules, and Default Behavior sections.
4. Follow the content lifecycle (ADR-003) before promoting to this directory.
5. Update `core/routing-policy.md` if the agent should be selectable by name.
