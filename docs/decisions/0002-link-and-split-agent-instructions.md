# Link and split agent instructions

## Context and Problem Statement

Each agent reads global instructions from a file in `$HOME`, such as `~/.claude/CLAUDE.md`.
Tools write into these files without asking; for example, the CodeGraph and agent-lsp installers appended instruction blocks to `~/.claude/CLAUDE.md` and `~/.gemini/GEMINI.md`.
Global instructions also apply in every repository, including repositories of other people.
How are the global instructions kept, and what do they contain?

## Decision Outcome

Chosen option: "Link every global instruction file to one tracked file, and keep only the way of working in it", because:

* a tool write then shows up in `git diff` before it is committed;
* a personal project convention, such as recording every deviation, then does not leak into other repositories, as a user-level linter configuration would.

`scripts/setup` links the global instructions of each installed agent to `xdg-config-home/agents/AGENTS.md`:

* `~/.claude/CLAUDE.md`
* `~/.gemini/GEMINI.md`
* `~/.gemini/config/AGENTS.md`
* `${CODEX_HOME:-~/.codex}/AGENTS.md`

The project conventions live in `xdg-templates-dir/AGENTS.md`, which reaches only projects created from the templates.
The global file states that project instructions take precedence over it.

### Consequences

* Good, because every tool write is reviewed before it is committed.
* Good, because all agents share one instruction file, and the conventions of other repositories stay untouched.
* Bad, because a tool write reaches every agent until it is reviewed.
* Bad, because a new instruction must be placed in the right file.
