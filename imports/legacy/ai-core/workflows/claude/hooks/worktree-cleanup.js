#!/usr/bin/env node
// SessionEnd hook — removes stale Claude worktrees from the session's repo.
// Claude Code creates worktrees with a "claude-" prefix; this cleans them up on exit.
// Skips: the main worktree, locked worktrees (actively in use), repos with no worktrees.

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const chunks = [];
process.stdin.on('data', (chunk) => chunks.push(chunk));
process.stdin.on('end', () => {
  let input = {};
  try {
    input = JSON.parse(Buffer.concat(chunks).toString() || '{}');
  } catch (_) {}

  const cwd = input.cwd || process.cwd();

  try {
    const gitRoot = execSync('git rev-parse --show-toplevel', {
      cwd,
      encoding: 'utf8',
      stdio: ['pipe', 'pipe', 'pipe'],
    }).trim();

    const raw = execSync('git worktree list --porcelain', {
      cwd: gitRoot,
      encoding: 'utf8',
      stdio: ['pipe', 'pipe', 'pipe'],
    });

    // Parse porcelain output into worktree objects
    const worktrees = [];
    let current = null;
    for (const line of raw.split('\n')) {
      if (line.startsWith('worktree ')) {
        if (current) worktrees.push(current);
        current = { wtPath: line.slice('worktree '.length).trim() };
      } else if (line === '' && current) {
        worktrees.push(current);
        current = null;
      }
    }
    if (current) worktrees.push(current);

    const stale = worktrees.filter((w) => {
      const name = path.basename(w.wtPath);
      return name.startsWith('claude-') && w.wtPath !== gitRoot;
    });

    for (const wt of stale) {
      // Skip if the worktree is locked (still active)
      const lockFile = path.join(gitRoot, '.git', 'worktrees', path.basename(wt.wtPath), 'locked');
      if (fs.existsSync(lockFile)) continue;

      try {
        execSync(`git worktree remove --force "${wt.wtPath}"`, {
          cwd: gitRoot,
          encoding: 'utf8',
          stdio: ['pipe', 'pipe', 'pipe'],
        });
      } catch (_) {
        // Non-fatal — skip if removal fails (e.g. already gone)
      }
    }

    if (stale.length > 0) {
      execSync('git worktree prune', {
        cwd: gitRoot,
        encoding: 'utf8',
        stdio: ['pipe', 'pipe', 'pipe'],
      });
    }
  } catch (_) {
    // Not a git repo, git unavailable, or no worktrees — silently skip
  }

  process.stdout.write('{}');
});
