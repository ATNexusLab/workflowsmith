<!-- topic: events reference | section: hooks -->
# Hooks Events Reference

> **Quick Reference**
> - Gemini CLI exposes exactly 11 hook events.
> - Every hook receives a JSON event object on stdin and returns a JSON envelope on stdout.
> - `BeforeTool` and `AfterTool` use regex matchers against the tool name.
> - All other events use exact-string matchers.
> - `BeforeToolSelection` is the only event whose results are union-aggregated across multiple hooks.

## Reference Conventions

All output examples in this file use the standard stdout envelope:

```json
{
  "output": {}
}
```

When an event supports a structured mutation or override, that data appears inside the `output` object.

## SessionStart

| Field | Value |
|---|---|
| Fires | On session initialization |
| Matcher | exact-string |

### Input JSON schema

```json
{
  "type": "SessionStart",
  "session": {
    "id": "string",
    "startTime": "string"
  }
}
```

### Output JSON schema

```json
{
  "output": {}
}
```

A `SessionStart` hook is acknowledgment-only.

## SessionEnd

| Field | Value |
|---|---|
| Fires | On session termination |
| Matcher | exact-string |

### Input JSON schema

```json
{
  "type": "SessionEnd",
  "session": {
    "id": "string",
    "startTime": "string"
  },
  "stats": {}
}
```

`stats` is an implementation-defined object with session summary data.

### Output JSON schema

```json
{
  "output": {}
}
```

A `SessionEnd` hook is acknowledgment-only.

## BeforeAgent

| Field | Value |
|---|---|
| Fires | Before an agent or subagent is invoked |
| Matcher | exact-string |

### Input JSON schema

```json
{
  "type": "BeforeAgent",
  "agent": {
    "name": "string"
  }
}
```

### Output JSON schema

Allow:

```json
{
  "output": {}
}
```

Block:

```json
{
  "output": {
    "decision": "BLOCK",
    "reason": "string"
  }
}
```

## AfterAgent

| Field | Value |
|---|---|
| Fires | After an agent completes |
| Matcher | exact-string |

### Input JSON schema

```json
{
  "type": "AfterAgent",
  "agent": {
    "name": "string"
  },
  "result": {}
}
```

`result` is an implementation-defined object that describes the completed agent run.

### Output JSON schema

```json
{
  "output": {}
}
```

A `AfterAgent` hook is acknowledgment-only.

## BeforeModel

| Field | Value |
|---|---|
| Fires | Before each model API call |
| Matcher | exact-string |

### Input JSON schema

```json
{
  "type": "BeforeModel",
  "model": {
    "name": "string"
  },
  "messages": [
    {
      "role": "user|model|system",
      "content": "string"
    }
  ]
}
```

### Output JSON schema

Continue:

```json
{
  "output": {}
}
```

Return a synthetic response instead of calling the model:

```json
{
  "output": {
    "response": {
      "candidates": [
        {
          "content": {
            "parts": [
              {
                "text": "string"
              }
            ]
          }
        }
      ]
    }
  }
}
```

## AfterModel

| Field | Value |
|---|---|
| Fires | After the model API response is received |
| Matcher | exact-string |

### Input JSON schema

```json
{
  "type": "AfterModel",
  "model": {
    "name": "string"
  },
  "response": {}
}
```

`response` is the model response object returned by Gemini CLI.

### Output JSON schema

```json
{
  "output": {}
}
```

A `AfterModel` hook is acknowledgment-only.

## BeforeToolSelection

| Field | Value |
|---|---|
| Fires | Before the model performs tool selection |
| Matcher | exact-string |

### Input JSON schema

```json
{
  "type": "BeforeToolSelection",
  "tools": [
    {
      "name": "string",
      "description": "string"
    }
  ]
}
```

### Output JSON schema

```json
{
  "output": {
    "tools": [
      {
        "name": "string",
        "mode": "DEFAULT|NONE|AUTO"
      }
    ]
  }
}
```

| Mode | Meaning |
|---|---|
| `DEFAULT` | Leave the tool available for normal selection |
| `NONE` | Prevent the tool from being selected |
| `AUTO` | Auto-call the tool |

Multiple `BeforeToolSelection` hooks are union-aggregated. If two hooks mention different tools, the CLI combines their tool decisions; if any hook marks a tool as `NONE`, `NONE` wins for that tool.

## BeforeTool

| Field | Value |
|---|---|
| Fires | Before a specific tool executes |
| Matcher | regex |

### Input JSON schema

```json
{
  "type": "BeforeTool",
  "tool": {
    "name": "string",
    "args": {}
  }
}
```

`args` is the tool argument object the CLI is about to execute.

### Output JSON schema

Proceed:

```json
{
  "output": {}
}
```

Modify arguments:

```json
{
  "output": {
    "tool": {
      "args": {}
    }
  }
}
```

Emergency block:

```text
Exit code 2
```

Exit code `2` cancels the tool call immediately.

## AfterTool

| Field | Value |
|---|---|
| Fires | After a specific tool completes |
| Matcher | regex |

### Input JSON schema

```json
{
  "type": "AfterTool",
  "tool": {
    "name": "string",
    "args": {},
    "result": {}
  }
}
```

### Output JSON schema

Acknowledge the original result:

```json
{
  "output": {}
}
```

Override the tool result:

```json
{
  "output": {
    "result": {}
  }
}
```

## PreCompress

| Field | Value |
|---|---|
| Fires | Before context compression |
| Matcher | exact-string |

### Input JSON schema

```json
{
  "type": "PreCompress",
  "messages": [
    {
      "role": "user|model|system",
      "content": "string"
    }
  ]
}
```

### Output JSON schema

Acknowledge:

```json
{
  "output": {}
}
```

Return modified messages:

```json
{
  "output": {
    "messages": [
      {
        "role": "user|model|system",
        "content": "string"
      }
    ]
  }
}
```

## Notification

| Field | Value |
|---|---|
| Fires | When Gemini CLI generates a notification |
| Matcher | exact-string |

### Input JSON schema

```json
{
  "type": "Notification",
  "notification": {
    "message": "string",
    "level": "string"
  }
}
```

### Output JSON schema

```json
{
  "output": {}
}
```

A `Notification` hook is acknowledgment-only.
