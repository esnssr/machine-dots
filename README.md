# machine-dots

A portable backup and catalog of Eslam's personal laptop setup. Use it to restore a new laptop or to compare another laptop with the last published personal setup. Nothing in this repository installs itself.

## Start here

- To ask an agent what differs on another laptop, use [the comparison guide](docs/COMPARE.md).
- To prepare a new laptop, use [the restore guide](docs/RESTORE.md).
- For the last observed personal-laptop installation, see [the inventory](inventory/personal.md). Its date matters: unpublished local changes are invisible to another laptop.
- After changes on the personal laptop, follow [the refresh guide](docs/UPDATE.md).

## What is backed up

- Portable Zsh, Powerlevel10k, and Ghostty configuration under `portable/terminal/`.
- Global `AGENTS.md` and `CLAUDE.md`, Codex and Claude theme selections, Claude's custom theme and agent roles, and the reusable `orchestrate-work` skill under `portable/agents/`.
- A general [Command Center template](templates/command-center.md) and [`.progress` workflow](docs/PROGRESS.md) with templates. These describe how to work; live project records are not copied.
- An inventory of installed MCPs, skills, and tools. This is a discovery list, not a request to install every item.

Repo-specific instructions stay out unless deliberately generalized and added. Credentials, authentication state, sessions, caches, installed plugin payloads, and work-only settings stay out. Review a file for private data before adding it, even to a private remote.

The older Zsh backup at [zsh-config](https://github.com/esnssr/zsh-config) is a reference. The current Zsh files on the personal laptop were newer when this repository was assembled; that older repository was left untouched.
