# Extensions

> **Migration note:** This section remains the detailed reference for extension mechanics, but Antigravity-first readers should start from [../antigravity-cli/workflow-authoring.md](../antigravity-cli/workflow-authoring.md) to decide where new workflow behavior belongs and use [../antigravity-cli/index.md](../antigravity-cli/index.md) for the preferred navigation layer and migration guidance.

Gemini CLI extensions are installable bundles that package reusable capabilities such as MCP servers, commands, skills, hooks, and themes under one manifest.

## Quick Reference

> - Load one module at a time; each file is written to stand alone.
> - Extensions live in `~/.gemini/extensions/` and are discovered at CLI startup.
> - `gemini-extension.json` is the manifest that defines what an extension ships.
> - Use the table below to jump directly from task to module.

## Load by task

| Load when you need to… | Module |
|---|---|
| Understand what extensions are and what they bundle | [fundamentals.md](./fundamentals.md) |
| See the full manifest schema (`gemini-extension.json`) | [manifest-schema.md](./manifest-schema.md) |
| Install, list, or uninstall extensions | [managing-extensions.md](./managing-extensions.md) |
| Write your own extension | [authoring-guide.md](./authoring-guide.md) |
