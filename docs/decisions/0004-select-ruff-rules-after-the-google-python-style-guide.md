---
status: accepted
date: 2026-10-20
---

# Select Ruff rules after the Google Python Style Guide

## Context and Problem Statement

The Python template enables every Ruff rule with `select = ["ALL"]`.
Some rules conflict with the Ruff formatter, with Python 3.14, or with the [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html).
Which rules does the template ignore, and why?

## Decision Outcome

The template ignores a rule only when one of the following reasons applies.
The rules were checked with Ruff 0.17.1.

| Reason | Ignored rules |
| -- | -- |
| The [Ruff formatter documentation](https://docs.astral.sh/ruff/formatter/#conflicting-lint-rules) lists them as conflicting with the formatter | `avoidable-escaped-quote`, `bad-quotes-docstring`, `bad-quotes-inline-string`, `bad-quotes-multiline-string`, `docstring-tab-indentation`, `indentation-with-invalid-multiple`, `indentation-with-invalid-multiple-comment`, `line-too-long`, `missing-trailing-comma`, `over-indented`, `prohibited-trailing-comma`, `tab-indentation`, `triple-single-quotes`, `unnecessary-escaped-quote` |
| Python 3.14 evaluates annotations lazily ([PEP 649](https://peps.python.org/pep-0649/)), and the template requires Python 3.14 | `future-required-type-annotation`, `future-rewritable-type-annotation`, `typing-only-first-party-import`, `typing-only-standard-library-import`, `typing-only-third-party-import` |
| They require `Returns:`, `Yields:`, or `Raises:` sections in one-line docstrings, which Google §3.8.3 allows when the name and signature are informative enough | `docstring-missing-exception`, `docstring-missing-returns`, `docstring-missing-yields` |
| Google uses `print` in its examples and does not forbid it | `print` |
| Google §3.12 allows `TODO` comments | `line-contains-todo` |
| Google §3.12 avoids TODOs that name an individual, and Ruff reports the old Google form `# TODO: crbug.com/192795 - …` as missing an author | `missing-todo-author` |
| Ruff reports the Google form `# TODO(crbug.com/192795): …` as missing a link, because it expects the link on the next line | `missing-todo-link` |
| Google raises exceptions with f-string messages in its examples, for example `raise ValueError(f'Min. port must be at least 1024, not {minimum}.')` | `f-string-in-exception`, `raw-string-in-exception`, `raise-vanilla-args` |

The template enables these rules, which were ignored before:

* `undocumented-*`, because Google §3.8.3 requires a docstring for the public API, and Ruff does not check names that start with `_`.
* `line-contains-fixme`, `line-contains-hack`, and `line-contains-xxx`, because Google defines only `TODO` comments.
* `missing-copyright-notice`, because Google §3.8.2 requires license boilerplate in every file.
  The template accepts a `# SPDX-License-Identifier: MIT` line as the notice, so that no year or author has to be filled in by custom template logic.
  This reads the SPDX identifier as the license boilerplate, which is an interpretation of Google §3.8.2.

The template drops `incorrect-blank-line-before-class` and `multi-line-summary-second-line` from the ignore list, because `convention = "google"` already disables them.

### Consequences

* Good, because every ignored rule has a reason that points to the formatter, the Python version, or the Google guide.
* Bad, because `line-contains-fixme` and `line-contains-xxx` report the same comments as `invalid-todo-tag`.

## More Information

Revisit `missing-todo-link` when Ruff accepts a link in the parentheses of a `TODO`.
Revisit the `docstring-missing-*` rules when Ruff skips one-line docstrings.
