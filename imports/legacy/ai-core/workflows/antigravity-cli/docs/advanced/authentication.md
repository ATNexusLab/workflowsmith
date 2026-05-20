<!-- topic: authentication | section: advanced -->
# Authentication

## Quick Reference

> - Gemini CLI supports four main authentication methods: API key, personal Google OAuth, service account, and Vertex AI.
> - API keys are the default auth type and are best supplied through environment variables.
> - Use `gemini auth`, `gemini auth status`, and `gemini auth revoke` to manage credentials from the terminal.
> - OAuth tokens for personal sign-in are stored in `~/.gemini/oauth-creds.json`.
> - Keep secrets out of `settings.json` and outside project directories whenever possible.

## Authentication Methods at a Glance

| Method | Best for | Main setup surface |
|---|---|---|
| API key | Default local or automated use with Gemini Developer API access | Environment variables or `auth.type: "apiKey"` |
| Google OAuth (personal) | Interactive personal sign-in | `gemini auth` or `auth.type: "oauth-personal"` |
| Service account | Non-interactive Google Cloud workloads | `serviceAccountKeyPath` or `GOOGLE_APPLICATION_CREDENTIALS` |
| Vertex AI | Google Cloud and Vertex AI environments | `auth.type: "vertex-ai"` plus `vertexai` settings or env vars |

## 1. API Key

API key authentication is the default method.

```bash
export GEMINI_API_KEY="your-api-key"
# or
export GOOGLE_API_KEY="your-api-key"
```

Equivalent settings shape:

```json
{
  "auth": {
    "type": "apiKey"
  }
}
```

Use an API key when you want the smallest possible setup surface, especially for local scripts or CI jobs that already have access to a secret manager.

## 2. Google OAuth (personal)

Personal OAuth uses an interactive browser-based Google sign-in flow.

Start it from the terminal:

```bash
gemini auth
```

Then select **Sign in with Google**.

You can also configure the type directly:

```json
{
  "auth": {
    "type": "oauth-personal"
  }
}
```

Gemini CLI stores the resulting OAuth tokens in:

```text
~/.gemini/oauth-creds.json
```

This method is best for a person using Gemini CLI interactively on their own machine.

## 3. Service Account

Service account authentication uses a Google Cloud service account JSON key file.

Configure it in `settings.json`:

```json
{
  "auth": {
    "type": "oauth-service-account",
    "serviceAccountKeyPath": "/path/to/key.json"
  }
}
```

Or supply the credential path through the environment:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json
```

Use a service account for server-side automation, CI, or any workflow where no interactive login should occur.

## 4. Vertex AI

Vertex AI authentication uses Google Cloud credentials against the Vertex AI endpoint.

Configure it in `settings.json`:

```json
{
  "auth": {"type": "vertex-ai"},
  "vertexai": {
    "project": "my-gcp-project",
    "location": "us-central1",
    "express": false
  }
}
```

Or set the Google Cloud environment variables:

```bash
export GOOGLE_CLOUD_PROJECT=my-project
export GOOGLE_CLOUD_LOCATION=us-central1
```

Vertex AI is the right choice when your Gemini CLI usage is anchored in Google Cloud projects, organization policy, or existing Vertex AI infrastructure.

## Terminal Commands

Gemini CLI includes an auth command group for setup and lifecycle management.

```bash
gemini auth          # Interactive auth setup
gemini auth status   # Show current auth status
gemini auth revoke   # Revoke credentials
```

Use `status` to confirm which credential path is active. Use `revoke` when you need to remove cached credentials from the current machine.

## Security Best Practices

### Keep secrets out of `settings.json`

Do not place API keys directly in `settings.json`. Settings files are easier to commit, copy, or share by accident.

### Prefer environment variables or a secret manager

Environment variables are safer for local shells, CI pipelines, and ephemeral automation. Secret managers are better still when your runtime already has one.

### Store service account keys outside the project directory

Service account JSON files should live outside the repository so they do not end up in source control, archives, or project-wide search results.

### Treat cached OAuth tokens as credentials

The file at `~/.gemini/oauth-creds.json` should be protected like any other secret-bearing local credential store.

## Choosing the Right Method

Use API keys for simple automation, personal OAuth for interactive use on your machine, service accounts for non-interactive Google Cloud identities, and Vertex AI when the runtime should authenticate directly against a GCP project and region.
