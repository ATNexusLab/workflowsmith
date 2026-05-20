#!/usr/bin/env node
// SessionEnd — remove any git worktrees created during the session
// Only removes worktrees that are NOT the main repo at /home/theo/.gemini
// Fire-and-forget: always exits 0, even on partial failure.

const { execSync } = require('child_process');

const MAIN_WORKTREE = '/home/theo/.gemini';

function ack() {
  process.stdout.write(JSON.stringify({ output: {} }));
  process.exit(0);
}

function listWorktrees() {
  const raw = execSync('git -C "' + MAIN_WORKTREE + '" worktree list --porcelain', {
    encoding: 'utf8',
    timeout: 8000
  });
  // Each block is separated by blank lines; first field is "worktree <path>"
  return raw.trim().split(/\n\n+/).map(block => {
    const match = block.match(/^worktree (.+)/m);
    return match ? match[1].trim() : null;
  }).filter(Boolean);
}

try {
  let raw = '';
  process.stdin.setEncoding('utf8');
  process.stdin.on('data', chunk => { raw += chunk; });
  process.stdin.on('end', () => {
    try {
      const worktrees = listWorktrees();
      const candidates = worktrees.filter(p => p !== MAIN_WORKTREE);

      if (candidates.length === 0) {
        process.stderr.write('[worktree-cleanup] No extra worktrees found.\n');
        ack();
        return;
      }

      let removed = 0;
      let failed = 0;
      for (const wt of candidates) {
        try {
          execSync(`git -C "${MAIN_WORKTREE}" worktree remove --force "${wt}"`, {
            encoding: 'utf8',
            timeout: 10000
          });
          process.stderr.write(`[worktree-cleanup] Removed worktree: ${wt}\n`);
          removed++;
        } catch (e) {
          process.stderr.write(`[worktree-cleanup] Failed to remove ${wt}: ${e.message}\n`);
          failed++;
        }
      }
      process.stderr.write(
        `[worktree-cleanup] Done. removed=${removed} failed=${failed}\n`
      );
    } catch (err) {
      process.stderr.write(`[worktree-cleanup] Cleanup error: ${err.message}\n`);
    }
    ack();
  });
} catch (err) {
  process.stderr.write(`[worktree-cleanup] Fatal error: ${err.message}\n`);
  ack();
}
