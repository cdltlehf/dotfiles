# Draw glyphs by terminal tier with Codicons

## Context and Problem Statement

The shell prompts, tmux, Vim, and `ls` draw status with glyphs.
Some terminals render Nerd Font icons, and others, such as a Linux console or a remote session, render only Unicode or ASCII.
How do these programs draw glyphs that every terminal can render?

## Decision Outcome

Chosen option: "Three glyph tiers, with Codicons in the Nerd Font tier", because the programs then never draw a glyph that the terminal cannot render.

* `LC_TERMINAL_GLYPHS` declares the tier of the terminal: `ascii`, `unicode`, or `nerdfont`.
  Programs fall back to `ascii` when it is unset.
  The name starts with `LC_`, because OpenSSH commonly forwards `LC_*` variables, so a remote session learns the tier of the local terminal.
* The terminal configurations of Ghostty, WezTerm, and Alacritty set `LC_TERMINAL_GLYPHS=nerdfont`.
* The `nerdfont` tier draws icons from [Codicons](https://github.com/microsoft/vscode-codicons), because the set covers many icons and keeps a minimal design.

### Consequences

* Good, because the same configuration works in every terminal.
* Bad, because each program that draws glyphs needs a branch for each tier.
