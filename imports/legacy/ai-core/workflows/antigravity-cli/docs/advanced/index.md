# Advanced

> **Migration note:** This section remains the detailed reference for advanced runtime mechanics, but Antigravity-first readers should start from [../antigravity-cli/planning-approval-execution.md](../antigravity-cli/planning-approval-execution.md) for the canonical workflow lifecycle and use [../antigravity-cli/index.md](../antigravity-cli/index.md) for the preferred navigation layer and migration guidance.

This section documents Gemini CLI features that change how sessions run, how work is approved, how file state is protected, and how the runtime integrates with your environment.

## Quick Reference

> - Use headless mode when Gemini CLI needs to run inside scripts, shell pipelines, or CI.
> - Use plan mode when you want a reviewed Markdown plan before any execution starts.
> - Enable checkpointing to restore file state during the current session without touching your project Git history.
> - Use sandboxing, auth, theme, and telemetry settings to shape the runtime around your environment.
> - Open one module at a time with the load-by-task table below.

## Load by Task

| Load when you need to… | Module |
|---|---|
| Run Gemini CLI non-interactively or in scripts/CI | [headless-mode.md](headless-mode.md) |
| Use plan mode for structured planning before execution | [plan-mode.md](plan-mode.md) |
| Enable/use checkpointing and file restore | [checkpointing.md](checkpointing.md) |
| Run tools in an isolated sandbox environment | [sandbox.md](sandbox.md) |
| Configure authentication (API key, OAuth, Vertex AI) | [authentication.md](authentication.md) |
| Change the visual theme | [themes.md](themes.md) |
| Configure telemetry | [telemetry.md](telemetry.md) |
