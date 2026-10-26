# Use Modus colors through the terminal palette

## Context and Problem Statement

The terminals, editors, and command-line tools each have their own color settings.
Which colors do they use, and where are the colors defined?

## Decision Outcome

Chosen option: "[Modus Themes](https://protesilaos.com/emacs/modus-themes), defined once in the terminal palette", because every color pair of Modus meets the WCAG AAA contrast ratio of 7:1, and a theme change then touches only the terminal configurations.

* Terminal emulators set the Modus Vivendi palette.
* Programs running inside the terminal use the 16 ANSI colors to inherit the palette.
* Graphical programs running outside the terminal set the Modus Vivendi theme directly.

### Consequences

* Good, because the colors meet the WCAG AAA contrast that the project conventions prefer.
* Good, because one palette keeps every program consistent.
* Bad, because the programs in the terminal are limited to 16 colors.
