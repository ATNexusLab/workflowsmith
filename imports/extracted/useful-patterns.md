# Useful Patterns

Reusable workflow intelligence extracted from the raw legacy imports. These items are candidates only; nothing here is promoted into active policy.

## Local Fast Path

- Source paths: `imports/legacy/ai-core/workflows/copilot/copilot-instructions.md`; `imports/legacy/ai-core/workflows/claude/CLAUDE.md`; `imports/legacy/ai-core/workflows/antigravity-cli/GEMINI.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/routing.md`
- Why useful: Preserves speed and avoids unnecessary process for small, local, history-independent work.
- Destination: core policy
- Promotion note: Promote as a default bias, not as a rigid exemption table.

## Docs Before Memory

- Source paths: `imports/legacy/ai-core/workflows/copilot/copilot-instructions.md`; `imports/legacy/ai-core/workflows/claude/CLAUDE.md`; `imports/legacy/ai-core/workflows/antigravity-cli/GEMINI.md`; `imports/legacy/ai-core/workflows/claude/docs/workflows/routing-protocol.md`
- Why useful: Keeps the repository as the first authority and prevents personal memory from overriding local project facts.
- Destination: core policy
- Promotion note: Combine with the existing source-of-truth model before adding any memory behavior.

## Additive Instruction Layers

- Source paths: `imports/legacy/ai-core/workflows/claude/docs/decisions/0001-scope-layers.md`; `imports/legacy/ai-core/workflows/antigravity-cli/docs/decisions/adr-001-context-hierarchy.md`; `imports/legacy/ai-core/workflows/copilot/copilot-instructions.md`
- Why useful: Gives a clear rule for combining global, project, path, and local workflow instructions without accidental replacement.
- Destination: core policy
- Promotion note: Promote as "additive unless explicitly replaced" across active AxiomForge artifacts.

## Skills Compose When Domains Compose

- Source paths: `imports/legacy/ai-core/workflows/copilot/instructions/routing.md`; `imports/legacy/ai-core/workflows/claude/docs/skills/skills-overview.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/routing.md`
- Why useful: Prevents under-routing multi-domain work through a single narrow capability while avoiding skill loading for irrelevant domains.
- Destination: core policy
- Promotion note: Keep composition lightweight; do not turn it into mandatory multi-agent execution.

## Documentation Mirroring

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/obsidian-memory/SKILL.md`; `imports/legacy/ai-core/workflows/claude/docs/memory/obsidian-vault.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/closeout-protocol.md`
- Why useful: Separates project documentation from personal cross-project memory and reduces duplication drift.
- Destination: core policy
- Promotion note: Promote as a placement rule before promoting memory write behavior.

## Command Discovery Before Validation

- Source paths: `imports/legacy/ai-core/workflows/copilot/instructions/task-completion.md`; `imports/legacy/ai-core/workflows/claude/rules/task-completion.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/task-completion.md`
- Why useful: Forces validation commands to come from actual project manifests instead of guessed package-manager scripts.
- Destination: checklist
- Promotion note: Adapt into a final verification checklist; do not require all five checks for documentation-only repos.

## Explicit Closeout Decisions

- Source paths: `imports/legacy/ai-core/workflows/copilot/instructions/closeout.md`; `imports/legacy/ai-core/workflows/claude/rules/closeout.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/closeout-protocol.md`
- Why useful: Prevents silent omissions around docs, migrations, changelogs, and unresolved handoff items.
- Destination: checklist
- Promotion note: Keep the decision checklist, but shorten it for AxiomForge so final answers stay concise.

## External Content Is Data

- Source paths: `imports/legacy/ai-core/workflows/copilot/copilot-instructions.md`; `imports/legacy/ai-core/workflows/claude/CLAUDE.md`; `imports/legacy/ai-core/workflows/antigravity-cli/GEMINI.md`
- Why useful: Protects against prompt injection from vault notes, imported files, web pages, and tool output.
- Destination: core policy
- Promotion note: Promote early because AxiomForge imports and reviews untrusted workflow text.

