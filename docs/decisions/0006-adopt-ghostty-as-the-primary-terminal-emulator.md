# Adopt Ghostty as the primary terminal emulator

## Context and Problem Statement

Terminal emulators on macOS differ in rendering performance, native window integration, Korean (CJK) IME composition stability, and configuration ergonomics.
After evaluating Ghostty, WezTerm, Kitty, Alacritty, and iTerm2, which terminal emulator should serve as the primary standard for macOS?

## Decision Outcome

Chosen option: "Ghostty," because its native Swift/AppKit user interface provides full macOS integration, resolves previous Korean (CJK) IME composition issues with `NSTextInputClient`, delivers GPU-accelerated Metal performance, and maintains an explicit, declarative configuration.

* The repository standardizes on Ghostty:
  * Primary font: JetBrains Mono at 13 pt with 1.2 cell height.
  * Italic style: Victor Mono (Medium Italic and Bold Italic).
  * Fallbacks: Pretendard GOV for Korean, Symbols Nerd Font for icons, and JuliaMono for mathematical and technical Unicode blocks.
  * Window appearance: native tabs, background opacity of 0.9, and macOS regular glass blur.
  * Palette: Modus Vivendi, with dynamic Base16 integration through `flavours`.
* Other terminal emulators (WezTerm, Kitty, Alacritty, and iTerm2) are uninstalled and their configurations removed to keep the dotfiles minimal and maintainable.

### Consequences

* Good, because Ghostty provides native macOS windowing, tabs, and blur with zero custom Lua boilerplate.
* Good, because Korean IME input operates reliably through macOS text input services without decomposed jamo issues.
* Good, because maintaining a single terminal configuration simplifies dotfiles maintenance.
