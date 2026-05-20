# Claude Code — Documentation Index

Claude Code is Anthropic's official CLI for interacting with Claude models in a software engineering context. It is configured through instruction files, extended via skills and agents, automated through hooks, and integrated with external tools via MCP servers.

```
CLI (claude)
  └── reads CLAUDE.md (5 scope layers)
        └── loads Skills (domain expertise)
              └── routes to Agents (@engine / @creative / @principal)
                    └── uses Tools (Read, Edit, Bash, Agent, MCP...)
                          └── writes to Memory (project + Obsidian vault)
```

---

## Navigation

### Core Configuration
| File | What it covers |
|---|---|
| [core/claude-md-format.md](core/claude-md-format.md) | CLAUDE.md format, `@-import` syntax, scope hierarchy, and sections template |
| [core/settings-json.md](core/settings-json.md) | settings.json schema: hooks, permissions, statusLine, theme |
| [core/scope-layers.md](core/scope-layers.md) | How the 5 instruction layers stack and interact |
| [core/context-management.md](core/context-management.md) | Context window, plan mode, /fast, /loop, compression |

### Agents
| File | What it covers |
|---|---|
| [agents/agents-overview.md](agents/agents-overview.md) | What agents are, isolation modes, model selection, invocation syntax |
| [agents/agent-format.md](agents/agent-format.md) | Agent `.md` frontmatter schema and body structure |
| [agents/agent-roster.md](agents/agent-roster.md) | The 3 built-in agents: @engine, @creative, @principal |

### Skills
| File | What it covers |
|---|---|
| [skills/skills-overview.md](skills/skills-overview.md) | Skill system, routing protocol, composition, global vs local |
| [skills/skill-format.md](skills/skill-format.md) | SKILL.md frontmatter and body structure |
| [skills/skills-catalog.md](skills/skills-catalog.md) | All 19 global skills — trigger, agent, deliverable |

### Rules
| File | What it covers |
|---|---|
| [rules/rules-overview.md](rules/rules-overview.md) | Path-specific rules, `paths:` frontmatter, additive layering |
| [rules/rules-catalog.md](rules/rules-catalog.md) | The 4 mandatory global rules: routing, task-completion, test-contract, closeout |

### Commands
| File | What it covers |
|---|---|
| [commands/commands-overview.md](commands/commands-overview.md) | Built-in and custom slash commands, discovery, `$ARGUMENTS` |
| [commands/custom-commands.md](commands/custom-commands.md) | Creating custom commands with real examples |
| [commands/commands-catalog.md](commands/commands-catalog.md) | All known built-in commands and the 4 global custom commands |

### Hooks
| File | What it covers |
|---|---|
| [hooks/hooks-overview.md](hooks/hooks-overview.md) | Hook lifecycle, event types, input/output JSON contract |
| [hooks/hooks-patterns.md](hooks/hooks-patterns.md) | Real patterns: auto-approve, git-block, plan-first, worktree cleanup |
| [hooks/hooks-reference.md](hooks/hooks-reference.md) | Complete event reference, matcher syntax, timeout, error handling |

### MCP Servers
| File | What it covers |
|---|---|
| [mcp/mcp-overview.md](mcp/mcp-overview.md) | What MCP is, mcp.json format, server types (stdio/http) |
| [mcp/mcp-servers-catalog.md](mcp/mcp-servers-catalog.md) | All 4 configured servers: Stitch (Google), React-Bit (shadcn), Playwright, Obsidian |
| [mcp/mcp-authentication.md](mcp/mcp-authentication.md) | API keys, OAuth, `.credentials.json`, security practices |

### Tools
| File | What it covers |
|---|---|
| [tools/built-in-tools.md](tools/built-in-tools.md) | Read, Edit, Write, Bash, Glob, Grep, Agent, WebFetch, WebSearch, Notebook |
| [tools/task-tools.md](tools/task-tools.md) | Task*, Monitor, CronCreate, ScheduleWakeup, PushNotification, Worktree |

### Memory
| File | What it covers |
|---|---|
| [memory/memory-system.md](memory/memory-system.md) | Project memory: MEMORY.md index, memory file types, frontmatter |
| [memory/obsidian-vault.md](memory/obsidian-vault.md) | Cross-project vault: two-tier read gate, write protocol, cleanup |
| **`projects/`** | `~/.claude/projects/<encoded-path>/memory/` — machine-local per-project store; see [memory-system.md](memory/memory-system.md) |

