# Instructions and Prompt Assets

Label: **Official reference** with **generic adaptation** notes

Last checked: `2026-05-20`

This page distinguishes the confirmed file-based and workflow-packaging surfaces used by VS Code Chat.

## Primary chooser

| If you need... | Primary construct | Why |
| --- | --- | --- |
| one repository-wide, always-on instruction file | `.github/copilot-instructions.md` | Canonical repository-wide instructions |
| rules that apply only to some files or tasks | `*.instructions.md` | Conditional instruction surface with `applyTo` and task matching |
| a shared always-on compatibility file recognized across multiple coding agents | `AGENTS.md` | Canonical compatibility surface for VS Code Chat |
| a named reusable workflow you invoke on demand | `.prompt.md` prompt file | Reusable task asset, not always-on guidance |
| a persistent persona with specific tools, models, or handoffs | custom agent (`.agent.md`) | Packages a role-based workflow |
| a portable capability pack with instructions, scripts, and resources | agent skill (`SKILL.md`) | Packages reusable capability across VS Code, Copilot CLI, and cloud agent |

## Confirmed surfaces

| Construct | Scope | Trigger | Key notes |
| --- | --- | --- | --- |
| `.github/copilot-instructions.md` | repository/workspace | automatic on every chat request | best default for project-wide conventions |
| `*.instructions.md` | file class, folder, or task | automatic when `applyTo` or semantic matching applies; can also be added manually | usually stored under `.github/instructions`; VS Code allows configurable locations |
| `AGENTS.md` | cross-agent compatibility surface | automatic | nested behavior differs across sources, so keep it scoped carefully |
| `.prompt.md` | workspace or user profile | manual invocation from chat, typically as `/<prompt name>` | can declare name, description, agent, model, and tools |
| `.agent.md` | workspace or user profile | manual agent selection or handoff | packages instructions, tools, models, handoffs, and optional subagent constraints |
| `SKILL.md` in a skill directory | workspace or user profile | manual slash invocation or automatic relevance loading | packages instructions plus optional scripts and resources |

## Baseline instruction surfaces

### Repository and path-specific instructions

GitHub Docs confirm two repository-native instruction families for IDE chat:

- repository-wide instructions in `.github/copilot-instructions.md`
- path-specific instructions in `.github/instructions/**/*.instructions.md`

If a request matches both the repository-wide file and a path-specific file, both can be used.

### VS Code instruction authoring details

VS Code docs add the authoring details that matter for actual usage:

- multiple instruction files can be combined
- `*.instructions.md` files use optional YAML frontmatter such as `applyTo`
- if `applyTo` is missing, a `*.instructions.md` file is not applied automatically
- the References section and diagnostics can help confirm which instruction files were loaded

VS Code docs also define the default instruction locations:

| Scope | Default locations |
| --- | --- |
| workspace | `.github/instructions` |
| workspace compatibility rules | `.claude/rules` |
| user profile | `~/.copilot/instructions`, `~/.claude/rules`, or profile-specific user data |

VS Code can sync user instructions across devices with Settings Sync.

### Instruction precedence boundaries

Official sources define useful precedence boundaries:

- VS Code docs describe the broad priority as **user-level instructions > repository instructions > organization instructions**
- GitHub Docs describe the repository-level precedence as **path-specific `*.instructions.md` > `.github/copilot-instructions.md` > agent instructions such as `AGENTS.md`**

What remains intentionally less strict is the merge order between multiple files of the same class. VS Code docs do not promise a deterministic merge order for several matching instruction files.

## Prompt files

Prompt files are not another name for instructions.

- Use **instructions** to bias behavior automatically.
- Use **prompt files** to package a named task you run intentionally.

VS Code docs treat prompt files as Markdown files with the `.prompt.md` extension and optional frontmatter. Confirmed frontmatter fields include:

- `description`
- `name`
- `argument-hint`
- `agent`
- `model`
- `tools`

Prompt file storage and discovery:

| Scope | Default locations |
| --- | --- |
| workspace | `.github/prompts` |
| user profile | profile-specific user data |

VS Code can also:

- configure more workspace prompt locations
- discover parent-repository prompt files in a monorepo
- sync user prompt files with Settings Sync

Prompt files can appear in chat as slash-invoked prompts, and tools specified in the prompt file take priority over tool lists inherited from a referenced custom agent or default agent behavior.

## Custom agents

Custom agents are reusable personas defined in `.agent.md` files.

Use a custom agent when you need:

- a persistent role or persona
- a constrained tool list or tool-set selection
- a preferred model
- explicit handoff buttons into another workflow step
- a curated set of allowed subagents

Default custom-agent locations:

| Scope | Default locations |
| --- | --- |
| workspace | `.github/agents` |
| workspace compatibility format | `.claude/agents` |
| user profile | `~/.copilot/agents` or profile-specific user data |

Custom agents are especially useful when the workflow is more than a single prompt file and needs role continuity or guided handoffs.

## Agent skills

Agent skills are portable capability packs stored in skill directories with a `SKILL.md` file.

Use a skill when you need:

- reusable capability rather than only guidance
- scripts, examples, or extra resources alongside instructions
- portability across VS Code, Copilot CLI, and cloud agent
- optional forked-context execution so the capability can run without polluting the parent conversation

Default skill locations:

| Scope | Default locations |
| --- | --- |
| project | `.github/skills`, `.claude/skills`, `.agents/skills` |
| user profile | `~/.copilot/skills`, `~/.claude/skills`, `~/.agents/skills` |

Skills are workflow-building surfaces, not baseline always-on chat guidance.

## Compatibility and discovery surfaces

VS Code docs also describe additional surfaces that matter in the editor:

- `CLAUDE.md` as an always-on compatibility file
- `.claude/rules` as a Claude-format rule directory that uses `paths` instead of `applyTo`
- organization-level instructions discovered from GitHub when enabled in VS Code settings

Treat these as **VS Code-documented compatibility or discovery surfaces**. Do not silently treat them as the same thing as the baseline repository instruction surfaces.

At the time of writing, GitHub's support matrix for VS Code Chat explicitly calls out `AGENTS.md`, while VS Code docs additionally document `CLAUDE.md`, `.claude/rules`, and organization-level discovery in the editor. Treat that difference as a version-sensitive divergence, not as proof of cross-surface parity.

## Authoring helpers

VS Code docs confirm these authoring shortcuts:

- `/init` to generate or update workspace-wide instructions
- `/create-instruction` to generate a targeted `*.instructions.md` file
- `/create-prompt` to generate a reusable `.prompt.md` file
- `/create-skill` to generate a reusable skill directory

These are helpers, not separate customization families.

## Recommended first-pass usage

1. Start with `.github/copilot-instructions.md` for project-wide rules.
2. Add `*.instructions.md` when different folders, languages, or task classes need different guidance.
3. Add `.prompt.md` when a workflow should be invoked explicitly and reused by name.
4. Add a custom agent when the workflow needs a stable persona, constrained tools, or handoff buttons.
5. Add a skill when the capability should be portable across multiple Copilot agent surfaces or needs scripts and extra resources.
6. Treat `CLAUDE.md`, `.claude/rules`, and organization-level instructions as version-sensitive compatibility or discovery surfaces, not as first-line defaults.

## Sources

- [Adding repository custom instructions for GitHub Copilot in your IDE](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions-in-your-ide/add-repository-instructions-in-your-ide)
- [Support for different types of custom instructions](https://docs.github.com/en/copilot/reference/custom-instructions-support)
- [About customizing GitHub Copilot responses](https://docs.github.com/en/copilot/concepts/prompting/response-customization)
- [Use custom instructions in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [Use prompt files in VS Code](https://code.visualstudio.com/docs/copilot/customization/prompt-files)
- [Create custom agents in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [Use agent skills in VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
