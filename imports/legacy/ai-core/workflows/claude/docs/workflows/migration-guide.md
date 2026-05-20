# Migration Guide — Other AI Tools to Claude Code

Concept mapping for teams migrating workflows from LangChain, AutoGPT, GPT-4 Assistants, LangGraph, and CrewAI to Claude Code.

---

## Core Concept Map

| Other tool concept | Claude Code equivalent | Notes |
|---|---|---|
| LangChain Chain | Skill (`~/.claude/skills/*/SKILL.md`) | Skills are procedural knowledge loaded per task; not chained at runtime |
| LangChain Tool | MCP server tool or built-in tool | MCP = external tools; built-in = Read/Edit/Bash/Agent/etc. |
| LangChain Memory | Project MEMORY.md + Obsidian vault | Per-project vs cross-project |
| LangChain Agent | Agent (`@engine`, `@creative`, `@principal`) | Specialized agents with fixed tool subsets |
| AutoGPT autonomous loop | `/loop` + `ScheduleWakeup` | Self-paced iterations with dynamic wakeup intervals |
| GPT-4 Assistants API | Session + CLAUDE.md + MCP | Instructions = CLAUDE.md; tools = built-in + MCP; threads = sessions |
| LangGraph node | Sub-task in plan.md | Nodes are sub-tasks assigned to agents with acceptance criteria |
| LangGraph edge | Dependency in plan.md | Dependency order defines edges; parallel = no dependency |
| LangGraph state | Session context + MEMORY.md | Shared state is session context; persistent state is memory |
| CrewAI Agent | `@engine`, `@creative`, `@principal` | Claude Code has three fixed specialist agents |
| CrewAI Task | Task in plan.md / TaskCreate | Tasks have agent, skills, and acceptance criteria |
| CrewAI Crew | Main session + plan.md | Orchestration lives in the main session; crew = the agents it dispatches |
| OpenAI function calling | MCP tool or built-in tool | Same concept: structured tool invocation |
| Prompt template | SKILL.md body with `$ARGUMENTS` | Skills are reusable prompt templates with dynamic substitution |
| Retrieval / RAG | Web research skill + vault reads | `web-research` skill for live docs; vault for historical context |
| System prompt | `CLAUDE.md` (global + project) | Scope layers: global → project → path-specific |
| Tool use / function schema | Built-in tools + MCP tools | No schema to write — tools are built-in or via MCP config |

---

## LangChain → Claude Code

### Chains

LangChain chains compose prompts and tools into a pipeline. Claude Code uses skills instead:

| LangChain | Claude Code |
|---|---|
| `LLMChain(prompt, llm)` | `Skill("skill-name")` invoked before the task |
| `SequentialChain([chain1, chain2])` | Two sub-tasks in dependency order in plan.md |
| `ConversationChain(memory=...)` | Session context (automatically maintained) |
| Custom `Tool` with name/description | `.claude/commands/<name>.md` or `skills/<name>/SKILL.md` |

**Key difference:** LangChain chains are wired at code level. Claude Code skills are invoked by the routing protocol at task time — no code required.

---

### Memory

| LangChain | Claude Code |
|---|---|
| `ConversationBufferMemory` | Session context (auto) |
| `ConversationSummaryMemory` | `/compact` command |
| `VectorStoreMemory` | Not directly equivalent; use vault + web-research |
| Custom persistent memory | `~/.claude/projects/.../memory/` |

---

## AutoGPT → Claude Code

AutoGPT runs autonomous loops, breaking goals into tasks and executing them indefinitely. Claude Code replicates this with `/loop` + `ScheduleWakeup`:

```
AutoGPT pattern:
  while not done:
    plan next step
    execute step
    evaluate

Claude Code equivalent:
  /loop <goal>
  → Claude uses ScheduleWakeup(delaySeconds, same prompt)
  → On each wakeup: check state, continue or stop
  → Omit ScheduleWakeup to end the loop
```

**Critical differences:**
- Claude Code loops are self-pacing — Claude chooses when to wake up based on what it's waiting for
- The autonomous loop sentinel `<<autonomous-loop-dynamic>>` passes the same prompt on each iteration
- Loops have natural cache-aware breakpoints (270s stays warm; 1200s+ for idle)

---

