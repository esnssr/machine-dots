# Personal laptop inventory

Observed: 2026-09-27 22:41 CEST. This is a snapshot, not a live view. Names show what was installed or configured on this laptop; they do not mean every item should be installed elsewhere. Refresh this file after meaningful personal-laptop setup changes and publish it before asking another laptop for a current comparison.

## Portable configuration in this repository

- Zsh: `portable/terminal/zsh/.zshrc`, `.zprofile`, and `.p10k.zsh`. The repo-specific `run-bet` alias was omitted.
- Ghostty: `portable/terminal/ghostty/config.ghostty`, using `Xcode Dark` with custom colors.
- Global agent rules: `portable/agents/global/AGENTS.md` and `CLAUDE.md`.
- Claude theme: `portable/agents/claude/themes/dark-ansi-contrast.json` and `theme-selection.json`; selected theme `custom:dark-ansi-contrast`.
- Codex theme: built-in `one-half-light`; the selection is in `portable/agents/codex/appearance.toml`. The full Codex config is not copied.
- Reusable orchestration: `portable/agents/skills/orchestrate-work/`, Claude agent roles, and the Command Center and `.progress` guides/templates.

## MCP names

Names only; no connection settings or credentials are stored here.

### Codex

- `XcodeBuildMCP`
- `codex_app`
- `computer-use`
- `cua_repl`
- `mobbin`
- `node_repl`
- `posthog`
- `revenuecat`
- `sketch`
- `xcode`

### Claude Code

- `XcodeBuildMCP`
- `xcode`
- `sketch`
- `revenuecat`
- `mobbin`
- `posthog`

## Skills

### Shared user-managed skills (`~/.agents/skills`)

These are the installed names. `orchestrate-work` is backed up in this repository; other skills are listed for discovery and can be added selectively later.

- `a11y-audit`
- `address-agent-todos`
- `asc-app-create-ui`
- `asc-aso-audit`
- `asc-build-lifecycle`
- `asc-cli-usage`
- `asc-crash-triage`
- `asc-id-resolver`
- `asc-localize-metadata`
- `asc-metadata-sync`
- `asc-notarization`
- `asc-ppp-pricing`
- `asc-release-flow`
- `asc-revenuecat-catalog-sync`
- `asc-screenshot-resize`
- `asc-shots-pipeline`
- `asc-signing-setup`
- `asc-submission-health`
- `asc-subscription-localization`
- `asc-testflight-orchestration`
- `asc-wall-submit`
- `asc-whats-new-writer`
- `asc-workflow`
- `asc-xcode-build`
- `finalize-pr-workflow`
- `find-skills`
- `gh-fix-ci`
- `gh-stack`
- `head-of-product-command-center`
- `head-of-product-kpi-review`
- `head-of-product-post-meeting`
- `head-of-product-roadmap-review`
- `head-of-product-weekly-cleanup`
- `linear`
- `linear-release-setup`
- `orchestrate-work`
- `rocketsim`
- `session-summary`
- `spm-build-analysis`
- `test-audit`
- `update-core-branch`
- `xcode-build-benchmark`
- `xcode-build-fixer`
- `xcode-build-orchestrator`
- `xcode-compilation-analyzer`
- `xcode-project-analyzer`

### Claude Code skill links

46 skill entries in `~/.claude/skills` resolve to skill files. They mirror the shared user-managed skills except for any local differences; compare the installed names on the destination rather than assuming all are active.

### Codex built-in skills

- `imagegen`
- `openai-docs`
- `plugin-creator`
- `review-agent`
- `skill-creator`
- `skill-installer`

### Codex installed plugins and their skills

Observed through `codex plugin list --json`; only the installed plugin versions were used to identify skills. These are listed for discovery and are not copied into this repository.

| Plugin | Enabled | Skills in installed version |
| --- | --- | --- |
| documents | Yes | documents |
| pdf | Yes | pdf |
| spreadsheets | Yes | spreadsheets, excel-live-control |
| presentations | Yes | presentations |
| template-creator | Yes | template-creator |
| codex-app-tools | Yes | None |
| browser | Yes | None |
| unified-computer-use | Yes | None |
| chrome | No | control-chrome |
| computer-use | Yes | None |
| visualize | Yes | visualize |
| linear | Yes | linear |
| github | Yes | github, gh-address-comments, gh-fix-ci, yeet |
| notion | Yes | notion-knowledge-capture, notion-meeting-intelligence, notion-research-documentation, notion-spec-to-implementation |

Plugin caches can contain old versions, so cached folders alone are not treated as installed skills.

## Claude Code agent roles

- `complex-worker`
- `scout`
- `worker`
- `worker-high`

Their definitions are backed up under `portable/agents/claude/agents/`.

## Tools

### Homebrew formulae observed

This includes dependencies. Compare names and choose tools intentionally on another laptop.

- `act`
- `actionlint`
- `asc`
- `bitrise`
- `brotli`
- `c-ares`
- `ca-certificates`
- `crit`
- `gettext`
- `gh`
- `glow`
- `gmp`
- `gzip`
- `icu4c@76`
- `icu4c@78`
- `json-c`
- `krb5`
- `libnghttp2`
- `libunistring`
- `libuv`
- `libyaml`
- `lz4`
- `mint`
- `node`
- `openssl@3`
- `postgresql@17`
- `readline`
- `ruby`
- `shellcheck`
- `swiftformat`
- `swiftgen`
- `swiftlint`
- `wut`
- `xcbeautify`
- `xcode-build-server`
- `xcodebuildmcp`
- `xcodegen`
- `xz`
- `zstd`

### Applications and other CLIs observed

- Ghostty
- Codex
- Claude Code
- Homebrew
- Zsh with Antigen, Powerlevel10k, and NVM references in the backed-up configuration
