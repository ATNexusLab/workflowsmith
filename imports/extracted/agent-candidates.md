# Agent Candidates

Candidate roles found in the legacy imports. These are not promoted active agents.

## Principal

- Source paths: `imports/legacy/ai-core/workflows/copilot/agents/principal.agent.md`; `imports/legacy/ai-core/workflows/claude/agents/principal.md`; `imports/legacy/ai-core/workflows/antigravity-cli/agents/principal.md`
- Why useful: The role consistently handles bootstrap, specs, plans, ambiguity surfacing, and closeout validation as document work rather than implementation.
- Destination: agent
- Promotion note: Already aligns with `agents/principal.md`; future promotion should refine the existing principal instead of adding a new one.

## Engine

- Source paths: `imports/legacy/ai-core/workflows/copilot/agents/engine.agent.md`; `imports/legacy/ai-core/workflows/claude/agents/engine.md`; `imports/legacy/ai-core/workflows/antigravity-cli/agents/engine.md`
- Why useful: Consolidates backend, data, infra, security, performance, testing, and review into one technical execution role.
- Destination: agent
- Promotion note: Defer. Useful if WorkflowSmith later needs a technical worker profile, but promoting it now would violate the minimal-agent constraint.

## Creative

- Source paths: `imports/legacy/ai-core/workflows/copilot/agents/creative.agent.md`; `imports/legacy/ai-core/workflows/claude/agents/creative.md`; `imports/legacy/ai-core/workflows/antigravity-cli/agents/creative.md`
- Why useful: Separates UX, frontend, brand, copy, mobile, and human-facing documentation concerns from general technical execution.
- Destination: agent
- Promotion note: Defer. Keep as evidence for future product/UX-heavy workflows.

## Main Session As Orchestrator

- Source paths: `imports/legacy/ai-core/workflows/copilot/copilot-instructions.md`; `imports/legacy/ai-core/workflows/claude/CLAUDE.md`; `imports/legacy/ai-core/workflows/antigravity-cli/GEMINI.md`
- Why useful: Establishes that orchestration should remain centralized and that subagents should not recursively delegate.
- Destination: core policy
- Promotion note: Promote the boundary, not the automatic dispatch machinery.

## Read-Only Review Mode

- Source paths: `imports/legacy/ai-core/workflows/claude/agents/engine.md`; `imports/legacy/ai-core/workflows/antigravity-cli/agents/engine.md`; `imports/legacy/ai-core/workflows/copilot/agents/engine.agent.md`
- Why useful: Review and audit modes explicitly report findings without editing, which matches safe review behavior.
- Destination: agent
- Promotion note: Fold into review skill or principal behavior before creating a separate agent.

