# Models, Automation, And Observability

Label: **Official reference**
Owner: `Model selection, BYOK provider behavior, and OpenTelemetry`
Last checked: `2026-05-20`
Version note: Default models, available models, BYOK support, and telemetry fields are version-sensitive.

This file keeps its historical name for link stability, but it now owns only model and observability facts.

Use these pages for adjacent topics:

- automation workflows: [Programmatic use and automation](programmatic-use-and-automation.md)
- command and flag inventory: [Commands and official command surface](commands-and-official-command-surface.md)
- ACP and remote control: [LSP, ACP, and remote control](../integrations/lsp-acp-and-remote-control.md)

## Model selection

Official model-selection surfaces include:

- `/model`
- `--model`
- `COPILOT_MODEL`

The official overview states that the default model for Copilot CLI is **Claude Sonnet 4.5**, while also warning that GitHub can change the default.

When `auto` is selected, Copilot chooses the model automatically.

## Model precedence

The programmatic reference documents this precedence order for choosing a model for a prompt:

1. a model defined by the selected custom agent
2. the `--model` command-line option
3. the `COPILOT_MODEL` environment variable
4. the `model` key in `settings.json`
5. the CLI default model

## Premium-request framing

The official overview states that premium-request consumption depends on the selected model's multiplier.

## Bring your own model provider

Official BYOK environment variables include:

| Variable | Meaning |
| --- | --- |
| `COPILOT_PROVIDER_BASE_URL` | Base URL of the provider API |
| `COPILOT_PROVIDER_TYPE` | Provider type: `openai`, `azure`, or `anthropic` |
| `COPILOT_PROVIDER_API_KEY` | Provider API key when the target provider requires one |
| `COPILOT_MODEL` | Required model identifier when using a custom provider |

The official overview says BYOK providers must support:

- tool calling
- streaming
- preferably a context window of at least 128k tokens

The official docs also state that Copilot CLI can connect to OpenAI-compatible endpoints, Azure OpenAI, Anthropic, and locally running compatible providers such as Ollama.

## BYOK data handling boundaries

Responsible-use guidance makes these points explicit:

- prompts, code context, and generated responses go directly to the configured provider
- they are not routed through GitHub
- GitHub authentication is not required for BYOK-only usage
- without GitHub authentication, `/delegate`, the GitHub MCP server, and GitHub Code Search are unavailable
- in offline mode (`COPILOT_OFFLINE=true`), telemetry is disabled and only the configured BYOK provider is contacted
- if provider configuration is invalid, Copilot CLI exits with an error and does **not** fall back to GitHub-hosted models

## OpenTelemetry monitoring

The command reference documents OTel support for traces and metrics. OTel is off by default.

Key OTel controls:

| Variable | Default | Purpose |
| --- | --- | --- |
| `COPILOT_OTEL_ENABLED` | `false` | Explicitly enable OTel |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | — | OTLP endpoint; setting it also enables OTel |
| `COPILOT_OTEL_EXPORTER_TYPE` | `otlp-http` | Choose `otlp-http` or `file` |
| `COPILOT_OTEL_FILE_EXPORTER_PATH` | — | Write JSON-lines telemetry to a file |
| `OTEL_SERVICE_NAME` | `github-copilot` | Service name in resource attributes |
| `OTEL_RESOURCE_ATTRIBUTES` | — | Extra resource attributes |
| `OTEL_INSTRUMENTATION_GENAI_CAPTURE_MESSAGE_CONTENT` | `false` | Capture full prompt and response content |
| `OTEL_LOG_LEVEL` | — | OTel diagnostic log level |
| `OTEL_EXPORTER_OTLP_HEADERS` | — | OTLP auth headers |

Documented signal families include:

- `invoke_agent`, `chat`, and `execute_tool` spans
- GenAI convention metrics for duration, token usage, and streaming latency
- vendor-specific metrics for tool-call counts, tool-call latency, and agent turn counts
- span events for hooks, truncation, compaction, skill invocation, shutdown, aborts, and exceptions

## Content-capture warning

Official docs say content capture is off by default.

If enabled, telemetry can record:

- prompt messages
- response messages
- system instructions
- tool definitions
- tool arguments
- tool results

That can include sensitive code and prompts.

## Sources

- [About GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli)
- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- [GitHub Copilot CLI programmatic reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-programmatic-reference)
- [Responsible use of GitHub Copilot CLI](https://docs.github.com/en/copilot/responsible-use/copilot-cli)
