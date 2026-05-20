<!-- topic: remote agents | section: agents -->
# Remote Agents

> **Quick Reference**
> - A remote agent runs at a remote HTTP endpoint that speaks the A2A protocol.
> - Set `kind: remote` to mark the agent as remote.
> - Remote agents require a `url` field in frontmatter.
> - Supported auth types are `apiKey`, `http`, `google-credentials`, and `oauth`.
> - Remote agents introduce a network and trust boundary that local agents do not have.

## What remote agents are

A **remote agent** is an agent definition whose execution happens outside the local Gemini CLI process. Instead of running the worker locally, Gemini CLI sends the delegated task to a remote HTTP endpoint that implements the **A2A protocol**.

Remote agents let you connect Gemini CLI to externally hosted workers while preserving the same high-level delegation model: the parent session chooses the agent, hands off the task, and waits for the result.

## Remote frontmatter contract

Remote agents use the shared agent frontmatter fields and add remote-execution fields.

| Field | Type | Required | Description |
|---|---|---|---|
| `kind` | string | yes for remote agents | Must be `remote` |
| `url` | string | yes | HTTP endpoint for the remote A2A agent |
| `auth` | object | no | Authentication configuration for the remote endpoint |

## Remote agent example

```yaml
---
name: remote-researcher
description: Research agent running on remote server
kind: remote
url: https://my-a2a-server.example.com/agent
auth:
  type: apiKey
  apiKey: ${REMOTE_AGENT_API_KEY}
---
```

## Supported authentication types

| Auth type | What it is for | Typical fit |
|---|---|---|
| `apiKey` | Static API key presented to the remote service | Simple service-to-service setups where the provider issues fixed keys |
| `http` | HTTP bearer-token style authentication | Services that expect standard HTTP authorization headers |
| `google-credentials` | Google service account based authentication | Remote agents hosted behind Google Cloud identity controls |
| `oauth` | OAuth2 flow | User- or tenant-scoped remote services that require delegated authorization |

## How remote and local execution differ

| Aspect | Local agent | Remote agent |
|---|---|---|
| Execution location | Inside the local Gemini CLI execution environment | On a remote service reached over HTTP |
| Network dependency | None required for execution itself | Required to reach the remote endpoint |
| Tool execution | Controlled by the local agent configuration and local runtime | Depends on what the remote A2A service implements and exposes |
| Trust boundary | Mostly local process and local tools | External service boundary with its own logging, storage, and policies |
| Failure modes | Local tool or runtime issues | Network failures, auth failures, remote service errors, or protocol mismatches |

## Security considerations

Remote agents require stricter operational discipline than local agents because task content leaves the local process.

### Treat the endpoint as an external trust boundary

Anything delegated to the remote agent may be observable by the remote service operator. Send only the context the remote agent actually needs.

### Use HTTPS and managed credentials

Prefer HTTPS endpoints and store credentials outside the agent file body, typically through environment-variable substitution such as `${REMOTE_AGENT_API_KEY}`.

### Scope credentials narrowly

Use the least privilege that still lets the remote agent do its job. Rotate keys and tokens on the same schedule you would use for any external integration.

### Verify ownership and compliance

Before adopting a remote endpoint, verify who runs it, how it stores logs, how long data is retained, and whether its location and controls fit your compliance needs.

### Plan for network failure

Remote agents can fail because of unreachable endpoints, expired credentials, or upstream service instability. Design delegations so a remote-agent failure is diagnosable and recoverable.
