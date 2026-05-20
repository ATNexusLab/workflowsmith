# Workflow Translation Method

Label: **Generic adaptation**

This page is the operational method for translating a workflow or workflow fragment from another AI tool into supported GitHub Copilot CLI constructs.

Boundary notes:

- Foreign tools are translation inputs, not authorities for this atlas.
- This method does **not** assume one-to-one feature parity.
- When Copilot CLI has no supported equivalent, the correct result is an explicit gap, not an invented mapping.

## What you should produce

For each translated workflow, end with a compact design record that states:

1. the Copilot CLI runtime shape
2. the Copilot CLI constructs involved
3. the permission and trust model
4. the automation and handoff path
5. any partial or missing equivalence

## Step 1: Decompose the foreign workflow into neutral parts

Do not start by mapping filenames or brand terms. First rewrite the workflow in neutral operational language.

Use this worksheet:

| Part to extract | Questions to answer |
| --- | --- |
| Goal | What outcome is the workflow trying to produce? |
| Entry point | Is it interactive, scripted, editor-driven, remote, or CI/CD-triggered? |
| Guidance layer | What instructions are always on versus task-specific? |
| Capability layer | What tools, services, or external context does it rely on? |
| Execution model | Is work done by one agent, a specialist, or delegated workers? |
| Trust model | What file, shell, URL, or system permissions does it assume? |
| Review model | Who approves plans, changes, or output? |
| Output | Session output, patch, transcript, PR, report, or automation result? |

If one foreign file mixes multiple concerns, split it before mapping. In Copilot CLI, one source artifact often becomes several surfaces.

## Step 2: Map each part to the right Copilot CLI layer

Use the official construct model, not superficial naming matches.

| Neutral part | Primary Copilot CLI target | Use when |
| --- | --- | --- |
| Always-on conventions | Custom instructions | Guidance should shape most or all work in a scope |
| File- or class-specific rules | `.instructions.md` files | Guidance should apply only to matching files |
| Named reusable workflow | Skill | The workflow should load on demand or by relevance |
| Specialist definition | Custom agent | The workflow needs a distinct specialist profile or tool set |
| Delegated isolated execution | Subagent | The main context should offload work or run it in parallel |
| External system or new executable capability | MCP server | Copilot needs tools it does not already have |
| Lifecycle enforcement or policy callback | Hook | Behavior must be controlled at runtime, not only suggested |
| Packaged reusable distribution | Plugin | Multiple surfaces must ship together |
| Editor-linked operation | VS Code connection or LSP | The workflow depends on editor state or language intelligence |
| External client/server control | ACP server | Copilot CLI must be embedded or controlled programmatically as an agent server |

Use the supporting matrix for faster first-pass matching: [Construct selection matrix](construct-selection-matrix.md).

## Step 3: Choose the runtime shape

After construct mapping, decide how the workflow should actually run.

| Runtime shape | Prefer when | Watch for |
| --- | --- | --- |
| Interactive `copilot` session | The workflow needs iterative steering, approvals, review, or session continuity | Human-in-the-loop behavior is part of the design |
| Interactive plan mode | A plan should be approved before implementation | Plan mode is a phase, not a full workflow architecture |
| Interactive autopilot mode | The workflow benefits from more autonomous continuation | Pair with explicit trust decisions |
| Prompt mode `copilot -p` | The task is one-shot, scripted, CI/CD, or machine-consumed | Prompt mode does not inherit all repository-controlled surfaces by default |
| IDE-connected interactive workflow | Editor selection, diff review, or diagnostics are central | Keep IDE-specific behavior grounded in official integration pages |
| ACP server mode | Another client needs to drive Copilot CLI over stdio or TCP | This is an integration architecture, not a shortcut for missing CLI features |
| Remote control | A running interactive session needs approval or steering from elsewhere | Remote control is only for active interactive sessions, not prompt mode |

## Step 4: Translate trust and permission assumptions

Many foreign workflows hide trust decisions inside defaults. Make them explicit in Copilot CLI.

Check each permission family separately:

