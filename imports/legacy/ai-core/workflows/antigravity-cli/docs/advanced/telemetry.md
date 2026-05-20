<!-- topic: telemetry | section: advanced -->
# Telemetry

## Quick Reference

> - Telemetry records operational data such as usage metrics, tool activity, error rates, and model performance data.
> - Prompt content is not included unless you explicitly opt in with `telemetry.logPrompts`.
> - Disable telemetry entirely with `{"telemetry": {"enabled": false}}`.
> - Use `target: "google"` for the default destination or `target: "otlp"` with `otlpEndpoint` for a custom collector.
> - API keys are never included in telemetry payloads.

## What Telemetry Is

Telemetry is Gemini CLI's runtime observability and usage-reporting layer. It helps operators and platform teams understand how the CLI is being used, how often tools run, where failures occur, and how models perform in real workflows.

By default, Gemini CLI collects usage metrics, tool calls, error rates, and model performance data. Prompt content is excluded unless you explicitly enable prompt logging.

## Disable Telemetry Entirely

Turn off telemetry with `settings.json`:

```json
{
  "telemetry": {
    "enabled": false
  }
}
```

Use this when policy or local privacy requirements require a full opt-out.

## Opt In to Prompt Logging

Prompt logging is separate from basic telemetry collection. To include prompt text in telemetry payloads, opt in explicitly:

```json
{
  "telemetry": {
    "logPrompts": true
  }
}
```

If you do not set `logPrompts` to `true`, Gemini CLI does not include prompt content in telemetry.

## Configure a Custom OpenTelemetry Endpoint

Send telemetry to your own OpenTelemetry collector by setting the target to `otlp` and providing an endpoint:

```json
{
  "telemetry": {
    "enabled": true,
    "target": "otlp",
    "otlpEndpoint": "http://localhost:4318"
  }
}
```

This is the common choice for self-managed observability pipelines.

## Telemetry Targets

| Target | Meaning |
|---|---|
| `"google"` | Default Google-collected telemetry target |
| `"otlp"` | Send telemetry to a custom OpenTelemetry collector |

`google` is the default target when telemetry is enabled and no custom collector is configured.

## Privacy Notes

Gemini CLI does not include API keys in telemetry payloads. That rule applies even when telemetry is enabled.

Telemetry still may include operational metadata about the session, tools, and model behavior, so you should review the effective settings for your environment and consult Google's privacy policy when you need the full service-level collection details.

## Practical Guidance

Leave default telemetry in place when you want standard operational visibility, disable it entirely when policy requires no collection, and enable `logPrompts` only when you have an explicit reason to capture prompt text for diagnostics or observability.
