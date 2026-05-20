<!-- topic: built-in agents | section: agents -->
# Built-in Agents

> **Quick Reference**
> - Gemini CLI ships with built-in agents that are available without authoring custom agent files.
> - `codebase_investigator`, `cli_help`, and `generalist` are enabled by default.
> - `browser_agent` exists but is disabled by default.
> - Use `agents.disabled` in `settings.json` to disable built-in agents by name.
> - Built-in agents are best treated as broad utilities; use custom agents when you need narrow behavior.

## Built-in agent reference

| Name | Default state | Best use cases | When not to use it |
|---|---|---|---|
| `codebase_investigator` | Enabled | Deep codebase analysis, dependency mapping, tracing execution paths, and root-cause debugging | Do not use it for simple symbol lookup, tiny file reads, or direct edits you already understand |
| `cli_help` | Enabled | Questions about Gemini CLI features, configuration, commands, and behavior | Do not use it for repository-specific engineering work or general coding tasks unrelated to Gemini CLI itself |
| `generalist` | Enabled | Intensive multi-turn tasks, batch processing, and work likely to generate large output volume | Do not use it when a narrower specialist or a direct local edit is sufficient |
| `browser_agent` | Disabled by default | Web browsing and research tasks that benefit from browser-driven investigation | Do not use it for local repository work, offline tasks, or when browser access is unnecessary |

## Agent details

### `codebase_investigator`

**Best for:** deep repository analysis, dependency mapping, and root-cause debugging where the answer depends on tracing relationships across many files.

**Do not use it for:** lightweight reads, quick grep-style lookups, or simple edits where direct local tools are faster and clearer.

### `cli_help`

**Best for:** explaining Gemini CLI itself, including settings, behavior, feature support, and operational usage.

**Do not use it for:** implementation work in the current project or product-domain questions that are unrelated to Gemini CLI.

### `generalist`

**Best for:** long-running, multi-step work that benefits from its own workspace, especially batch processing and tasks with large intermediate output.

**Do not use it for:** highly specialized work when a purpose-built custom agent already exists, or for very small tasks that do not justify delegation overhead.

### `browser_agent`

**Best for:** web browsing and research that require a browser context rather than local file inspection.

**Do not use it for:** repository-only work, command-line-only tasks, or environments where browser access is intentionally disabled.

## Enable or disable built-in agents

Gemini CLI uses the `agents.disabled` array in `settings.json` to disable built-in agents by name.

```json
{
  "agents": {
    "disabled": ["browser_agent"]
  }
}
```

To disable a built-in agent, add its name to the array. To enable a built-in agent, remove its name from the array. Because `browser_agent` is disabled by default, enabling it means ensuring it is not listed in `agents.disabled`.
