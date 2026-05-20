<!-- topic: security | section: hooks -->
# Hooks Security Model

> **Quick Reference**
> - Project hooks are untrusted by default and require user consent.
> - Gemini CLI fingerprints hook commands and revokes trust when the command changes.
> - Stored trust decisions live in `~/.gemini/hooks-trust.json`.
> - Extension hooks are trusted automatically because extensions go through a separate consent path.
> - Hooks run as the CLI user with full host access, so audit them like any other executable code.

## Default Trust Model

Gemini CLI treats hook origin as a security boundary.

| Hook source | Default trust |
|---|---|
| Project-level hooks | Untrusted by default |
| Extension hooks | Trusted automatically |

The project-level default matters because a repository can contain arbitrary hook definitions. Opening an unfamiliar workspace should not silently grant executable policy code the right to run on your machine.

## Fingerprint System

Gemini CLI uses a fingerprint system to decide whether a project hook is still the same executable the user previously trusted.

| Step | Behavior |
|---|---|
| First run | Gemini CLI computes a fingerprint of the hook command and asks for consent. |
| Command unchanged | Gemini CLI reuses the stored trust decision. |
| Command changed | Trust is revoked, the fingerprint no longer matches, and Gemini CLI prompts again. |

Fingerprints are stored in `~/.gemini/hooks-trust.json`.

## User Trust Choices

When Gemini CLI encounters an untrusted project hook, the user can choose one of four outcomes.

| Choice | Effect |
|---|---|
| Allow once | Run the hook for the current prompt without storing long-term trust |
| Always allow | Store the fingerprint and trust the current command persistently |
| Deny | Refuse to run the hook |
| Disable all project hooks | Turn off project-sourced hooks entirely |

## Slash Commands for Hook Management

Gemini CLI exposes `/hooks` commands for inspection and control.

| Command | Aliases | Purpose |
|---|---|---|
| `/hooks list` | `show`, `panel` | Show all hooks and their current status |
| `/hooks enable <name>` | — | Enable one named hook |
| `/hooks disable <name>` | — | Disable one named hook |
| `/hooks enable-all` | — | Enable every configured hook |
| `/hooks disable-all` | — | Disable every configured hook |

## Extension Hooks

Extension hooks are trusted automatically because extensions go through a separate installation and consent process. That trust decision applies to the extension package, so Gemini CLI does not treat each extension hook as an unknown project executable.

## Host Access Warning

Hooks run as the same operating-system user as Gemini CLI. They inherit that user's host access, file permissions, network reachability, and process privileges.

Treat hook scripts as code, not as passive configuration. Review them before enabling them, keep them under version control, and audit command changes with the same care you would give any executable in your toolchain.
