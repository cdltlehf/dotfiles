---
status: accepted
date: 2026-10-20
---

# Configure formatters and linters after the Google style guides

## Context and Problem Statement

The templates carry formatter and linter configurations for several languages.
Each configuration needs a style to follow, and choosing one style per language leaves every choice open to debate.
Which style do the configurations follow?

## Decision Outcome

Chosen option: "The [Google style guide](https://google.github.io/styleguide/) of the language, when one exists", because one source sets the default for every language, and a widely used, well-documented public guide makes each setting easy to justify.

| Language | Guide | Configuration |
| -- | -- | -- |
| Markdown | [Markdown style guide](https://google.github.io/styleguide/docguide/style.html) | `.markdownlint.yaml` |
| Shell | [Shell Style Guide](https://google.github.io/styleguide/shellguide.html) | `.editorconfig`, read by shfmt |
| Python | [Python Style Guide](https://google.github.io/styleguide/pyguide.html) | Ruff in `pyproject.toml.tmpl`, see ADR-0004 |
| C and C++ | [C++ Style Guide](https://google.github.io/styleguide/cppguide.html) | `c/.clang-format` with `BasedOnStyle: Google` |
| JavaScript and TypeScript | [JavaScript Style Guide](https://google.github.io/styleguide/jsguide.html) | Biome in `.biome.json` |
| JSON, YAML, TOML, and Lua | None | The tool defaults, except as noted below |

The configurations differ from the guides, or fill a gap where no guide exists, as follows:

* Markdown lists use one space after the marker when they are small, not nested, and single-line, which the Markdown guide allows.
* Biome indents continuation lines by 2 spaces, because it cannot follow the JavaScript guide's indent of at least 4 spaces.
* yamllint does not require the `---` document start marker, because a single-document file needs none.

### Consequences

* Good, because a setting that follows a guide needs no further reason.
* Bad, because the gaps above remain until the tools support the guides.

## More Information

Revisit the Biome continuation indent when Biome can set it.
