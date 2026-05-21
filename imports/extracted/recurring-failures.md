# Recurring Failures

Legacy patterns that are useful mostly as warnings. These items should not be promoted blindly.

## Mandatory GitHub Issue For Non-Trivial Work

- Source paths: `imports/legacy/ai-core/workflows/copilot/copilot-instructions.md`; `imports/legacy/ai-core/workflows/claude/docs/workflows/planning-protocol.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/routing.md`
- Why useful: Identifies the need for traceability on larger tasks, but the legacy form creates workflow friction and assumes GitHub is always available.
- Destination: discard
- Promotion note: Keep the traceability goal; discard the blanket "issue first" rule.

## Forced Principal Plan Before Implementation

- Source paths: `imports/legacy/ai-core/workflows/copilot/instructions/routing.md`; `imports/legacy/ai-core/workflows/claude/docs/workflows/planning-protocol.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/routing.md`
- Why useful: Shows that complex tasks benefit from explicit plans, but forced delegation conflicts with a simple source-of-truth repository.
- Destination: discard
- Promotion note: Replace with human-readable planning criteria, not mandatory agent invocation.

## Main Session Implementation Ban

- Source paths: `imports/legacy/ai-core/workflows/copilot/instructions/routing.md`; `imports/legacy/ai-core/workflows/claude/docs/workflows/routing-protocol.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/routing.md`
- Why useful: Reveals an attempt to separate orchestration from execution, but it creates unnecessary agent dependence.
- Destination: discard
- Promotion note: WorkflowSmith should prefer one principal workflow unless specialized execution is explicitly promoted.

## Mandatory Vault Preference Reads

- Source paths: `imports/legacy/ai-core/workflows/claude/CLAUDE.md`; `imports/legacy/ai-core/workflows/claude/rules/routing.md`; `imports/legacy/ai-core/workflows/claude/docs/memory/obsidian-vault.md`
- Why useful: Highlights the value of user preferences, but mandatory reads create hidden dependency on a personal vault.
- Destination: discard
- Promotion note: Promote only the lazy memory gate and graceful degradation.

## Verbose Closeout On Every Task

- Source paths: `imports/legacy/ai-core/workflows/copilot/instructions/closeout.md`; `imports/legacy/ai-core/workflows/claude/rules/closeout.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/closeout-protocol.md`
- Why useful: Makes completion criteria explicit, but the legacy output block is too heavy for small tasks.
- Destination: checklist
- Promotion note: Compress into a short final-answer checklist with optional expansion for high-risk work.

## Over-Broad Test Contract

- Source paths: `imports/legacy/ai-core/workflows/copilot/instructions/test-contract.md`; `imports/legacy/ai-core/workflows/claude/rules/test-contract.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/test-contract.md`
- Why useful: Captures strong security and performance thinking, but applies too much surface area to every implementation.
- Destination: checklist
- Promotion note: Extract tiered test guidance by risk level instead of universal mandatory coverage.

## Hook Fail-Open Assumptions

- Source paths: `imports/legacy/ai-core/workflows/copilot/docs/copilot-cli/constructs/hooks-reference.md`; `imports/legacy/ai-core/workflows/claude/docs/decisions/0003-hooks-model.md`; `imports/legacy/ai-core/workflows/antigravity-cli/docs/hooks/io-contract.md`
- Why useful: Explains why automation guardrails can silently disappear when hooks fail.
- Destination: harness adapter
- Promotion note: Any future harness should test hook failure modes explicitly before relying on them.

## Hardcoded Machine Paths

- Source paths: `imports/legacy/ai-core/workflows/antigravity-cli/hooks/worktree-cleanup.js`; `imports/legacy/ai-core/workflows/claude/projects/-home-theo--copilot/memory/project_obsidian-rest-api.md`; `imports/legacy/ai-core/workflows/copilot/skills/obsidian-memory/SKILL.md`
- Why useful: Shows operational assumptions that are not portable across machines or users.
- Destination: discard
- Promotion note: Replace with repo-relative paths, environment variables, or documented configuration only when needed.

## Agent Proliferation Pressure

- Source paths: `imports/legacy/ai-core/workflows/copilot/agents/principal.agent.md`; `imports/legacy/ai-core/workflows/claude/agents/engine.md`; `imports/legacy/ai-core/workflows/antigravity-cli/agents/creative.md`
- Why useful: The legacy system repeatedly converges on three agents, but WorkflowSmith currently needs minimal active surface.
- Destination: discard
- Promotion note: Keep as candidate evidence; do not promote extra agents until repeated WorkflowSmith tasks demand them.

