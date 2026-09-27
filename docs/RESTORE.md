# Restore on a new laptop

This is a curated setup backup. Choose which parts to use; installing everything is optional.

1. Review the [personal inventory](../inventory/personal.md) and [comparison guide](COMPARE.md) against the new laptop. Check the snapshot date.
2. Select the portable files you want from `portable/`. Review existing target files and make a recoverable copy before replacing them. Do not copy whole Codex, Claude, or Ghostty state directories.
3. Set up the tools, skills, and MCPs you choose from the inventory. The inventory lists names; look up current installation instructions for the versions and platform on the new laptop. Re-enter credentials through each tool's normal authentication flow.
4. Apply the selected global instructions, themes, and terminal files only after reviewing their differences. Protected global settings require the user's authorization under their agent rules.
5. Verify Zsh starts, Ghostty loads its settings, Codex and Claude see the intended instructions and themes, and selected MCPs connect. Record anything intentionally left out.

The Zsh configuration expects Homebrew, Antigen, Powerlevel10k, NVM, and `wut` to be available for the parts that use them. It is a backup of the personal laptop's current configuration; review paths and optional tools before using it on a different machine. The project-specific `run-bet` alias was removed from the portable copy.

Codex currently uses the built-in theme `one-half-light`; its selected setting is in `portable/agents/codex/appearance.toml`. Claude selects `custom:dark-ansi-contrast`; its selection and custom theme are in `portable/agents/claude/`. These files are snippets to review, not replacements for the entire application settings. Ghostty's theme colors are in its backed-up config.
