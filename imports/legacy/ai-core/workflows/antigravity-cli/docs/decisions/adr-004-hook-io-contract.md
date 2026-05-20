<!-- type: adr | section: decisions -->
# ADR-004: Hook I/O Contract: stdout-only JSON

**Status:** Accepted  
**Date:** 2025

## Context

Gemini CLI supports hooks, which are external executables launched around lifecycle events such as tool execution boundaries. Because hooks may be written in any language, the runtime needs a transport contract that is simple, portable, and deterministic.

The core problem is channel discipline. A hook often needs to both return a structured response and emit human-readable diagnostics. If those outputs share the same stream, even a single debug line can corrupt the structured payload.

A robust contract must therefore define what goes to standard input, what goes to standard output, what goes to standard error, and how exit codes affect control flow.

## Decision

Gemini CLI uses a strict hook I/O contract.

### Stream contract

- **stdin**: the CLI sends the hook a JSON event payload.
- **stdout**: the hook must emit **only valid JSON**.
- **stderr**: the hook must send logs, traces, warnings, and debug output here.

The required response envelope is:

```json
{"output": {}}
```

Event-specific fields are placed inside the `output` object.

### Exit code contract

- **Exit code 0**: success. The CLI reads stdout and processes the JSON response.
- **Exit code 2**: emergency block. The CLI cancels the operation immediately. This is especially relevant for blocking hook points such as `BeforeTool`.
- **Any other non-zero exit code**: warning. The operation continues and stdout is ignored.

The governing rule is: **stdout equals JSON only**. Any non-JSON bytes on stdout, including a banner, `echo`, or debugging statement, invalidate the response and cause the hook to be treated as a warning rather than a structured success.

## Consequences

- ✅ The protocol is language-agnostic and easy to implement in shell, Python, Node.js, or compiled binaries.
- ✅ Structured success and human-readable diagnostics do not interfere with one another when hooks respect stream boundaries.
- ✅ Exit code `2` provides an explicit emergency-stop path without requiring a richer RPC protocol.
- ⚠️ A common implementation mistake is writing debug output to stdout, which silently corrupts the response channel.
- ⚠️ Hook authors must be careful with utilities that write to stdout by default.
- ⚠️ Non-zero exit codes other than `2` do not block execution, so hooks must use the right exit code intentionally.

## Alternatives Considered

### Mixed stdout text plus JSON markers

Hooks could print human-readable text and embed JSON between delimiters.

It was rejected because mixed-channel parsing is fragile, language-specific, and easy to break with incidental output.

### Separate response file

Hooks could write structured output to a file while using stdout freely.

It was rejected because it introduces file lifecycle management, path coordination, and race conditions when multiple hooks run concurrently.

### Named pipe or socket protocol

Hooks could communicate over a richer IPC channel.

It was rejected because the added operational complexity is not justified for small, script-friendly lifecycle integrations.
