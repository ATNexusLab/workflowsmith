# Responsible Use, Security, And Enterprise Administration

Label: **Official reference**
Owner: `Safety guidance, limitations, and enterprise controls`
Last checked: `2026-05-20`
Version note: Admin-policy behavior and responsible-use guidance can change.

This page owns the official safety, limitation, and enterprise-administration guidance for GitHub Copilot CLI.

## Responsible-use baseline

The responsible-use documentation describes GitHub Copilot CLI as a system that:

- processes user input and surrounding context
- uses a language model to analyze the task
- generates code and natural-language output
- formats output for terminal use

The same page explicitly recommends:

- keep tasks well scoped
- provide additional context through customization and prompts
- use Copilot CLI as a tool, not a replacement for human judgment
- continue secure coding, review, and testing practices
- provide feedback when results are poor

## Security measures

Official security guidance emphasizes:

- constrain permissions carefully
- launch the CLI only from trusted directories
- review file modifications before approving them
- review dangerous commands before allowing them to run
- treat autopilot or full-permission runs as higher risk

## BYOK security and data handling

Responsible-use guidance makes these BYOK boundaries explicit:

- prompts, code context, and responses go directly to the configured provider
- GitHub does not proxy those payloads
- telemetry still goes to GitHub unless offline mode is enabled
- `COPILOT_OFFLINE=true` disables telemetry and prevents contact with GitHub
- if BYOK configuration fails, the CLI exits with an error and does not fall back to GitHub-hosted models

## Documented limitations

The responsible-use page explicitly calls out these limitation classes:

| Limitation | Official warning |
| --- | --- |
| Limited scope | Quality varies by codebase shape, language, and available training/context data |
| Potential bias | Suggestions can reflect bias or skew toward certain languages or styles |
| Security risk | Generated code and command suggestions can expose vulnerabilities or misuse sensitive context |
| Inaccurate code | Output can look plausible while being semantically or syntactically wrong |
| Public-code overlap | Output can match or near-match public code |
| Legal and regulatory constraints | Suitability depends on applicable obligations and terms |
| Command-execution accountability | Users remain responsible for commands they choose to run |

## Enterprise controls that apply

The enterprise-administration page says these controls affect Copilot CLI:

| Control | Effect on Copilot CLI |
| --- | --- |
| Copilot CLI enablement | Can be enabled or disabled at enterprise or organization level |
| Model selection | Users only see models enabled at the enterprise level |
| Custom agents | Enterprise-configured custom agents are available in Copilot CLI |
| MCP server policies | Registry and allowlist policies apply |
| Copilot cloud agent enablement | Must be enabled alongside Copilot CLI for `/delegate` |
| Audit logging | Policy changes affecting Copilot CLI appear in the enterprise audit log |
| Seat assignment | Users need an assigned Copilot seat |

## Enterprise controls that do not apply

The enterprise page explicitly says these do **not** affect Copilot CLI:

- IDE-specific policies
- file-path content exclusions
- user-configured BYOK provider settings

## Access troubleshooting

If users unexpectedly cannot access Copilot CLI, the enterprise guide says to verify:

1. the user has a valid Copilot seat from an organization in the enterprise
2. the enterprise-level Copilot CLI policy
3. whether the enterprise policy overrides organization settings
4. whether at least one licensing organization has Copilot CLI enabled when the enterprise delegates to organizations

## Sources

- [Responsible use of GitHub Copilot CLI](https://docs.github.com/en/copilot/responsible-use/copilot-cli)
- [Administering Copilot CLI for your enterprise](https://docs.github.com/en/copilot/how-tos/copilot-cli/administer-copilot-cli-for-your-enterprise)
