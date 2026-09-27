# Refresh the personal setup snapshot

This repository reflects the personal laptop only after its changes have been reviewed and published. An agent on another laptop cannot see unpublished changes.

When the personal setup changes:

1. Compare the live Zsh, Ghostty, global agent instructions, themes, and authored orchestration files with `portable/`. Review differences and copy only portable changes. Keep repo-specific additions out unless deliberately generalized.
2. Refresh `inventory/personal.md` from the names of installed MCPs, user-managed skills, agent roles, and tools. Update its observation date. Keep connection details and credentials out.
3. Review the repository diff for private data and machine-specific paths. Commit and publish the reviewed change through the normal authorized Git workflow.

The installed-item inventory and portable file copies serve different purposes. A newly installed item should appear in the inventory, but its files are backed up only when deliberately added to `portable/`.
