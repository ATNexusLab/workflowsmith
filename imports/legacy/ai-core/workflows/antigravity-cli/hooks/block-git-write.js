#!/usr/bin/env node
// BeforeTool (regex: run_shell_command) — block destructive git write operations
// Matched patterns: git push, git commit, git reset --hard/--soft, git tag,
//                   git branch -D, git rebase, git merge, force-push variants
// Exit 2 = emergency block; exit 0 = pass through

const GIT_WRITE_PATTERNS = [
  /git\s+push(\s|$)/,
  /git\s+commit(\s|$)/,
  /git\s+reset\s+--hard/,
  /git\s+reset\s+--soft/,
  /git\s+tag(\s|$)/,
  /git\s+branch\s+-D/,
  /git\s+rebase(\s|$)/,
  /git\s+merge(\s|$)/,
  /git\s+push\s+--force/,
  /git\s+push\s+-f(\s|$)/,
];

function allow() {
  process.stdout.write(JSON.stringify({ output: {} }));
  process.exit(0);
}

try {
  let raw = '';
  process.stdin.setEncoding('utf8');
  process.stdin.on('data', chunk => { raw += chunk; });
  process.stdin.on('end', () => {
    let event;
    try { event = JSON.parse(raw); } catch { allow(); return; }

    const command = event?.tool?.args?.command || '';

    const matched = GIT_WRITE_PATTERNS.find(re => re.test(command));
    if (matched) {
      process.stderr.write(
        `[block-git-write] Blocked: "${command.slice(0, 120)}"\n` +
        '[block-git-write] Direct git write operations require explicit user approval. ' +
        'Use the /git-commit or /git-push workflow commands instead.\n'
      );
      process.exit(2);
    }

    allow();
  });
} catch (err) {
  process.stderr.write(`[block-git-write] error: ${err.message}\n`);
  process.stdout.write(JSON.stringify({ output: {} }));
  process.exit(0);
}
