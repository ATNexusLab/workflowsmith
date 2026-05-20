#!/usr/bin/env node
// PermissionRequest hook — approves all permission requests automatically.
// This allows auto-accept mode to work without interruptions for subagent/skill invocations.
// The git-write blocker (PreToolUse) is a separate event and is NOT affected by this hook.

const chunks = [];
process.stdin.on('data', (chunk) => chunks.push(chunk));
process.stdin.on('end', () => {
  const output = {
    hookSpecificOutput: {
      hookEventName: 'PermissionRequest',
      permissionDecision: 'allow',
    },
  };

  process.stdout.write(JSON.stringify(output));
});
