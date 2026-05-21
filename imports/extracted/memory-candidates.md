# Memory Candidates

Memory intelligence extracted from the legacy imports. Nothing here creates active persistent memory.

## Memory Index Plus Detail Files

- Source paths: `imports/legacy/ai-core/workflows/claude/docs/memory/memory-system.md`; `imports/legacy/ai-core/workflows/claude/projects/-mnt-storage-dev-logbox/memory/MEMORY.md`; `imports/legacy/ai-core/workflows/claude/projects/-home-theo--copilot/memory/MEMORY.md`
- Why useful: Keeps memory discoverable without loading every detail file into working context.
- Destination: memory
- Promotion note: Strong candidate for WorkflowSmith memory shape if memory becomes active later.

## Why And How To Apply Structure

- Source paths: `imports/legacy/ai-core/workflows/claude/docs/memory/memory-system.md`; `imports/legacy/ai-core/workflows/claude/projects/-mnt-storage-dev-logbox/memory/feedback-backend-test-isolation.md`; `imports/legacy/ai-core/workflows/claude/projects/-mnt-storage-dev-logbox/memory/feedback-lucide-bun-cjs.md`
- Why useful: Makes each memory operational instead of a vague note by recording rationale and application conditions.
- Destination: memory
- Promotion note: Promote as a required format for any future memory item.

## Repo Documentation Versus Personal Memory Boundary

- Source paths: `imports/legacy/ai-core/workflows/copilot/skills/obsidian-memory/SKILL.md`; `imports/legacy/ai-core/workflows/claude/docs/memory/obsidian-vault.md`; `imports/legacy/ai-core/workflows/antigravity-cli/GEMINI.md`
- Why useful: Prevents project knowledge from disappearing into a private memory system.
- Destination: core policy
- Promotion note: Promote before allowing any memory writes.

## Lazy Memory Gate

- Source paths: `imports/legacy/ai-core/workflows/copilot/copilot-instructions.md`; `imports/legacy/ai-core/workflows/claude/skills/obsidian-memory/SKILL.md`; `imports/legacy/ai-core/workflows/antigravity-cli/common/routing.md`
- Why useful: Reduces overhead and avoids making memory a default dependency.
- Destination: memory
- Promotion note: Keep "read only when local context is insufficient" and discard mandatory vault reads.

## Graceful Degradation

- Source paths: `imports/legacy/ai-core/workflows/copilot/copilot-instructions.md`; `imports/legacy/ai-core/workflows/claude/docs/memory/obsidian-vault.md`; `imports/legacy/ai-core/workflows/claude/skills/obsidian-memory/SKILL.md`
- Why useful: Allows work to continue when a personal memory backend is missing or unreachable.
- Destination: memory
- Promotion note: Required if WorkflowSmith ever integrates optional memory backends.

## Stale Memory Verification

- Source paths: `imports/legacy/ai-core/workflows/claude/docs/memory/memory-system.md`; `imports/legacy/ai-core/workflows/claude/skills/obsidian-memory/SKILL.md`
- Why useful: Prevents remembered facts from overriding current repository code or documentation.
- Destination: memory
- Promotion note: Promote as "repo evidence wins over memory" if memory becomes active.

## Project-Specific Runtime Notes

- Source paths: `imports/legacy/ai-core/workflows/claude/projects/-mnt-storage-dev-logbox/memory/feedback-backend-test-isolation.md`; `imports/legacy/ai-core/workflows/claude/projects/-mnt-storage-dev-logbox/memory/feedback-lucide-bun-cjs.md`; `imports/legacy/ai-core/workflows/claude/projects/-mnt-storage-dev-Redmine-AI-Assistente/memory/feedback_commit_evidence.md`
- Why useful: Good examples of precise memory, but they belong to specific external projects, not WorkflowSmith.
- Destination: discard
- Promotion note: Use as examples of memory shape only; do not promote their domain rules.

## Local REST API Obsidian Access

- Source paths: `imports/legacy/ai-core/workflows/claude/projects/-home-theo--copilot/memory/project_obsidian-rest-api.md`; `imports/legacy/ai-core/workflows/copilot/skills/obsidian-memory/SKILL.md`
- Why useful: Documents an adapter strategy for one memory backend, including read/write split.
- Destination: harness adapter
- Promotion note: Keep as optional adapter evidence, not active WorkflowSmith memory policy.

