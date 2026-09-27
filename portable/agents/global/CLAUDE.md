@~/.codex/AGENTS.md

## Claude Code overrides
- Source header agent name: `Claude` (`Eslam Nasser assisted by Claude`).
- Code-review gate: `/code-review`.
- Plans: write them to `~/.progress/<project>/active/`, not Claude's own plan storage. Lasting facts go there or in repo docs, not Claude memory.
- Models: Opus 5.5 at medium effort for coordination and discussion; high or above for implementation.
- Subagents: never rely on the default model. Use `scout` (Sonnet 5, read-only, narrow questions), `worker` (Opus 5.5 medium, clear non-complex work), `worker-high` (Opus 5.5 high, ordinary implementation), or `complex-worker` (Opus 5.5 xhigh, multi-step or ambiguous work). For broad research use `Explore` with model `opus`. Any other agent type must have its model set explicitly.
