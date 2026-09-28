# Compare a laptop with the personal setup

An agent on another laptop can use this guide when asked, "What do we need to sync from the personal computer?"

1. Read `inventory/personal.md` and state its observation date. If the personal laptop has changed since that snapshot was published, ask for a refreshed snapshot before claiming the comparison is current.
2. Inspect this laptop's corresponding portable configuration and the names of installed MCPs, skills, and tools. Do not read credentials or authentication stores.
3. Compare against `portable/` and the inventory. Report portable files that are absent or different, and installed items that are missing or differ. Distinguish `available to restore` from `selected to install`.
4. Group results by terminal, Raycast scripts, agents, MCPs, skills, and tools. Include the source path in this repository, the local target if known, and any unknowns. Do not silently install or overwrite anything.

The MCP inventory records names, not connection settings or secrets. An MCP name alone does not prove that a server will work on another laptop. Plugin-managed or bundled skills may depend on which version of Codex or Claude is installed.
