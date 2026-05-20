<!-- topic: sandbox | section: advanced -->
# Sandbox

## Quick Reference

> - Sandbox mode runs tools inside an isolated environment instead of directly on the host.
> - The documented sandbox types are `"docker"`, `"macos-seatbelt"`, and `true` for auto-detect.
> - Enable sandboxing with `settings.json`, `--sandbox`, or `GEMINI_SANDBOX`.
> - `allowedPaths` defines which host paths are accessible and also drives `tools.sandboxAllowedPaths`.
> - Combine sandboxing with YOLO mode when you need unattended automation with a smaller blast radius.

## What Sandbox Mode Is

Sandbox mode restricts Gemini CLI tool execution to an isolated environment so shell commands and file operations cannot freely affect the host system. The goal is to reduce risk when commands need to run automatically or when the workspace should be fenced away from the rest of the machine.

## Supported Sandbox Types

| Value | Meaning |
|---|---|
| `"docker"` | Run tools inside a Docker container |
| `"macos-seatbelt"` | Use macOS seatbelt sandboxing on macOS |
| `true` | Auto-detect the best supported sandbox; Docker when available, macOS seatbelt on macOS |

## How to Enable It

You can enable sandboxing in any of these ways.

### Settings

```json
{
  "sandbox": {
    "sandbox": "docker"
  }
}
```

### CLI flag

```bash
gemini --sandbox
```

### Environment variable

```bash
export GEMINI_SANDBOX=docker
```

## Docker Sandbox Configuration

Use a Docker-backed sandbox when you want strong isolation and a reproducible execution environment.

```json
{
  "sandbox": {
    "sandbox": "docker",
    "dockerImage": "gemini-cli-sandbox:latest",
    "dockerVolumes": {
      "/home/user/project": "/workspace",
      "/tmp/output": "/output"
    },
    "allowedPaths": ["/home/user/project"]
  }
}
```

In this configuration:

- `dockerImage` chooses the container image
- `dockerVolumes` maps host paths into the container
- `allowedPaths` limits which host paths Gemini CLI may expose to the sandbox

## What `allowedPaths` Controls

`allowedPaths` is the explicit allowlist of host paths that the sandbox can access. It also controls `tools.sandboxAllowedPaths`, so the same path boundary applies at both the sandbox and tool-policy layers.

Keep this list narrow. Only add paths that the task genuinely needs.

## MCP Servers Inside a Sandbox

MCP servers must be reachable from inside the sandboxed environment. If Gemini CLI is using a Docker sandbox, the MCP server must either run in a way the container can access or be packaged in a Docker-compatible form.

In practice, Docker-based MCP servers are the safest choice when the main Gemini CLI runtime is also sandboxed with Docker.

## YOLO Mode with Sandbox

YOLO mode means Gemini CLI auto-approves tool calls. On its own, YOLO increases execution speed but also removes interactive approval checkpoints.

Sandboxing limits the blast radius of that auto-approved execution. That is why YOLO plus sandbox is a strong fit for CI pipelines and unattended jobs: the session can move quickly, while the sandbox still constrains where tools can run and which files they can touch.

## When Sandbox Mode Is Most Useful

Use sandbox mode when you are:

- Running Gemini CLI in CI
- Allowing shell commands in automation
- Working in a high-trust but high-risk repository
- Protecting the rest of your workstation from accidental tool effects

Sandbox mode is primarily a containment feature. It does not replace careful prompts, path scoping, or credential hygiene.