### Workflows
| File | What it covers |
|---|---|
| [workflows/planning-protocol.md](workflows/planning-protocol.md) | 3-step protocol: GitHub issue → @principal plan → execute |
| [workflows/closeout-protocol.md](workflows/closeout-protocol.md) | 9-item closeout checklist and required output format |
| [workflows/routing-protocol.md](workflows/routing-protocol.md) | Skill-first 8-step flow, verbalization format, routing table |
| [workflows/migration-guide.md](workflows/migration-guide.md) | Mapping LangChain, GPT-4 Assistants, LangGraph, CrewAI → Claude Code |

### Decisions
| File | What it covers |
|---|---|
| [decisions/0001-scope-layers.md](decisions/0001-scope-layers.md) | Why the 5-layer instruction hierarchy exists |
| [decisions/0002-rules-vs-skills.md](decisions/0002-rules-vs-skills.md) | Why rules and skills are distinct primitives |
| [decisions/0003-hooks-model.md](decisions/0003-hooks-model.md) | Hook runtime choice (Node.js/PowerShell) and stdin→stdout contract |
| [decisions/0004-per-project-memory.md](decisions/0004-per-project-memory.md) | Why per-project memory lives in `~/.claude/projects/`, not in the repo |

### Advanced
| File | What it covers |
|---|---|
| [advanced/headless-automation.md](advanced/headless-automation.md) | CI/cron/background use: permission modes, output parsing, safety checklist |
| [advanced/permission-controls.md](advanced/permission-controls.md) | Full permission resolution order, allow/deny patterns, hook veto chain |
| [advanced/ide-advanced.md](advanced/ide-advanced.md) | Multi-root workspaces, shell hook limits, MCP debugging, statusLine |

### Reference
| File | What it covers |
|---|---|
| [reference/cli-reference.md](reference/cli-reference.md) | CLI flags, models, permission modes, non-interactive use |
| [reference/ide-integrations.md](reference/ide-integrations.md) | VS Code, JetBrains — installation, shared config, known limits |

---

## I Want To…

| Goal | Start here |
|---|---|
| **Create a new agent** | [agents/agent-format.md](agents/agent-format.md) → [agents/agent-roster.md](agents/agent-roster.md) |
| **Create a new skill** | [skills/skill-format.md](skills/skill-format.md) → [skills/skills-overview.md](skills/skills-overview.md) |
| **Add a custom slash command** | [commands/custom-commands.md](commands/custom-commands.md) |
| **Add a hook (e.g. auto-approve, git-block)** | [hooks/hooks-patterns.md](hooks/hooks-patterns.md) → [hooks/hooks-overview.md](hooks/hooks-overview.md) |
| **Integrate an MCP server** | [mcp/mcp-overview.md](mcp/mcp-overview.md) → [mcp/mcp-servers-catalog.md](mcp/mcp-servers-catalog.md) |
| **Set up a new project** | [core/claude-md-format.md](core/claude-md-format.md) (use `/bootstrap-project` command) |
| **Understand the routing system** | [workflows/routing-protocol.md](workflows/routing-protocol.md) → [skills/skills-catalog.md](skills/skills-catalog.md) |
| **Translate a LangChain workflow** | [workflows/migration-guide.md](workflows/migration-guide.md) |
| **Configure settings/permissions** | [core/settings-json.md](core/settings-json.md) |
| **Add a path-specific rule** | [rules/rules-overview.md](rules/rules-overview.md) |
| **Use the memory system** | [memory/memory-system.md](memory/memory-system.md) → [memory/obsidian-vault.md](memory/obsidian-vault.md) |
| **Know the CLI flags** | [reference/cli-reference.md](reference/cli-reference.md) |
| **Understand a design decision** | [decisions/0001-scope-layers.md](decisions/0001-scope-layers.md) (start here) |
| **Run Claude in CI/automation** | [advanced/headless-automation.md](advanced/headless-automation.md) |

---

## Glossary

| Term | Definition |
|---|---|
| **Agent** | An isolated sub-process with its own model, tool list, and (optionally) git worktree; receives tasks from the main session |
| **Skill** | A markdown file that injects domain-specific procedural knowledge into a session when invoked via the `Skill` tool |
| **Rule** | A path-scoped instruction file (`.claude/rules/<topic>.md`) that applies only to files matching its `paths:` glob pattern |
| **Hook** | A shell command executed by Claude Code on lifecycle events (e.g. before a tool call, on session end) |
| **MCP** | Model Context Protocol — a standard for extending Claude with external tool servers |
| **Worktree** | A git worktree created for agent isolation; the agent works on a branch copy, changes are merged back |
| **Plan mode** | An interaction mode where Claude can only read and write to the plan file — it cannot execute or edit other files |
| **CLAUDE.md** | An instruction file read by Claude Code at session start; exists at multiple scope layers |
| **Main session** | The top-level Claude Code instance; the sole orchestration layer — dispatches to agents but never delegates orchestration |
| **Vault** | The Obsidian knowledge base used for cross-project persistent memory |
