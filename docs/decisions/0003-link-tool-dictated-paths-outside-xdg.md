---
status: accepted
date: 2026-10-20
---

# Link tool-dictated paths outside XDG

## Context and Problem Statement

This repository keeps the sources of the user environment in `xdg-config-home/`, which `scripts/setup` links into `XDG_CONFIG_HOME`.
Some tools read their configuration only from a fixed path in `$HOME`.
How do these tools get their configuration?

## Considered Options

* Link the fixed path to the source in `XDG_CONFIG_HOME`
* Move the whole tool directory with an environment variable, such as `CLAUDE_CONFIG_DIR` or `CODEX_HOME`

## Decision Outcome

Chosen option: "Link the fixed path to the source in `XDG_CONFIG_HOME`", because the environment variables also move the data, state, and cache of the tool into the configuration directory.

### Consequences

* Good, because every source stays in `XDG_CONFIG_HOME`.
* Bad, because these links deviate from the XDG Base Directory Specification.

## More Information

Revisit each link when its tool reads its configuration from `XDG_CONFIG_HOME`:

| Link | Tool | Revisit when |
| -- | -- | -- |
| `~/.profile` | POSIX sh | A login shell reads `XDG_CONFIG_HOME` |
| `~/.bash_profile`, `~/.bashrc` | Bash | Bash reads `XDG_CONFIG_HOME` |
| `~/.zshenv` | Zsh | Zsh finds `ZDOTDIR` without `~/.zshenv` |
| `~/.claude/CLAUDE.md` | Claude Code | Claude Code separates configuration from data |
| `~/.gemini/GEMINI.md`, `~/.gemini/config/AGENTS.md` | Antigravity | Antigravity reads `XDG_CONFIG_HOME` |
| `${CODEX_HOME:-~/.codex}/AGENTS.md` | Codex | Codex separates configuration from data |
