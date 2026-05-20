# Routing Candidates

Routing intelligence extracted from the legacy imports. These candidates should be reviewed before any promotion.

## Fast Path Then Gates

- Source paths: `imports/legacy/ai-core/workflows/copilot/instructions/routing.md`; `imports/legacy/ai-core/workflows/claude/rules/routing.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/routing.md`
- Why useful: Provides a simple order: handle trivial local work directly, then check docs, then consider memory and skills.
- Destination: core policy
- Promotion note: Strong first promotion candidate after removing mandatory issue and agent steps.

## Project Documentation Gate

- Source paths: `imports/legacy/ai-core/workflows/copilot/copilot-instructions.md`; `imports/legacy/ai-core/workflows/claude/docs/workflows/routing-protocol.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/routing.md`
- Why useful: Makes local repo documents the first source of constraint before using broader workflow context.
- Destination: core policy
- Promotion note: Promote as a low-overhead read-minimum rule.

## Lazy Context Gate

- Source paths: `imports/legacy/ai-core/workflows/copilot/copilot-instructions.md`; `imports/legacy/ai-core/workflows/claude/docs/memory/obsidian-vault.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/routing.md`
- Why useful: Defines when historical context is useful without making it automatic.
- Destination: memory
- Promotion note: Promote only after AxiomForge has a concrete memory backend or explicit memory import rules.

## Additive Local Skills

- Source paths: `imports/legacy/ai-core/workflows/claude/docs/skills/skills-overview.md`; `imports/legacy/ai-core/workflows/copilot/skills/copilot-instructions/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/GEMINI.md`
- Why useful: Clarifies that local skills narrow or extend baseline behavior instead of replacing it silently.
- Destination: core policy
- Promotion note: Good fit for `core/routing-policy.md` later, but do not modify core in this extraction step.

## Domain To Skill Mapping

- Source paths: `imports/legacy/ai-core/workflows/copilot/instructions/routing.md`; `imports/legacy/ai-core/workflows/claude/docs/workflows/routing-protocol.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/routing.md`
- Why useful: Repeated mapping shows stable task domains: architecture, backend/data, infra, security, testing, performance, docs, UX, and research.
- Destination: skill
- Promotion note: Convert to a candidate catalog, not mandatory routing.

## Main Session Orchestration Boundary

- Source paths: `imports/legacy/ai-core/workflows/copilot/copilot-instructions.md`; `imports/legacy/ai-core/workflows/claude/CLAUDE.md`; `imports/legacy/ai-core/workflows/antigravity-cli/docs/agents/authoring-guide.md`
- Why useful: Keeps recursive delegation and hidden agent trees out of the workflow.
- Destination: core policy
- Promotion note: Promote the non-recursive boundary without requiring subagents.

## Review And Audit Read-Only Route

- Source paths: `imports/legacy/ai-core/workflows/claude/agents/engine.md`; `imports/legacy/ai-core/workflows/antigravity-cli/agents/engine.md`; `imports/legacy/ai-core/workflows/copilot/.github/prompts/run-audit.prompt.md`
- Why useful: Distinguishes analysis/review from implementation and reduces accidental edits during audits.
- Destination: skill
- Promotion note: Fold into `skills/review/review-code.md` later if desired.

## Tool-Specific Instruction Adapters

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/copilot-instructions/SKILL.md`; `imports/legacy/ai-core/workflows/claude/skills/claude-instructions/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/skills/gemini-instructions/SKILL.md`
- Why useful: Shows how one source-of-truth workflow could be exported into different client instruction formats.
- Destination: harness adapter
- Promotion note: Defer until AxiomForge starts generating or syncing tool-specific outputs.

## Mandatory Planning Gate

- Source paths: `imports/legacy/ai-core/workflows/copilot/instructions/routing.md`; `imports/legacy/ai-core/workflows/claude/docs/workflows/planning-protocol.md`; `imports/legacy/ai-core/workflows/antigravity-cli/hooks/plan-first.js`
- Why useful: Encodes traceability and scope control, but is too intrusive as a default.
- Destination: discard
- Promotion note: Keep as cautionary evidence; do not promote the hook or GitHub issue mandate.

