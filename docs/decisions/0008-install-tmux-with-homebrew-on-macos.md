---
status: accepted
date: 2026-11-12
---

# Install tmux with Homebrew on macOS

## Context and Problem Statement

When mise starts tmux inside Ghostty, macOS assigns Ghostty as the responsibility process for the child process tree.
Even when the tmux server detaches, closing Ghostty stops the tmux server too.
Homebrew installs standalone tools on macOS and separates them from the terminal emulator process tree.
Which package manager installs tmux on macOS?

## Decision Drivers

* Multiplexer sessions must survive terminal emulator exits and window closures.
* macOS process responsibility must not tie the tmux server lifecycle to a GUI app.
* Homebrew installs macOS-specific tools, as decision record 0005 establishes.

## Considered Options

* Install tmux with Homebrew on macOS and remove it from mise
* Keep tmux in mise and require manual background daemon startup
* Retain tmux in mise without changes

## Decision Outcome

Chosen option: "Install tmux with Homebrew on macOS and remove it from mise," because Homebrew installs tmux independently from terminal emulator sessions and avoids GUI app responsibility coupling on macOS.

* `platforms/darwin/Brewfile` adds `brew "tmux"`.
* `xdg-config-home/mise/config.toml` removes `"aqua:tmux/tmux-builds"`.
* Linux continues to rely on system-provided or container-managed tmux installations.

### Consequences

* Good, because quitting Ghostty doesn't stop the tmux server.
* Good, because Homebrew handles native terminal capabilities and library dependencies on macOS.
* Neutral, because macOS requires Homebrew bundle installation.

### Confirmation

* `platforms/darwin/Brewfile` contains `brew "tmux"`.
* `xdg-config-home/mise/config.toml` contains no `tmux` entry.
* `which tmux` resolves to `/opt/homebrew/bin/tmux`.

## More Information

Revisit this decision when mise introduces an isolated daemon runner on macOS that detaches process responsibility from GUI terminal emulators.
