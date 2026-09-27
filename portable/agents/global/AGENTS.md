# Global agent working agreements

These rules apply to every coding agent (Codex, Claude Code). Tool-specific differences live in each tool's own override file, such as `~/.claude/CLAUDE.md`.

## Start and scope

- Read applicable instructions and relevant project documentation before editing.
- Inspect first, preserve unrelated user work, and use the project's established tools and patterns.
- Work only in the assigned workspace and write scope. Ask when ambiguity could change scope, behavior, authorization, or an external action.

## References and links

- When you mention an external item, put its full URL in the same sentence, not just its ID. External items include Linear issues, GitHub PRs, issues, commits and Actions runs, docs, dashboards and other web resources. Example: `PR #7 (https://github.com/<org>/<repo>/pull/7)` or `[ENG-123](https://linear.app/<team>/issue/ENG-123)`.
- This applies everywhere agents write: chat replies, status reports, worker handoffs, `~/.progress/` records, commit messages and PR descriptions.
- If you don't have the URL, look it up with `gh`, Linear or the relevant tool instead of giving a bare ID. If you can't find it, say so.

## Workspace and quality

- Give each checkout one exclusive writer. Launch workers at their assigned checkout or worktree, and verify its path, branch/revision, Git state, and ownership before editing.
- When supported, grant a worker access only to its workspace and assigned `~/.progress/<project>/` directory. Never broaden access to all of an agent's config directory (`~/.codex`, `~/.claude`, `~/.agents`) or the home directory.
- Work in the repo's main checkout by default. Use a `wut` worktree only when the user asks for one or when the main checkout already has ongoing work: an active `~/.progress/<project>/` record for that repo, another agent writing there, or uncommitted changes you didn't make.
- If the main checkout has uncommitted changes you didn't make, always ask whether to stash them or use a worktree. Never stash, move, or overwrite them without asking.
- Use `wut` to create worktrees. Do not remove local branches unless specifically authorized.
- Follow the project's verification workflow. Each repo lists its gate commands in a `## Verification` section of its `AGENTS.md`. Workers own applicable UI, build, test, lint/static-check, and code-review gates (Codex review in Codex, `/code-review` in Claude Code); they fix actionable findings and repeat review before handoff. Do not spawn nested reviewers or workers unless explicitly authorized.
- Prefer project tools or MCPs. For iOS, use configured Xcode tooling and RocketSim when required; do not use `swift build`. Swift Package Manager commands are allowed for backend projects.
- Ignore TODOs unless asked; prioritize TODOs explicitly marked for agent work. Required source headers use `Eslam Nasser assisted by <agent>`, where `<agent>` is the tool doing the work (`Codex` or `Claude`); never alter Git identity to achieve this.

## Git, external actions, and protected state

- Preserve Git identity, signing, remotes, credentials, and configuration. Never discard work, reset, force-push, delete a repository, or perform broad deletion without an exact request.
- Staging, commits, pushes, pull requests, merges, releases, messages, and external-system changes require explicit authorization. Do not infer merge or release authority. Resolve only review threads whose findings were addressed and pushed.
- Never inspect, print, copy, migrate, or change credentials, keys, tokens, auth stores, browser/connector sessions, cookies, Keychain data, or secret files.
- Global agent configuration (`~/.codex`, `~/.claude`, `~/.agents`), instructions, rules, hooks, Git configuration, shell profiles, OS settings, app preferences, authentication, credentials, and package-manager configuration require the exact phrase `ALLOW PROTECTED EDITS` and explicit scope.

## Durable work and Command Centers

- Keep resumable project state under `~/.progress/<project>/`: `index.md` is the live-state authority; `active/` holds resumable records; `archive/YYYY/MM/` holds terminal records; `evidence/` holds larger artifacts. Do not replace or delete the `~/.progress` root.
- `~/.progress` is shared by all agents. Each active record states `agent: codex|claude` and its session/thread ID. One writer per checkout applies across tools: never run Codex and Claude as writers in the same checkout.
- Write plans and lasting project facts to `~/.progress` (or repo docs), not to a tool's private plan or memory storage, so every agent can read them.
- Keep project-specific paths, decisions, tools, and release rules in project records. Keep reusable coordination policy in the `orchestrate-work` skill.
- A Command Center coordinates and delegates. Respect whether the user asked to discuss or implement. Match assignment detail to task complexity: for simple, clear work, give a concise task, relevant boundaries, and completion criteria; for complex, ambiguous, or long-running work, also state the goal and intended outcome. Let the worker choose the means within the assignment.
- Treat a status request as a bounded read-only reconciliation. Report newly found issues; route authorized implementation and deep review to the worker that owns the work. A status request alone does not authorize the coordinator to fix code or run the worker's quality gate.
- Workers send their coordinator direct, evidence-based completion or blocker handoffs with changed files, Git/index state, risks, and next action. The coordinator independently reconciles the handoff with the workspace and progress index.
- Keep an existing heartbeat active only while delegated work runs unattended. Pause it at discussion, user-action, blocker, wait, or idle boundaries; never duplicate it. Do not foreground-watch or repeatedly poll workers.
