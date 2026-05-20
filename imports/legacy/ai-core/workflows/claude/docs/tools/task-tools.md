# Task and Session Tools

Tools for managing work within and across sessions: task tracking, background process monitoring, scheduling, and worktree navigation.

---

## Task Management

### `TaskCreate`

Create a task to track in-session work.

```
TaskCreate(title, description?)
```

Returns a `task_id`. Tasks are session-scoped — they don't persist across sessions. Use tasks to break complex work into discrete steps and track progress.

**When to use:** Multi-step implementations where you want to mark progress and avoid losing track of pending sub-tasks.

---

### `TaskGet`

Get details about a specific task.

```
TaskGet(task_id)
```

Returns: `id`, `title`, `description`, `status` (`pending` | `in_progress` | `completed` | `cancelled`).

---

### `TaskList`

List all tasks in the current session.

```
TaskList()
```

Returns all tasks with their status. Use to check what's pending before declaring work complete.

---

### `TaskUpdate`

Update a task's status or details.

```
TaskUpdate(task_id, status?, title?, description?)
```

Standard lifecycle:
```
pending → in_progress → completed
```

Call `TaskUpdate(task_id, "in_progress")` when starting a task.
Call `TaskUpdate(task_id, "completed")` when done.

---

### `TaskStop`

Stop a running background task.

```
TaskStop(task_id)
```

---

### `TaskOutput`

Get the output of a completed task.

```
TaskOutput(task_id)
```

Returns the final output produced by the task.

---

## Background Process Monitoring

### `Monitor`

Stream events from a background process.

```
Monitor(process_id)
```

Each stdout line from the background process fires as a notification. Use with `Bash(command, run_in_background: true)` to watch long-running processes without blocking.

**Pattern for long-running work:**
```
1. Bash("npm run build", run_in_background: true) → returns process_id
2. Monitor(process_id) → receive notifications as build output arrives
3. Handle completion notification
```

Do not use `sleep` to poll background processes — use `Monitor` instead.

---

## Scheduling

### `CronCreate`

Create a recurring scheduled task.

```
CronCreate(schedule, prompt, description?)
```

| Parameter | Type | Description |
|---|---|---|
| `schedule` | string | Cron expression (e.g., `"0 9 * * 1-5"` = weekdays at 9am) |
| `prompt` | string | The task prompt to run on schedule |
| `description` | string | Human-readable description |

Use for recurring automation: daily reports, weekly audits, scheduled cleanups.

---

### `CronDelete`

Remove a scheduled task.

```
CronDelete(cron_id)
```

---

### `CronList`

List all scheduled tasks.

```
CronList()
```

---

### `RemoteTrigger`

Trigger a scheduled remote agent run immediately, without waiting for its next scheduled time.

```
RemoteTrigger(cron_id)
```

| Parameter | Type | Description |
|---|---|---|
| `cron_id` | string | ID of an existing scheduled task (from `CronCreate` or `CronList`) |

**When to use:** Run a routine now instead of waiting — to test a new schedule, kick off a weekly report on demand, or recover from a missed run.

Does not modify the schedule — the task continues on its normal cadence after the manual trigger.

---

### `ScheduleWakeup`

Schedule a one-time future trigger (for `/loop` dynamic pacing).

```
ScheduleWakeup(delaySeconds, prompt, reason)
```

| Parameter | Type | Description |
|---|---|---|
| `delaySeconds` | number | Seconds from now (clamped to 60–3600) |
| `prompt` | string | The `/loop` prompt to fire on wakeup |
| `reason` | string | Short sentence describing the delay purpose |

**Cache-aware delay strategy:**
- Under 270s: stays within Anthropic's 5-minute prompt cache window (warm cache)
- Over 300s: cache miss on wakeup (pay the re-derivation cost)
- For idle loops: default to **1200–1800s** (20–30 min) — minimal cost, loop stays alive
- For polling external state: match the delay to how fast the state actually changes

**Never use to poll background work Claude started** — background Bash and Agent completions fire notifications automatically. Use `ScheduleWakeup` only for external state (CI runs, deploys, remote queues) or idle loop pacing.

Pass the same `/loop` prompt back on each wakeup (or `<<autonomous-loop-dynamic>>` for autonomous loops). Omit the call to end the loop.

---

## Worktree Navigation

### `EnterWorktree`

Navigate into a git worktree.

```
EnterWorktree(path)
```

Changes the working context to the specified worktree path. Used when working with agent-created worktrees or when switching between parallel work branches.

---

### `ExitWorktree`

Return from a worktree to the main working tree.

```
ExitWorktree()
```

---

## Notifications

### `PushNotification`

Send a notification to the user.

```
PushNotification(message)
```

Used by agents to surface status updates to the user without blocking. Fires the `Notification` hook event.

---

## Plan Mode

### `EnterPlanMode`

Enter plan mode — Claude analyzes and writes a plan before executing.

```
EnterPlanMode()
```

After calling this, Claude writes a plan and calls `ExitPlanMode` to surface it for approval. The user must approve before execution proceeds.

Plan files are saved at `~/.claude/plans/` for the duration of the session.

---

### `ExitPlanMode`

Exit plan mode and surface the plan for user approval.

```
ExitPlanMode(plan)
```

The plan text is shown to the user. The user approves or provides feedback. Claude proceeds only after approval.

---

## Composing Tools for Long-Running Automation

Pattern for a `/loop` that polls external state:

```
1. Start external work (e.g., Bash CI trigger, run_in_background: true)
2. ScheduleWakeup(delaySeconds: 270, prompt: same /loop prompt, reason: "polling CI")
3. On wakeup: check state
4. If done: report to user, no more ScheduleWakeup
5. If not done: ScheduleWakeup again
```

Pattern for task-tracked multi-step implementation:

```
1. TaskCreate("Phase 1: auth module")
2. TaskUpdate(id, "in_progress")
3. ... implement ...
4. TaskUpdate(id, "completed")
5. TaskCreate("Phase 2: tests")
6. ...
7. TaskList() to verify all complete before declaring done
```

---

## Related

- [tools/built-in-tools.md](built-in-tools.md) — Read, Edit, Write, Bash, Agent, and other core tools
- [core/context-management.md](../core/context-management.md) — plan mode, /loop, /compact
- [agents/agents-overview.md](../agents/agents-overview.md) — how agents interact with tasks
