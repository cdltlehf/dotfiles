---
status: proposed
date: 2026-10-20
---

# Record file references and licensing

## Context and Problem Statement

Most files name their sources in `# Reference:` header comments.
Files that cannot carry comments, such as JSON files and templates, are listed in `REFERENCES` instead.
`REFERENCES` borrows the paragraph syntax of the [Machine-readable Debian copyright file format](https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/) (DEP-5) and adds a `Reference` field.

The project conventions say that file references and copyright metadata SHOULD adhere to DEP-5.
This ties two concerns to one format:

* `REFERENCES` was made to record references, but DEP-5 is a copyright format, and its `Files` paragraphs require the `Copyright` and `License` fields, which `REFERENCES` lacks.
* The license of this repository, the Beer-Ware License, is stated only in `LICENSE`, not in a machine-readable form.

How are file references and licensing recorded?

## Considered Options

* Narrow the convention to the DEP-5 paragraph syntax for references, and leave licensing as it is
* Record licensing separately, for example with [SPDX](https://spdx.dev/) identifiers or [REUSE](https://reuse.software/), and keep `REFERENCES` for references only
* Add a `Files: *` paragraph with `Copyright` and `License: Beerware` to `REFERENCES`

## More Information

This decision is open.
Until it is made, `REFERENCES` deviates from DEP-5 for the reasons above.
