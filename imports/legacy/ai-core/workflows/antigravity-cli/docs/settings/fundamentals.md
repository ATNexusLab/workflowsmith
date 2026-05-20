<!-- topic: fundamentals | section: settings -->
# Settings Fundamentals

## Quick Reference

> - Gemini CLI normally exposes two editable settings files: `~/.gemini/settings.json` and `.gemini/settings.json`.
> - Workspace settings override user settings.
> - Precedence has seven layers: CLI flags, environment variables, system overrides, project settings, user settings, system defaults, hardcoded defaults.
> - Settings merge by key instead of replacing entire objects.
> - Add the published JSON Schema URL to `settings.json` for validation and autocomplete.

## What the Settings System Is

Gemini CLI loads configuration from layered sources and computes one effective settings object for the current session. The settings system is designed so that local, task-specific overrides can sit on top of broader defaults without forcing you to duplicate the full configuration tree.

Most users interact with two JSON files:

| Scope | Path | Typical use |
|---|---|---|
| User-global | `~/.gemini/settings.json` | Personal defaults that should apply across projects |
| Project-local | `.gemini/settings.json` | Repository or workspace overrides that only apply inside one project |

Gemini CLI can also apply enterprise-managed system layers and built-in defaults, but the two files above are the normal authoring surface.

## Settings File Locations

### User-global settings

`~/.gemini/settings.json` stores defaults for your local account. Put settings here when you want the same behavior everywhere, such as a preferred model, theme, or telemetry preference.

### Project-local settings

`.gemini/settings.json` lives in the project root and applies only inside that workspace. Use it for repository-specific behavior, such as MCP servers, sandbox paths, or a project-required model.

> **Critical rule:** Workspace settings override user settings.

That rule means a key defined in `.gemini/settings.json` wins over the same key in `~/.gemini/settings.json`.

## Precedence Model

Gemini CLI resolves settings from highest precedence to lowest precedence in this order:

1. **CLI flags** such as `--model` or `--debug`
2. **Environment variables** such as `GEMINI_MODEL` or `GEMINI_API_KEY`
3. **System override settings (enterprise-only)** for enterprise-managed enforcement
4. **Project `.gemini/settings.json`**
5. **User `~/.gemini/settings.json`**
6. **System defaults**
7. **Hardcoded defaults**

The highest layer that defines a value wins for that specific key.

## Merge Behavior

Settings are **merged, not replaced**. A narrower scope only overrides the keys it defines and inherits everything else from broader scopes.

### Example

If the user file contains:

```json
{
  "theme": "dark",
  "telemetry": {
    "enabled": false,
    "logPrompts": false
  }
}
```

and the project file contains:

```json
{
  "telemetry": {
    "logPrompts": true
  }
}
```

then the effective result is:

```json
{
  "theme": "dark",
  "telemetry": {
    "enabled": false,
    "logPrompts": true
  }
}
```

The project file overrides only `telemetry.logPrompts`; it does not replace the whole `telemetry` object.

## IDE Validation with JSON Schema

Gemini CLI publishes a JSON Schema for `settings.json` validation, autocomplete, and inline documentation in editors that support JSON Schema.

### Schema URL

```text
https://raw.githubusercontent.com/google-gemini/gemini-cli/main/schemas/settings.schema.json
```

### Add the schema to `settings.json`

```json
{
  "$schema": "https://raw.githubusercontent.com/google-gemini/gemini-cli/main/schemas/settings.schema.json"
}
```

## Key Environment Variables

Environment variables sit above both settings files in precedence, so they are the right place for ephemeral overrides and secrets.

| Var | Overrides | Description |
|---|---|---|
| `GEMINI_API_KEY` | — | API key |
| `GOOGLE_API_KEY` | — | Alternative API key |
| `GEMINI_MODEL` | `model` | Active model |
| `GEMINI_SANDBOX` | `sandbox.sandbox` | Enable sandbox |
| `GOOGLE_CLOUD_PROJECT` | `vertexai.project` | GCloud project |
| `GOOGLE_CLOUD_LOCATION` | `vertexai.location` | GCloud location |
| `GEMINI_DEBUG_HTTP` | — | Log HTTP requests |

## Practical Rule of Thumb

Use `~/.gemini/settings.json` for stable personal defaults, `.gemini/settings.json` for repository behavior, environment variables for secrets or temporary overrides, and CLI flags for one-off commands.