| Permission family | Questions | Copilot CLI surface |
| --- | --- | --- |
| File reads and writes | What paths must be visible or editable? | launch directory, `/add-dir`, `--add-dir`, write approvals |
| Shell execution | Which commands are required, and how broad can approval be? | built-in shell tools, `--allow-tool`, `--deny-tool`, approval prompts |
| URL access | Which domains or endpoints are actually required? | `--allow-url`, `--deny-url` |
| MCP tool use | Which external tools are necessary? | MCP config plus allow or deny filters |
| User interruption | May the run pause for clarification? | interactive mode or `--no-ask-user` in prompt mode |
| Broad autonomy | Is full autonomy truly required? | `--allow-all`, `--allow-all-tools`, autopilot, remote approvals |

Translation rule:

- if the foreign workflow depends on silent full access, mark that as a **trust divergence**
- then redesign it with the minimum official Copilot CLI approvals that still achieve the goal

Important prompt-mode boundary:

- repository-controlled extensions, repo hooks, and workspace MCP sources are disabled in prompt mode unless explicitly enabled through the documented environment variables

## Step 5: Translate automation and orchestration

Map the workflow's execution environment, not just its prompt text.

| Foreign workflow need | Copilot CLI-native translation |
| --- | --- |
| Local one-shot script | `copilot -p ...` with explicit output format, model, and permissions |
| CI/CD task | Prompt mode plus explicit non-interactive flags and authentication setup |
| GitHub Actions job | Official Actions pattern with `COPILOT_GITHUB_TOKEN` |
| IDE-side orchestration | VS Code connection or ACP, depending on who controls the session |
| Language-aware assistance | LSP server configuration |
| Long-running interactive work with later approvals | interactive session plus remote control |

If the foreign system relies on unsupported background orchestration semantics, document that as partial equivalence and keep the translation grounded in the official Copilot CLI execution surfaces above.

## Step 6: Translate review, handoff, and delivery

Do not stop at task execution. Map how work is inspected and handed off.

| Workflow need | Copilot CLI surface |
| --- | --- |
| Approve a plan before editing | `/plan` or plan-mode start |
| Review file changes locally | `/diff` |
| Ask for a structured review pass | `/review` |
| Track delegated or background work | `/tasks` and subagent/task surfaces |
| Resume or revisit prior work | `--continue`, `--resume`, `/resume`, `/session` |
| Export or share session evidence | `/share`, `/export`, `--share`, `--share-gist` |
| Create or manage a PR | `/pr` |
| Hand work to a remote repository flow | `/delegate` |

## Step 7: Mark non-equivalence explicitly

Use one of these outcomes for every major foreign construct:

| Outcome | Meaning |
| --- | --- |
| Equivalent | A documented Copilot CLI surface covers the need directly |
| Partial | The need is covered through a composition, but behavior differs |
| No equivalent | No supported Copilot CLI surface covers the need today |

Common no-equivalent or partial-equivalent cases:

- a foreign single file that bundles instructions, policy, tools, and automation
- hidden global permissions with no approval boundary
- remote control of one-shot prompt-mode execution
- undocumented event systems or extension hooks not present in official Copilot CLI docs
- assumptions that persona selection and delegated execution are the same thing

## Suggested output template

Use this structure when publishing a translated workflow:

| Field | Record |
| --- | --- |
| Goal | |
| Runtime shape | |
| Copilot CLI constructs | |
| Permission model | |
| Automation path | |
| Review and handoff path | |
| Equivalent / partial / none | |
| Notes on divergence | |

## Sources

- [Customization taxonomy](../constructs/customization-taxonomy.md)
- [Construct selection matrix](construct-selection-matrix.md)
- [Runtime modes, sessions, and permissions](../reference/runtime-modes-sessions-and-permissions.md)
- [Commands and official command surface](../reference/commands-and-official-command-surface.md)
- [Tools, permissions, and safety controls](../reference/tools-permissions-and-safety-controls.md)
- [Programmatic use and automation](../reference/programmatic-use-and-automation.md)
- [Custom agents and subagents](../constructs/custom-agents-and-subagents.md)
- [Skills](../constructs/skills.md)
- [LSP, ACP, and remote control](../integrations/lsp-acp-and-remote-control.md)
- [VS Code connection](../integrations/vs-code-connection.md)
