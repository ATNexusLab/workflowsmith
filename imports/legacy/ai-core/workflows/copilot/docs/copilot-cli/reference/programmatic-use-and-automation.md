# Programmatic Use And Automation

Label: **Official reference**
Owner: `Prompt mode, scripting, CI/CD, and Actions`
Last checked: `2026-05-20`
Version note: Prompt-mode defaults, examples, and Actions guidance can change.

This page owns the official non-interactive usage model for GitHub Copilot CLI.

## Official entrypoints

Official docs describe two programmatic entry styles:

| Style | Official form |
| --- | --- |
| Direct prompt argument | `copilot -p "PROMPT"` or `copilot --prompt "PROMPT"` |
| Piped input | Pipe input to `copilot` from another process or script |

## Programmatic-focused controls

The full option inventory lives on the command-surface page. These options are called out repeatedly in the official programmatic docs:

| Control | Why it matters in automation |
| --- | --- |
| `-p`, `--prompt` | Run one prompt and exit |
| `-s`, `--silent` | Return only the response body |
| `--output-format=text|json` | Select plain text or JSONL output |
| `--allow-tool`, `--allow-url` | Grant only the minimum needed permissions |
| `--allow-all`, `--allow-all-tools` | Fully autonomous but higher risk |
| `--no-ask-user` | Prevent interactive clarification pauses |
| `--model` | Pin behavior across environments |
| `--share`, `--share-gist` | Persist or publish transcripts after completion |

The command reference states that JSON output is **JSONL**, with one JSON object per line.

## Official usage guidance

The programmatic how-to explicitly recommends:

- provide precise prompts
- quote prompts carefully
- give minimal permissions
- use `-s` when capturing output
- use `--no-ask-user` when a workflow must not pause
- set `--model` explicitly for consistency

## Example task families from official docs

Official programmatic examples cover:

- generating a commit message
- summarizing a file
- writing tests for a module
- fixing lint errors
- explaining a diff
- reviewing a branch
- generating documentation
- exporting a session

## Shell-scripting patterns

The official docs show these shell patterns:

- capture Copilot output in a variable
- use Copilot output in a conditional branch
- process multiple files programmatically

## CI/CD pattern

The programmatic usage guide frames CI/CD as a first-class use case.

Its example workflow step:

- authenticates with `COPILOT_GITHUB_TOKEN`
- runs `copilot -p ...`
- commonly pairs `-s` with explicit tool permissions
- uses `--no-ask-user` to avoid blocking the workflow

## GitHub Actions workflow structure

The Actions guide breaks the workflow into these stages:

| Stage | Official responsibility |
| --- | --- |
| Trigger | Schedule, repository event, or manual dispatch |
| Setup | Check out code and prepare the runner |
| Install | Install Copilot CLI on the runner |
| Authenticate | Provide a Copilot-licensed user's fine-grained PAT with **Copilot Requests** |
| Run Copilot CLI | Invoke `copilot -p ...` and handle the output |

Important Actions-specific boundaries from the official guide:

- the example uses a fine-grained PAT stored as a repository secret
- the PAT belongs to a GitHub user account with a Copilot license
- the example sets `COPILOT_GITHUB_TOKEN`, not the built-in `GITHUB_TOKEN`, for Copilot authentication

## Prompt-mode trust defaults

Official docs say these repository-controlled surfaces are disabled in prompt mode unless explicitly enabled:

| Variable | Effect when set to `true` |
| --- | --- |
| `GITHUB_COPILOT_PROMPT_MODE_EXTENSIONS` | Load project extensions in prompt mode |
| `GITHUB_COPILOT_PROMPT_MODE_REPO_HOOKS` | Load repository hooks in prompt mode |
| `GITHUB_COPILOT_PROMPT_MODE_WORKSPACE_MCP` | Load workspace MCP sources in prompt mode |

## Related boundaries

- token precedence and supported token types: [Installation, getting started, and authentication](installation-getting-started-and-authentication.md)
- permission filters and approval semantics: [Tools, permissions, and safety controls](tools-permissions-and-safety-controls.md)
- model precedence and BYOK provider behavior: [Models, automation, and observability](models-automation-and-observability.md)

## Sources

- [Quickstart for automating with GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/quickstart)
- [Running GitHub Copilot CLI programmatically](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/run-cli-programmatically)
- [Automating tasks with Copilot CLI and GitHub Actions](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/automate-with-actions)
- [GitHub Copilot CLI programmatic reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-programmatic-reference)
- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
