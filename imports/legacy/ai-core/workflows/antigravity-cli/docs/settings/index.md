# Settings

> **Migration note:** This section remains the detailed reference for runtime configuration, but Antigravity-first readers should start from [../antigravity-cli/configuration.md](../antigravity-cli/configuration.md) to understand which surfaces are canonical and use [../antigravity-cli/index.md](../antigravity-cli/index.md) for the preferred navigation layer and migration guidance.

This section documents Gemini CLI's configuration system: where `settings.json` lives, how precedence works, which environment variables override configuration, and what each documented setting does.

## Quick Reference

> - Gemini CLI normally reads two editable settings files: one user-global and one project-local.
> - Precedence has seven layers: CLI flags win; hardcoded defaults lose.
> - Settings merge by key, so narrower scopes override only the keys they define.
> - Add the published JSON Schema URL to `settings.json` for IDE validation and autocomplete.
> - Use the load-by-task table to open one module at a time.

## Load by Task

| Load when you need to… | Module |
|---|---|
| Understand settings files, locations, precedence layers | [fundamentals.md](fundamentals.md) |
| See every `settings.json` field with types and defaults | [full-schema.md](full-schema.md) |
| Configure authentication, themes, sandbox, telemetry | [full-schema.md](full-schema.md) |
| See all supported environment variables and what they override | [environment-variables.md](environment-variables.md) |
