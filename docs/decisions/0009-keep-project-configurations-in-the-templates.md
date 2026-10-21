---
status: accepted
date: 2026-10-21
---

# Keep project configurations in the templates

## Context and Problem Statement

This repository is itself a project, and its templates give new projects their configurations, such as `.editorconfig`, `.markdownlint.yaml`, and `AGENTS.md`.
Most of these configurations are the same for both, but some must differ, such as the hooks in `prek.toml` and the rules of this repository in `AGENTS.md`.
Where do the sources live, and how does the repository root get its configurations?

## Considered Options

* Track links in the root to the sources in `xdg-templates-dir/`
* Track copies in the root, and compare them with the sources in `xdg-templates-dir/`

## Decision Outcome

Chosen option: "Track copies in the root, and compare them with the sources", because one rule then covers the configurations that are the same and the ones that differ.

* `xdg-templates-dir/` holds the sources, so it shows what `~/Templates` contains, as `xdg-config-home/` shows what `XDG_CONFIG_HOME` contains.
* The root tracks a copy of each top-level file of `xdg-templates-dir/`, with a leading `.` in place of a `dot_` prefix.
* `make templates-diff`, which `make diff` runs, shows every difference between a copy and its source.

### Consequences

* Good, because this repository can have rules of its own.
* Good, because a fresh clone has its configurations, and the repository tracks no symbolic links.
* Good, because an empty `make templates-diff` output for a file proves that the template suffices for this project.
* Bad, because a change to a template must be copied to the root by hand.

## More Information

`~/Templates/biome.json` is the only entry of `~/Templates` that `xdg-templates-dir/` does not show.
`scripts/setup` creates it separately, because a `biome.json` in `xdg-templates-dir/` would make Biome find a nested root configuration beside the root `.biome.json`.
Revisit it when Biome can skip a nested configuration without a change to the template configuration.
