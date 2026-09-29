# Portable global agent settings

Observed on the personal laptop: 2026-09-28. These are selected global settings, intended for review and merging into a destination laptop's user configuration. They are not complete replacements for existing settings.

| Backup | Original target | Contents |
| --- | --- | --- |
| `portable/agents/claude/settings.json` | `~/.claude/settings.json` | Model and per-model effort preferences, status line command, theme, editor mode, syntax highlighting, plugin selections, and the custom marketplace |
| `portable/agents/claude/statusline-command.sh` | `~/.claude/statusline-command.sh` | Unchanged status line script: model, effort, fast mode, directory, Git changes, subagent count and each agent's type/model/effort, five-hour and weekly usage percentages, and session ID |
| `portable/agents/claude/permissions.json` | Merge into `~/.claude/settings.json` | Optional global allow and deny rules, stored separately because they change what can run without prompting |
| `portable/agents/codex/config.toml` | Merge into `~/.codex/config.toml` | Model, effort, personality, approval and sandbox defaults, feature and memory preferences, terminal status line, and desktop appearance and interaction preferences |
| `portable/agents/codex/rules/default.rules` | `~/.codex/rules/default.rules` | Unchanged global command rules; review before restoring |

The Claude status line runs through Bash and needs `jq` and Git. It reads the session data Claude supplies at runtime; no transcripts or session data are included in this repository.

Status line refreshed: 2026-09-29. Agent model and effort come from their logs, with agent-definition fallbacks marked `?` before the first reply. Completed, failed, killed, stopped, and cancelled agents are excluded from the running count. When rate limits are supplied, the script saves the timestamp, session ID, and rate limits to `~/.claude/usage-latest.json` through a temporary file and rename. That runtime usage file is not backed up.

Known limitation in this unchanged backup: agent labels do not read Claude's `perTurnEffort` field. When it differs from the older `effort` field, the label can show the older effort or omit effort entirely. A synthetic record with `effort: medium` and `perTurnEffort: high` displays `med`.

The smaller theme-selection snippets already in this repository remain convenient alternatives when only restoring a theme. Their selections agree with these fuller settings snapshots.

## Deliberately excluded

- Claude's `autoMode` block contains project-specific context in the source global settings. It is omitted, along with `permissions.defaultMode = auto`, so a restore does not select auto mode without its environment context. Choose the destination's permission mode separately.
- Codex project trust entries, per-path editor choices, connector-specific tool approvals, MCP connection details, and local plugin/runtime paths are omitted.
- Codex's notification hook points at a local computer-use application binary. It is managed by that installation and is not backed up here.
- Credentials, environment secrets, authentication stores, sessions, and onboarding state are excluded.

The source files on the personal laptop were not changed. Model and effort values are snapshots of those settings, not a migration or a recommendation for the destination laptop. Review permission settings and global rules together with your global instructions before applying them.

## References

- [Codex configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference).
- [Claude Code settings and precedence](https://code.claude.com/docs/en/settings) and [status line documentation](https://code.claude.com/docs/en/statusline).
- The custom Claude marketplace is [crit](https://github.com/tomasz-tomczyk/crit).
