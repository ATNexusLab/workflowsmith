<!-- topic: patterns and examples | section: hooks -->
# Hooks Patterns and Examples

> **Quick Reference**
> - Every example in this file reads JSON from stdin and writes JSON only to stdout.
> - Use shell hooks for quick policies, Node.js hooks for richer logic, and notification hooks for observability.
> - `BeforeToolSelection` is the safest place to reduce tool exposure before the model chooses tools.
> - Exit code `2` is the simplest emergency stop for `BeforeTool`.
> - Audit hooks should log to files or stderr without changing the structured response.

## Pattern 1: Shell Script Hook (bash)

Use a shell hook when you want a lightweight rule and you already have command-line tools such as `jq` available.

```bash
#!/usr/bin/env bash
# Read JSON from stdin, parse, conditionally block
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool.name')
if [[ "$tool_name" == "run_shell_command" ]]; then
  echo '{"output": {}}' # Allow
else
  echo '{"output": {}}' # Allow all
fi
```

## Pattern 2: Node.js Hook

Use a Node.js hook when you want better JSON handling, richer control flow, or easier reuse across multiple hooks.

```javascript
#!/usr/bin/env node
const chunks = [];
process.stdin.on('data', c => chunks.push(c));
process.stdin.on('end', () => {
  const event = JSON.parse(Buffer.concat(chunks).toString());
  // Process event
  process.stdout.write(JSON.stringify({ output: {} }));
});
```

## Pattern 3: BeforeToolSelection — Disable Dangerous Tools

Use this pattern to reduce tool exposure before the model chooses a tool. Returning `NONE` removes a tool from selection.

```json
{
  "output": {
    "tools": [
      {"name": "run_shell_command", "mode": "NONE"},
      {"name": "write_file", "mode": "DEFAULT"}
    ]
  }
}
```

## Pattern 4: BeforeTool — Emergency Block

Use exit code `2` when you need a hard stop and do not need a richer structured response.

```bash
# Exit with code 2 to block the tool call entirely
exit 2
```

## Pattern 5: AfterTool — Audit Logging

Use an `AfterTool` hook to append metadata to an audit log while leaving Gemini CLI behavior unchanged.

```bash
#!/usr/bin/env bash
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool.name')
timestamp=$(date -Iseconds)
printf '%s\t%s\n' "$timestamp" "$tool_name" >> "$HOME/.gemini/hooks-audit.log"
echo '{"output": {}}'
```

This pattern writes to a file and returns an empty acknowledgment, so the original tool result is preserved.

## Pattern 6: Notification Hook — Desktop Notification

Use a notification hook when you want Gemini CLI alerts to appear outside the terminal.

```bash
input=$(cat)
message=$(echo "$input" | jq -r '.notification.message')
notify-send "Gemini CLI" "$message" 2>/dev/null
echo '{"output": {}}'
```

A notification hook should stay non-blocking from the user's point of view: send the system notification quickly, then acknowledge the event immediately.
