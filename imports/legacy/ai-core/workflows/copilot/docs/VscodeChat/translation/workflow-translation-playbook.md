# Workflow Translation Playbook

Label: **Generic adaptation**

Last checked: `2026-05-20`

Use this page when you need to translate a workflow or part of a workflow from another AI tool into confirmed VS Code Chat constructs.

Use [construct-selection-matrix.md](construct-selection-matrix.md) for single-construct mapping. Use this page for the full translation procedure.

## Translation method

### 1. Describe the source flow in tool-agnostic terms

Describe the source workflow without using product branding first. Break it into primitives such as:

- ambient guidance
- conditional guidance
- named task
- specialist persona
- portable capability pack
- action or tool bridge
- execution loop
- review boundary
- rollback surface
- audit trail
- concurrent work model

### 2. Map each primitive to a confirmed VS Code Chat target

Use the [construct selection matrix](construct-selection-matrix.md) and the official reference pages to map each source primitive into a confirmed VS Code Chat construct.

### 3. Classify the mapping

For each mapped primitive, mark one of these:

- **Direct**
- **Weaker**
- **Compatibility / discovery**
- **No equivalent**

This is where you stop false parity from entering the documentation.

### 4. Recompose the workflow natively

After mapping the pieces, rebuild the workflow using VS Code Chat constructs that actually exist:

- instructions
- prompt files
- custom agents
- skills
- participants
- tools and MCP
- sessions, handoffs, and subagents
- review and debug surfaces

Use the [workflow composition playbook](../composition/workflow-composition-playbook.md) for this step.

### 5. Record the gaps

If a source capability has no clean VS Code Chat equivalent:

- document the gap explicitly
- decide whether the target needs a manual step, a weaker substitute, or a repo-local convention
- never imply that the feature exists just because the workflow needs it

### 6. Validate with runtime inspection

Before treating the translation as complete, use the runtime surfaces that prove the workflow behaved as expected:

- pending-change review
- checkpoints
- Agent Debug Log panel
- Chat Debug view

## Common non-equivalences

### GitHub.com personal instructions are not VS Code user instructions

If the source system has website-level personal instructions, do not map that directly onto VS Code user-level instruction files.

### Compatibility files are not baseline parity

If a source system has `CLAUDE.md`-style compatibility files, treat those as VS Code-documented compatibility surfaces, not as proof that the same construct is part of GitHub's baseline support matrix.

### Handoff and subagent solve different problems

If a source tool has a visible phase transition into another worker, start with **handoff**. If it has hidden delegated work inside one broader task, start with **subagents**.

### Capability packs and personas are different

If the source system distinguishes reusable capability from reusable persona:

- map persona to **custom agent**
- map capability pack to **agent skill**

### No equivalent must stay visible

If a source system has a capability with no confirmed VS Code Chat equivalent, keep the gap visible instead of hiding it behind a misleading nearest match.

## Target packaging chooser

| If the translated result needs... | Prefer... |
| --- | --- |
| always-on project rules | instructions |
| a reusable task entrypoint | prompt file |
| a reusable persona with controlled tools or handoffs | custom agent |
| a portable capability with scripts or examples | skill |
| external system access | MCP |
| a manual concurrent work split | multiple chat sessions |
| isolated delegated work within one broader task | subagents |

## Applying translation to this repository

When the target is this `.copilot` environment:

1. translate the foreign flow into official VS Code Chat constructs first
2. only then encode repo-local policy, naming, and orchestration as local convention
3. keep the repo-local example separate from the generic translation rule

That keeps the atlas reusable while still making it useful for building workflows here.

## Sources

- [Use custom instructions in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [Use prompt files in VS Code](https://code.visualstudio.com/docs/copilot/customization/prompt-files)
- [Create custom agents in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [Use agent skills in VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Use tools with agents](https://code.visualstudio.com/docs/copilot/agents/agent-tools)
- [Manage chat sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)
- [Debug chat interactions](https://code.visualstudio.com/docs/copilot/chat/chat-debug-view)
