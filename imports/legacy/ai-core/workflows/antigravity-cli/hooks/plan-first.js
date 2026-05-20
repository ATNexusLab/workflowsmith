#!/usr/bin/env node
// BeforeToolSelection — enforce planning before write operations
// Sentinel: /tmp/.antigravity-plan-active
// If sentinel absent: set all write-capable tools to NONE, pass others DEFAULT.
// If sentinel present: pass all tools DEFAULT.

const fs = require('fs');

const WRITE_TOOLS = ['write_file', 'replace', 'edit', 'run_shell_command'];
const SENTINEL = '/tmp/.antigravity-plan-active';

function respond(tools) {
  process.stdout.write(JSON.stringify({
    output: {
      hookSpecificOutput: {
        BeforeToolSelection: { tools }
      }
    }
  }));
}

try {
  let raw = '';
  process.stdin.setEncoding('utf8');
  process.stdin.on('data', chunk => { raw += chunk; });
  process.stdin.on('end', () => {
    let event;
    try { event = JSON.parse(raw); } catch { respond([]); process.exit(0); }

    const planActive = fs.existsSync(SENTINEL);

    if (planActive) {
      const tools = (event.tools || []).map(t => ({ name: t.name, mode: 'DEFAULT' }));
      respond(tools);
      process.exit(0);
    }

    // No active plan: block all write-capable tools
    process.stderr.write(
      '[plan-first] No active plan detected. ' +
      'Invoke the planning workflow (/start-spec or /bootstrap-project) before write operations.\n'
    );

    const tools = (event.tools || []).map(t => ({
      name: t.name,
      mode: WRITE_TOOLS.includes(t.name) ? 'NONE' : 'DEFAULT'
    }));
    respond(tools);
    process.exit(0);
  });
} catch (err) {
  process.stderr.write(`[plan-first] error: ${err.message}\n`);
  process.stdout.write(JSON.stringify({ output: {} }));
  process.exit(0);
}
