# Deviate from the conventions where tools leave no choice

## Decision Outcome

This record states the reasons for the deviations, so that the configuration files hold no such comments.

* `scripts/setup` links shell startup files and agent instructions into `$HOME`, because the tools read only those fixed paths.
* Local overrides stay in `$HOME`, as [0004](0004-user-agnostic.md) states.
* Biome indents continuation lines by 2 spaces and cannot be configured to follow Google.
* `ruff.toml` ignores the rules that conflict with the Ruff formatter, with PEP 649, or with what Google allows.
* The SPDX line serves as the license boilerplate that Google requires.
* yamllint does not require `---` in single-document files.
* EditorConfig sets no line length for MADR, which writes one sentence per line.
