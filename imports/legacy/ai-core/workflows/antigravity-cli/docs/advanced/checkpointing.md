<!-- topic: checkpointing | section: advanced -->
# Checkpointing

## Quick Reference

> - Checkpointing snapshots file state before Gemini CLI modifies a file.
> - Snapshots live in a shadow Git repository under `~/.gemini/history/<project_hash>/`.
> - The shadow repository is separate from your project Git repository and does not interfere with it.
> - Snapshots are created before `write_file` and `replace` run.
> - Use `/restore` for file rollback and `/rewind` for conversation rollback; they are different operations.

## What Checkpointing Is

Checkpointing is Gemini CLI's built-in file safety system. Before each file modification, Gemini CLI records the current file state in an internal shadow Git repository so you can restore a file to an earlier point from the same session.

This feature protects the working tree without rewriting your project's own Git history.

## How to Enable It

Enable checkpointing in `settings.json`:

```json
{
  "general": {
    "checkpointing": true
  }
}
```

The old `--checkpointing` CLI flag was removed in v0.11.0. If you used that flag in older versions, move the configuration into `settings.json`.

## Where Checkpoints Live

Gemini CLI stores the shadow Git repository here:

```text
~/.gemini/history/<project_hash>/
```

Important properties of this repository:

- It is auto-created on the first checkpoint
- It is managed entirely by Gemini CLI
- It does not interfere with your project's Git repository
- It exists only to track Gemini CLI session restore points

## When Snapshots Are Created

Gemini CLI creates a snapshot immediately before these file-modifying tools run:

- `write_file`
- `replace`

That means each checkpoint represents the last known file state before the next change happened.

## Slash Commands

| Command | Description |
|---|---|
| `/restore` | List all available checkpoints for the current session |
| `/restore <checkpoint_id>` | Restore file(s) to a specific checkpoint |
| `/rewind` | Navigate conversational history backward without restoring files |

## Using `/restore`

Run `/restore` with no argument to inspect available restore points.

```bash
/restore
```

Restore a specific checkpoint by passing its identifier:

```bash
/restore <checkpoint_id>
```

Gemini CLI then reverts the affected file content to the snapshot recorded at that checkpoint.

## `/restore` vs `/rewind`

These commands solve different problems.

| Command | Type of operation | What changes |
|---|---|---|
| `/restore` | File-system operation | Actual file content is reverted to an earlier snapshot |
| `/rewind` | Conversational operation | Conversation turns move backward, but files stay as they are |

Use `/restore` when the workspace content is wrong. Use `/rewind` when the conversation state is wrong.

## Practical Restore Model

Think of checkpointing as a session-local safety net:

1. Gemini CLI is about to edit a file
2. It records the current state in the shadow repository
3. The edit happens
4. If the result is wrong, you restore the earlier checkpoint

Because the snapshot lives outside the project repository, checkpointing gives you rollback without mixing Gemini CLI internals into your normal Git workflow.