## GPT-4 Assistants API → Claude Code

| Assistants API concept | Claude Code equivalent |
|---|---|
| System instructions | `CLAUDE.md` (global + project) |
| User thread | Session (persisted in `~/.claude/projects/`) |
| Assistant tools | Built-in tools + MCP tools |
| File retrieval | `Read` tool + Glob/Grep |
| Code interpreter | `Bash` tool |
| Function definitions | MCP server with tool schema |
| Thread messages | Conversation transcript |
| Runs | Each user prompt starts a "run" |
| Run steps | Tool calls within a response |

**Key difference:** Assistants API requires API calls and explicit thread management. Claude Code is interactive and manages context automatically.

---

## LangGraph → Claude Code

LangGraph models workflows as directed graphs with nodes (agents/tools) and edges (state transitions). Claude Code maps this to plan.md + agent dispatch:

| LangGraph | Claude Code |
|---|---|
| `StateGraph` | plan.md with dependency order |
| Node (agent or function) | Sub-task with agent assignment |
| Edge | Dependency between sub-tasks |
| Conditional edge | Planning gate — @principal decides order |
| `CompiledGraph.invoke()` | Main session dispatches agents per plan |
| Shared state | Session context passed in agent prompts |
| Checkpointing | MEMORY.md + session vault notes |

**Parallel execution:**

```
LangGraph: graph.add_edge(node_a, node_b) and graph.add_edge(node_a, node_c) with no edge between b and c
Claude Code: Agent(@engine, task_b, run_in_background=true) + Agent(@creative, task_c)
```

---

## CrewAI → Claude Code

| CrewAI | Claude Code |
|---|---|
| `Agent(role, goal, backstory, tools)` | Agent `.md` file with identity + skill map |
| `Task(description, agent, expected_output)` | Sub-task in plan.md with agent + acceptance criteria |
| `Crew(agents, tasks, process)` | Main session + plan.md |
| `Process.sequential` | Sub-tasks with linear dependency |
| `Process.hierarchical` | Main session orchestrates; agents never orchestrate each other |
| `Tool` | Built-in tool, MCP tool, or skill invocation |

**Key difference:** CrewAI requires defining agents in code with roles and tools. Claude Code agents are pre-configured (engine/creative/principal) with fixed skill maps. You don't create new agent types — you use the three available agents.

---

## Anti-Patterns When Migrating

### Over-engineering the agent hierarchy

**Common mistake:** Trying to replicate a CrewAI "manager agent" that delegates to sub-agents that delegate further.

**Claude Code rule:** The main session is the sole orchestrator. Agents never orchestrate other agents. `@principal` is for planning only — not coordination.

---

### Defining tools as skills

**Common mistake:** Treating every LangChain Tool as a Claude Code skill.

**Claude Code reality:** Tools are built-in (Read/Bash/etc.) or MCP. Skills are *domain knowledge*, not tools — they brief Claude on *how* to work in a domain, not *what capabilities* to have.

---

### Replacing sessions with code loops

**Common mistake:** Writing a Python script that calls the Claude API in a loop, managing conversation state manually.

**Claude Code reality:** Use `/loop` + `ScheduleWakeup` for autonomous loops. Sessions handle context automatically. The CLI handles all state management.

---

### Building custom memory systems

**Common mistake:** Implementing a vector database for agent memory.

**Claude Code reality:** Use `MEMORY.md` for project-specific facts and the Obsidian vault for cross-project knowledge. Both are text-based and managed by Claude automatically.

---

### Hardcoding system prompts in code

**Common mistake:** Passing system prompts via API calls or environment variables.

**Claude Code reality:** System instructions live in `CLAUDE.md` (global + project). Skills extend them per task. No code required.

---

## Related

- [agents/agent-roster.md](../agents/agent-roster.md) — @engine, @creative, @principal
- [skills/skills-overview.md](../skills/skills-overview.md) — skills vs tools vs memory
- [core/context-management.md](../core/context-management.md) — /loop, ScheduleWakeup
- [mcp/mcp-overview.md](../mcp/mcp-overview.md) — MCP as the tool extension layer
- [memory/memory-system.md](../memory/memory-system.md) — project memory
- [memory/obsidian-vault.md](../memory/obsidian-vault.md) — cross-project memory
