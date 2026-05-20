# Construct Selection Matrix

Label: **Generic adaptation**

Last checked: `2026-05-20`

Use this page for **single-construct mapping**. Use [workflow-translation-playbook.md](workflow-translation-playbook.md) when the foreign system has a full multi-step flow.

## Primary mapping table

| If the foreign flow has... | VS Code Chat target | Why |
| --- | --- | --- |
| ambient project-wide rules | `.github/copilot-instructions.md` | canonical always-on repository instructions |
| conditional rules by file type, folder, or task | `*.instructions.md` | canonical conditional instruction surface |
| personal reusable guidance across workspaces | user-level instructions | editor-native personal instruction surface |
| a shared cross-agent compatibility file | `AGENTS.md` | canonical compatibility surface called out in GitHub support references |
| a compatibility file documented only by VS Code | `CLAUDE.md` or `.claude/rules` | VS Code-documented compatibility surface, not a baseline GitHub support-matrix construct |
| a named reusable task | `.prompt.md` prompt file | reusable task asset that runs from chat |
| a persistent specialist persona with restricted tools or handoffs | custom agent | packages role, tools, models, and handoffs |
| a portable capability pack with scripts or resources | agent skill | packages reusable capability across agent surfaces |
| a quick action invoked by name in chat | slash command | runtime shortcut surface |
| a domain expert assistant | `@` participant | specialist conversation-routing surface |
| a plan-first workflow step | Plan | dedicated planning role |
| an autonomous implementation loop | Agent + tools + permissions | confirmed execution surface for multi-step work |
| a standard Q&A or explanation flow | Ask | lowest-friction conversational role |
| an external tool or service bridge | MCP server | adds tools and external context |
| a need to pin model behavior per reusable task | prompt file or custom-agent frontmatter | reusable model and tool packaging surface |
| a full-batch undo point | checkpoint or edit previous request | request-level rollback surfaces |
| a request audit trail | Agent Debug Log panel or Chat Debug view | observability and payload inspection |
| coordinated parallel work inside one broader workflow | subagents | isolated or parallel delegation inside the broader task |
| unrelated isolated work threads | multiple chat sessions | separate timelines and context windows |

## Non-equivalence classes

When translating, classify each mapping before you treat it as final:

| Class | Meaning |
| --- | --- |
| **Direct** | VS Code Chat has a clear native construct with similar behavior |
| **Weaker** | VS Code Chat has a partial equivalent, but with less power or more manual assembly |
| **Compatibility / discovery** | VS Code documents the construct, but it is not a baseline cross-surface default |
| **No equivalent** | the source system has no confirmed VS Code Chat counterpart |

## Important non-equivalences

### Prompt file is not always-on instructions

If another system has a reusable prompt asset, map it to a **prompt file**, not to repository instructions. Prompt files are invoked. Instructions are ambient.

### Participant is not tool parity

If another system has named assistants, first ask whether they are:

- a **conversation-routing** construct -> participant
- an **action capability** construct -> tool, tool set, or MCP server

They are not interchangeable.

### Handoff is not subagent

If another system has a visible phase transition into a new worker or environment, map it to **handoff** first. Use **subagents** when the delegated work should stay inside the broader task instead of becoming a new session.

### Session is not checkpoint

If another system has whole-thread branching, map it to **forking a session**. If it has request-level rollback, map that to **checkpoints** or **edit previous request**.

### Compatibility file is not baseline instruction parity

If another system has a compatibility file that VS Code recognizes, document it as a **compatibility or discovery surface**, not as proof that it is a first-line baseline construct in GitHub's support matrix.

## Use this matrix with the other pages

- Use [workflow-composition-playbook.md](../composition/workflow-composition-playbook.md) when you already know the parts and want to compose a new workflow.
- Use [workflow-translation-playbook.md](workflow-translation-playbook.md) when you need a full translation procedure with gap handling.

For native construct explanations, start with:

- [Chat surfaces and context](../reference/chat-surfaces-and-context.md)
- [Instructions and prompt assets](../constructs/instructions-and-prompt-assets.md)
- [Modes, participants, and tools](../constructs/modes-participants-and-tools.md)
- [MCP and models](../constructs/mcp-and-models.md)
- [Review, debug, and sessions](../integrations/review-debug-and-sessions.md)
