#!/usr/bin/env node
// BeforeToolSelection — auto-approve read-only tools (no per-call permission prompt)
// Read-only tools: read_file, read_many_files, list_directory, glob, grep
// All other tools remain DEFAULT.

const READ_ONLY_TOOLS = [
  'read_file',
  'read_many_files',
  'list_directory',
  'glob',
  'grep',
];

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

    const tools = (event.tools || []).map(t => ({
      name: t.name,
      mode: READ_ONLY_TOOLS.includes(t.name) ? 'AUTO' : 'DEFAULT'
    }));

    process.stderr.write(
      `[auto-approve-permissions] Auto-approved ${tools.filter(t => t.mode === 'AUTO').length} read-only tool(s).\n`
    );

    respond(tools);
    process.exit(0);
  });
} catch (err) {
  process.stderr.write(`[auto-approve-permissions] error: ${err.message}\n`);
  process.stdout.write(JSON.stringify({ output: {} }));
  process.exit(0);
}
