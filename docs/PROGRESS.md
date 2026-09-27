# Durable `.progress` workflow

Use `~/.progress/<project>/` for resumable project state shared by agents. This document describes the workflow; the live project records stay on their own machines.

```text
~/.progress/<project>/
  index.md                 current state and next action
  command-center.md        optional stable coordination policy
  active/                  resumable tasks and worker records
  archive/YYYY/MM/         completed or cancelled records
  evidence/                larger supporting artifacts
```

- Read `index.md` before resuming work, then only the task records needed for the current decision.
- Start an active task record with `agent: codex|claude` and its session or thread ID. Record the checkout and exclusive writer.
- Update the record at meaningful checkpoints, handoff, and pause; reconcile the short live state into `index.md`.
- Move terminal records to `archive/YYYY/MM/`. Keep project-specific facts in that project's records. Do not store secrets.
- Use [the index template](../templates/progress-index.md), [task template](../templates/progress-task.md), and optional [Command Center template](../templates/command-center.md) when starting a new project.

The global instructions in `portable/agents/global/` and the `orchestrate-work` skill provide the fuller rules for delegation and handoff.
