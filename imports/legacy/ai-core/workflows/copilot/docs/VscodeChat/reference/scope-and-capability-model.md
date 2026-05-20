# Scope and Capability Model

Label: **Official reference** with **generic adaptation** notes

Last checked: `2026-05-20`

This page frames GitHub Copilot Chat in VS Code as a set of confirmed capability layers rather than as a single undifferentiated chat box.

## What this atlas is about

The scope here is **GitHub Copilot Chat in VS Code**:

- chat entry points and working surfaces inside VS Code
- Ask, Plan, and Agent roles plus agent targets and permission levels
- explicit context, tools, participants, and slash commands
- repository-scoped, workspace-scoped, compatibility, and organization customization assets
- prompt files, custom agents, and agent skills
- MCP, model selection, review, sessions, and debugging

It is **not** a general atlas for GitHub.com chat or every other Copilot surface.

## Capability layers

| Layer | Confirmed VS Code Chat surfaces | What it does |
| --- | --- | --- |
| Conversation surface | Chat view, inline chat, Quick Chat, editor-tab or detached session views | Hosts the conversation and gives you a working surface |
| Session shape | Agent target, session model, permission level | Decides where the work runs and how autonomous it is |
| Execution role | Ask, Plan, Agent | Changes whether the interaction is explanatory, planning-oriented, or autonomous |
| Context | Automatic workspace context, `#` context items, `@` participants, URLs, images, browser elements, browser tools | Shapes what the model sees for a request |
| Persistent guidance | `.github/copilot-instructions.md`, `*.instructions.md` | Adds the core reusable repository and file-scoped conventions confirmed across the main VS Code Chat support references |
| Cross-agent compatibility guidance | `AGENTS.md` | Adds a shared instruction surface across agents, with nested resolution behavior that differs between GitHub Docs and VS Code docs |
| VS Code-documented compatibility guidance | `CLAUDE.md`, `.claude/rules`, organization-level instructions | Adds editor-native compatibility or discovery surfaces that should be revalidated against GitHub support matrices when documentation drifts |
| Reusable request asset | `.prompt.md` prompt files | Packages a repeatable task, optionally with an agent, model, and tools |
| Persona package | `.agent.md` custom agents | Packages a reusable role with tools, models, and handoffs |
| Portable capability package | `SKILL.md` agent skills | Packages reusable capability plus scripts or resources across multiple Copilot agent surfaces |
| Action capability | Built-in tools, extension tools, MCP tools | Lets the agent read, edit, run, fetch, and integrate |
| Model control | Model picker, thinking effort, auto model selection | Tunes reasoning behavior and model choice |
| Review and recovery | Pending changes, edit review, checkpoints | Lets you keep, reject, revert, or fork results |
| Observability | Agent Debug Log panel, Chat Debug view | Shows what context, prompts, and tools were actually used |

## Choose the construct by intent

| If your goal is... | Lead with... | Why |
| --- | --- | --- |
| Pick the right working surface | chat location or session view | Chat view, inline chat, Quick Chat, editor tabs, and detached windows do different jobs |
| Ask a question or request an explanation | Ask | lowest-overhead conversational surface |
| Produce a plan before changing code | Plan | keeps planning distinct from autonomous editing |
| Let Copilot work through a coding task end to end | Agent | enables iterative edits and tool use |
| Force specific workspace context into the prompt | `#` context items | explicit context beats inference when precision matters |
| Route a question to a domain specialist | `@` participant | participants are the specialist conversation surface |
| Apply project conventions to every request | `.github/copilot-instructions.md` | core always-on guidance |
| Apply rules only to some files or tasks | `*.instructions.md` | core conditional instruction surface |
| Share instructions across multiple coding agents | `AGENTS.md` | cross-agent compatibility surface; nested resolution differs by source |
| Reuse a named workflow on demand | `.prompt.md` prompt file | reusable request asset, slash-runnable |
| Reuse a role with fixed tools or handoffs | custom agent | stable persona surface for a workflow phase |
| Reuse a portable capability with resources | agent skill | best when the asset is a capability rather than a persona |
| Add external tools or data | MCP server | extends the tool surface |
| Change reasoning profile or provider | model picker or Auto | model layer, not instruction layer |
| Audit what happened | debug surfaces | confirms prompts, tools, and context actually used |

VS Code docs also describe compatibility or discovery surfaces such as `CLAUDE.md`, `.claude/rules`, and organization-level instructions. Treat them as editor-specific add-ons and revalidate them against GitHub support matrices before relying on them as a baseline VS Code Chat workflow.

## Important distinctions

### Prompt file is not the same as instructions

- **Instructions** are guidance that can be automatically added to requests.
- **Prompt files** are named task assets you run intentionally.

### Custom agent is not the same as skill

- A **custom agent** packages a reusable persona, tools, models, and handoffs.
- A **skill** packages reusable capability, often with scripts or extra resources, and can be portable across multiple agent surfaces.

### Participant is not the same as a tool

- **Participants** handle domain-specific conversation.
- **Tools** perform actions inside an agent flow.

### Role is not the same as model

- **Role** changes the interaction pattern.
- **Model** changes the underlying language model behavior.

## Explicit non-equivalences

- Do not infer GitHub.com personal instructions into VS Code Chat.
- Do not assume GitHub Docs alone define VS Code-native inventories like chat locations, participants, checkpoints, or debug view.
- Do not treat preview surfaces as stable long-term contracts.

## Sources

- [About GitHub Copilot Chat](https://docs.github.com/en/copilot/concepts/chat)
- [Asking GitHub Copilot questions in your IDE](https://docs.github.com/en/copilot/how-tos/chat-with-copilot/chat-in-ide)
- [Chat overview](https://code.visualstudio.com/docs/copilot/copilot-chat)
- [Use custom instructions in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [Create custom agents in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [Use agent skills in VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Using agents in Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/overview)
- [Use tools with agents](https://code.visualstudio.com/docs/copilot/agents/agent-tools)
