# AGENTS.md

The key words in this document are to be interpreted as described in
[BCP 14](https://www.rfc-editor.org/info/bcp14) (RFC 2119 and RFC 8174).

A rule does not apply where its condition does not hold.
Deviations from a SHOULD, a SHOULD NOT, or a lint rule in committed work
MUST be approved by the user.
Each deviated rule MUST have its reason stated
in a decision record or in a comment at the deviation.
One decision record MAY state the reasons for several deviations.

## Documentation conventions

*   Documentation decisions that no tool enforces SHOULD adhere to the
    [Google Developer Documentation Style Guide](https://developers.google.com/style).
*   File references and copyright metadata SHOULD adhere to the
    [Machine-readable Debian copyright file format](https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/)
    (DEP-5).

## Coding conventions

*   Code SHOULD use the newest features available in the language version
    that the project declares, and MUST NOT use deprecated syntax.
    If the project declares no language version,
    agents SHOULD ask the user to declare one.
*   Coding decisions that no tool enforces SHOULD adhere to the relevant
    [Google Style Guides](https://google.github.io/styleguide/).
*   Makefiles:
    *   When a
        [GNU standard target](https://www.gnu.org/prep/standards/html_node/Standard-Targets.html)
        clearly matches a target's purpose, the target SHOULD use that name.
    *   A target MUST NOT use a GNU standard target name for another purpose.
    *   Makefiles SHOULD use the predefined variables of
        [GNU make](https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html).
    *   Makefiles SHOULD set `SHELL := /bin/bash` for recipe execution.
*   Shell scripts SHOULD target Bash, unless they may run where Bash is missing.
    Scripts targeting `/bin/sh` MUST adhere to the
    [POSIX Shell Command Language](https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html).
*   Web user interfaces:
    *   HTML documents MUST use elements for their intended purpose
        according to the
        [WHATWG HTML Living Standard](https://html.spec.whatwg.org/).
    *   Accessible markup and dynamic states SHOULD adhere to
        [W3C WAI-ARIA](https://www.w3.org/TR/wai-aria/).
    *   Styling SHOULD separate structure from presentation according to
        [WHATWG HTML § Presentational markup](https://html.spec.whatwg.org/multipage/introduction.html#presentational-markup).
    *   Interfaces MUST conform to
        [W3C WCAG 2.2](https://www.w3.org/TR/WCAG22/)
        Level AA and SHOULD conform to Level AAA.
    *   Dynamic interactions SHOULD adhere to
        [htmx](https://htmx.org/)
        when the project uses it.
*   Version numbers and dependency constraints SHOULD adhere to
    [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## File conventions

*   Configuration, data, state, and cache files SHOULD be placed according to
    the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/).

## Workflow

*   Newly created files SHOULD start from the templates in
    `XDG_TEMPLATES_DIR`
    ([xdg-user-dirs](https://gitlab.freedesktop.org/xdg/xdg-user-dirs))
    when a matching template exists.
*   Branches SHOULD follow
    [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/).
*   Architecturally significant decisions MAY be recorded in
    `docs/decisions/` with [MADR](https://adr.github.io/madr/),
    keeping only the sections the decision needs.
