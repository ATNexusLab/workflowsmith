# Hooks

> **Migration note:** This section remains the detailed reference for hook mechanics, but Antigravity-first readers should start from [../antigravity-cli/workflow-authoring.md](../antigravity-cli/workflow-authoring.md) to decide where new workflow behavior belongs and use [../antigravity-cli/index.md](../antigravity-cli/index.md) for the preferred navigation layer and migration guidance.

This section documents Gemini CLI's lifecycle hooks system: external programs that can observe, modify, or block session, model, agent, and tool events.

> **Quick Reference**
> - Hooks are external executables that receive event JSON on stdin and return structured JSON on stdout.
> - Gemini CLI exposes 11 hook events across session, agent, model, tool, compression, and notification phases.
> - Enable the system with `hooksConfig.enabled: true` in `settings.json`.
> - Use `hooksConfig.notifications: true` to show hook activity indicators in the CLI.
> - Use the table below to load exactly one module for the task at hand.

## Load by Task

| Load when you need to… | Module |
|---|---|
| Understand what hooks are and how they work | [fundamentals.md](fundamentals.md) |
| See all 11 hook events with input/output schemas | [events-reference.md](events-reference.md) |
| Understand the stdout contract and response types | [io-contract.md](io-contract.md) |
| Configure hooks in hooks.json | [configuration.md](configuration.md) |
| See patterns, examples, and implementation recipes | [patterns-and-examples.md](patterns-and-examples.md) |
| Understand trust, fingerprinting, security model | [security.md](security.md) |
