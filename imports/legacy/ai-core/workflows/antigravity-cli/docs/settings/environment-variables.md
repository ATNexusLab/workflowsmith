<!-- topic: environment-variables | section: settings -->
# Settings Environment Variables

## Quick Reference

> - Environment variables override `settings.json` values.
> - CLI flags still win over environment variables.
> - Use environment variables for secrets and one-off overrides.
> - `GEMINI_MODEL` and `GEMINI_SANDBOX` map directly to documented settings fields.
> - Never store API keys in `settings.json`.

## How Environment Variable Overrides Work

Gemini CLI reads environment variables after loading settings files and before applying CLI flags. In precedence terms, environment variables override both `~/.gemini/settings.json` and `.gemini/settings.json`, but CLI flags still override environment variables.

That makes environment variables the right tool for secrets, CI automation, shell-specific overrides, and temporary experiments.

## Authentication Variables

| Var | Description |
|---|---|
| `GEMINI_API_KEY` | Primary Gemini API key |
| `GOOGLE_API_KEY` | Alternative API key |
| `GOOGLE_APPLICATION_CREDENTIALS` | Path to a service account JSON file |
| `GOOGLE_CLOUD_PROJECT` | Google Cloud project for Vertex AI |
| `GOOGLE_CLOUD_LOCATION` | Google Cloud location for Vertex AI |

## Runtime Control Variables

| Var | Description |
|---|---|
| `GEMINI_MODEL` | Override the active model |
| `GEMINI_SANDBOX` | Enable sandbox; supported values include `"true"`, `"docker"`, and `"macos-seatbelt"` |
| `GEMINI_DEBUG_HTTP` | Log all HTTP requests when set to any non-empty value |
| `GEMINI_HEADLESS` | Force headless mode |

## Direct Setting Overrides

Some environment variables map directly onto documented settings keys. `GEMINI_MODEL` overrides `model`, `GEMINI_SANDBOX` overrides `sandbox.sandbox`, `GOOGLE_CLOUD_PROJECT` overrides `vertexai.project`, and `GOOGLE_CLOUD_LOCATION` overrides `vertexai.location`.

Variables such as `GEMINI_API_KEY`, `GOOGLE_API_KEY`, `GOOGLE_APPLICATION_CREDENTIALS`, and `GEMINI_DEBUG_HTTP` influence runtime behavior directly rather than overriding a single documented `settings.json` key.

## Security Note

Never put API keys in `settings.json`. Use environment variables or a dedicated secret manager instead.

Settings files may be committed to version control, copied into repositories, or shared across machines. Secrets stored in the environment are easier to rotate, isolate, and keep out of source control.
