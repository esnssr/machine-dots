---
name: orchestrate-work
description: Coordinate safe, project-agnostic multi-agent engineering work. Use when creating or operating a Command Center, delegating investigations or implementation, establishing worker ownership and handoffs, or reviewing a project's orchestration workflow.
---

# Orchestrate Work

Use a Command Center to discuss, delegate, supervise, and integrate work. It is the coordinator, not the default implementation worker. Preserve the user's authority over external and irreversible actions.

## Roles and model routing

Keep the worker's model and effort explicit in its assignment. Raise the Command Center's effort for a difficult decision; use a lower effort for a quick, well-scoped read when practical.

| Role | Codex | Claude Code |
|---|---|---|
| Command Center | GPT-6 Sol, Medium | Opus 5.5, Medium |
| Read-only Scout (narrow, repeatable) | GPT-6 Luna, High | Sonnet 5 or Haiku 4.5 |
| Read-only Scout (broad or ambiguous) | GPT-6 Sol, Medium or High | Opus 5.5, Medium |
| Implementation Worker | GPT-6 Sol, Medium (Luna, High for clear, repeatable work with objective criteria) | Opus 5.5, Medium for clear non-complex work; High otherwise |
| Complex Worker | GPT-6 Sol, High (Extra High only when High is insufficient) | Opus 5.5, High or above |

- A **Scout** reads and reports; it does not edit, delegate, or change state.
- An **Implementation Worker** owns one goal and does not delegate.
- A **Complex Worker** may use at most one narrow read-only Scout when explicitly assigned and needed.

Do not make Luna Extra High a default. Choose by the task's ambiguity, consequences, and verification burden. Respect model availability and project conventions; a role label never bypasses safety or authorization.

For Codex CLI calls, use the configured model unless the assignment requires an explicit override. `-m` overrides the configured default; do not carry an older model pin into a new review command.

## Intake and delegation

Respect whether the user wants discussion, investigation, or implementation. When the user is still discussing an approach, help clarify the options and wait for direction before assigning implementation.

Treat a status request as a bounded read-only reconciliation of the progress index, worker handoff, and immediate Git or PR evidence. Report any new issue. If a worker already owns an authorized task, steer or delegate the needed follow-up to that worker; otherwise bring the decision to the user. Finding a problem during a status check does not authorize the coordinator to edit project code, run builds or tests, or perform a local code review. Even when a fix is authorized, the worker owns substantive implementation and review.

Before dispatch, read the compact project `index.md`, applicable instructions, and only the task records needed to make the decision. Inspect active workspaces and reuse a compatible worker rather than duplicating work.

Calibrate the assignment to the task. For a simple, unambiguous implementation,
give a concise instruction with the relevant scope, boundaries, and completion
criteria. Do not add a separate abstract goal when it adds no useful direction.

For complex, ambiguous, multi-step, or long-running work, also state the goal
and intended outcome, non-goals, constraints, and required verification. In both
cases, specify the assigned checkout/workspace and exclusive write ownership,
include relevant project conventions and user decisions, and ask for concise
evidence and decisions rather than hidden reasoning.

State the result and boundaries clearly, but do not prescribe every implementation step when the worker can choose safe means within the assignment. If the goal or a material decision is unclear, bring it back to the user. Split work only when write scopes do not overlap; otherwise serialize it. Preserve existing work and unknown dirty state.

Create or update the task record under `~/.progress/<project>/active/` at start, material checkpoints, blockers, and handoff. Reconcile it into the compact `index.md`; move terminal records to `archive/YYYY/MM/` rather than deleting them.

## Worker quality and handoff

The implementation owner runs the project's configured quality gate: applicable UI verification, build, tests, lint/static checks, and local code review (Codex review in Codex, `/code-review` in Claude Code). Fix actionable findings and repeat review until clean. Do not impose tools from another project or spawn nested reviewers/workers unless the assignment explicitly authorizes one narrow investigation. If review cannot run, report the exact blocker. Use the inherited authenticated agent context; do not inspect or alter authentication material.

In Codex, keep config validation separate from code review. `--strict-config` detects unrecognized Codex configuration fields; it does not strengthen a review. Use it when validating a Codex configuration change or upgrade, not as a routine `codex review` flag. Choose the review target (`--uncommitted`, `--base`, or an explicit commit) from the work being reviewed, and inherit the configured model unless the assignment calls for an override.

Each worker directly messages the coordinator with the task outcome, changed files, Git/index state, verification evidence, risks, and next action. The coordinator independently checks the handoff against the workspace, task record, and progress index before declaring work complete.

Keep commits, staging, pushes, pull requests, releases, and external mutations opt-in unless the user authorized that bounded workflow. Never discard changes or modify global/machine settings as a side effect of project work.

## Tool mapping

| Concept | Codex | Claude Code |
|---|---|---|
| Worker | Codex task/thread | Subagent (`Agent` tool) or a separate `claude` session in the worker's checkout |
| Message a worker | Thread message | `SendMessage` to the agent's ID or name |
| Heartbeat | Automation | `/loop` or a scheduled cron; background agents notify on completion, so do not poll |
| Worktree | `wut` | `wut`, then start `claude` in that directory |
| Role → agent type | Set model/effort per task | `scout`, `worker` (Opus medium), `worker-high` (Opus high), `complex-worker` (Opus xhigh) in `~/.claude/agents/` |

Record each worker's agent (`codex` or `claude`) and session/thread ID in its `~/.progress` record. Never assign Codex and Claude writers to the same checkout.

## Heartbeat and supervision

Use the existing project heartbeat only while delegated work is progressing unattended. Keep it **paused** during user discussion or direct work, when a worker needs a user decision, while work is idle, or while only CI/review is pending. Resume the same heartbeat when unattended worker execution resumes; never create a duplicate.

Each heartbeat run is a bounded status reconciliation against the live index and worker handoffs. It may update one compact summary and steer a worker toward the assigned goal when evidence shows drift. It must not implement work, foreground-watch, or repeatedly poll. Notify only for material completion, blocker, conflict, required decision, ownership change, or unexpected Git/index drift. Because a scheduled heartbeat can appear in its attached task, do not leave it active during user-facing interaction.

Keep reusable coordination policy here, universal safety rules in global instructions, and project-specific paths, tools, releases, task state, and evidence in project progress records.
