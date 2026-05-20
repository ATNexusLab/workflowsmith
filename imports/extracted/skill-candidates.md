# Skill Candidates

Candidate reusable skills extracted from repeated legacy skill sets. These are candidates only.

## Architecture Reading

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/architecture-reading/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/architecture-reading/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/architecture-reading/SKILL.md`
- Why useful: Encourages mapping stack, boundaries, flows, and existing decisions before changing behavior.
- Destination: skill
- Promotion note: Strong near-term candidate because AxiomForge is repository-architecture oriented.

## Spec Writing

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/spec-writing/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/spec-writing/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/spec-writing/SKILL.md`
- Why useful: Standardizes ADRs, tech specs, and architecture notes before durable decisions.
- Destination: skill
- Promotion note: Promote after deciding where persistent decisions should live.

## Technical Writing

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/technical-writing/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/technical-writing/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/technical-writing/SKILL.md`
- Why useful: A source-of-truth repository depends on clear READMEs, guides, and runbooks.
- Destination: skill
- Promotion note: Good candidate once extracted docs need normalization.

## Testing Patterns

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/testing-patterns/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/testing-patterns/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/testing-patterns/SKILL.md`
- Why useful: Separates practical test strategy from the heavier mandatory test contract.
- Destination: skill
- Promotion note: Prefer this before promoting the full three-axis test contract.

## Testing Contract

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/testing-contract/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/testing-contract/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/testing-contract/SKILL.md`
- Why useful: Strong risk model for behavior, security, and performance coverage.
- Destination: checklist
- Promotion note: Extract a tiered checklist; do not promote the full mandatory table.

## Security Audit

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/security-audit/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/security-audit/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/security-audit/SKILL.md`
- Why useful: Provides severity-based review and threat-surface framing.
- Destination: skill
- Promotion note: Useful after review-code grows beyond generic correctness review.

## Web Research

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/web-research/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/web-research/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/web-research/SKILL.md`
- Why useful: Enforces primary-source validation for changing tool and API facts.
- Destination: skill
- Promotion note: Promote only if the repository starts maintaining live tool references.

## Obsidian Memory

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/obsidian-memory/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/obsidian-memory/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/obsidian-memory/SKILL.md`
- Why useful: Defines durable cross-project memory and warns against vault bloat.
- Destination: memory
- Promotion note: Extract the model, not the hardcoded Obsidian implementation.

## Domain Execution Skills

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/api-design/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/database-design/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/devops-patterns/SKILL.md`; `imports/legacy/ai-core/workflows/copilot/skills/performance-analysis/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/refactoring/SKILL.md`
- Why useful: Shows a stable domain taxonomy for API, data, DevOps, performance, and refactoring work.
- Destination: skill
- Promotion note: Defer until AxiomForge has active workflows that need those domains.

## Product And UX Skills

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/ux-specification/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/brand-identity/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/mobile-patterns/SKILL.md`; `imports/legacy/ai-core/workflows/copilot/skills/growth-marketing/SKILL.md`
- Why useful: Captures product-facing workflow intelligence that may matter for app/site work.
- Destination: skill
- Promotion note: Defer; these are not part of the current source-of-truth foundation.

## Tool Instruction Skills

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/copilot-instructions/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/claude-instructions/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/gemini-instructions/SKILL.md`
- Why useful: Encodes how to author tool-specific instruction files without duplicating global rules.
- Destination: harness adapter
- Promotion note: Useful later for export adapters back into Copilot, Claude, or Antigravity.

