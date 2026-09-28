# Agent instructions for machine-dots

This repository is a dated snapshot of portable setup and installed-item names from the personal laptop. Read `README.md` and the relevant guide before acting.

For a comparison request, follow `docs/COMPARE.md` and report differences without changing the machine. Treat `inventory/personal.md` as the last observed personal state, not a live connection to that laptop. Distinguish an item present in the catalog from one the user selected for this machine.

For a restore request, follow `docs/RESTORE.md`. Review selected files and existing targets before any installation or replacement. Do not read, copy, print, or commit credentials, authentication stores, sessions, or secrets. Do not copy entire application state directories. Respect the user's global and local authorization rules, including the exact `ALLOW PROTECTED EDITS` requirement for protected configuration changes.

For a personal-laptop refresh request, follow `docs/UPDATE.md`. Publish only reviewed portable changes and a dated inventory.

Keep repo-specific instructions and live `.progress` project records out of this repository unless the user explicitly changes that scope. Do not automatically install everything in the inventory.

## Verification

```sh
for file in portable/terminal/zsh/.zshrc portable/terminal/zsh/.zprofile portable/terminal/zsh/.p10k.zsh; do zsh -n "$file" || exit; done
for file in portable/raycast/*.sh; do bash -n "$file" || exit; done
bash -n portable/agents/claude/statusline-command.sh
python3 -m json.tool portable/agents/claude/themes/dark-ansi-contrast.json >/dev/null
python3 -m json.tool portable/agents/claude/theme-selection.json >/dev/null
python3 -m json.tool portable/agents/claude/settings.json >/dev/null
python3 -m json.tool portable/agents/claude/permissions.json >/dev/null
git diff --cached --check
```

Review the Codex TOML settings and changed-file list before publishing. Validate portable Codex values with the installed client's strict configuration check or a TOML parser. Smoke-test Claude's status line with synthetic input rather than reading a live session transcript.
