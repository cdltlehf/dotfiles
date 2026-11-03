# Evaluate multiple terminal emulators concurrently

## Context and Problem Statement

Terminal emulators on macOS differ significantly in rendering performance, native window integration, Korean (CJK) IME composition stability, and configuration ergonomics.
Ghostty, WezTerm, Kitty, and iTerm2 each excel in different areas, but none yet provides a completely decisive advantage across all criteria without trade-offs.
(Alacritty was excluded from evaluation after Homebrew disabled its cask due to macOS Gatekeeper notarization issues.)
How should the dotfiles repository manage terminal emulator configurations while evaluating the best long-term option?

## Decision Outcome

Chosen option: "Maintain parallel, unified configurations for WezTerm, Ghostty, and Kitty, alongside iTerm2 as a baseline," because keeping equivalent configurations allows evaluating each emulator under identical typographic, visual, and dynamic color theme settings without committing prematurely to one tool.

* Each terminal emulator shares identical core parameters:
  * Primary font: JetBrains Mono at 13 pt with 1.2 cell height.
  * Italic style: Victor Mono (Medium Italic and Bold Italic).
  * Fallbacks: Symbols Nerd Font, Pretendard GOV, and JuliaMono for mathematical and technical glyphs.
  * Window styling: macOS native or blended titlebar decorations, background opacity of 0.9, and macOS background blur.
  * Standard padding: Default terminal margins without artificial offsets.
  * Theme integration: Dynamic Base16 palette through `flavours`, falling back to Modus Vivendi when unconfigured.
* The repository retains WezTerm, Ghostty, and Kitty configurations under `xdg-config-home/` and installs iTerm2 as a graphical baseline reference until one demonstrably satisfies all requirements, including CJK IME composition and native macOS integration.

### Consequences

* Good, because switching between terminal emulators preserves an identical visual and typographic workflow.
* Good, because new developments in CJK IME support or rendering performance can be evaluated immediately.
* Bad, because changing terminal-wide conventions requires updating multiple separate configuration files.
