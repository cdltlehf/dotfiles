# AGENTS.md

The key words in this document are to be interpreted as described in [BCP
14](https://www.rfc-editor.org/info/bcp14) (RFC 2119 and RFC 8174).

A rule does not apply where its condition does not hold. The user MUST approve
deviations from a SHOULD, a SHOULD NOT, or a lint rule in committed work. Each
deviated rule MUST state its reason in a decision record or in a comment at the
deviation. One decision record MAY state the reasons for several deviations.

## Documentation conventions

*   Documentation decisions that no tool enforces SHOULD adhere to the [Google
    Developer Documentation Style Guide](https://developers.google.com/style).

## Coding conventions

*   Code SHOULD use the newest features available in the language version that
    the project declares, and MUST NOT use deprecated syntax. If the project
    declares no language version, agents SHOULD ask the user to declare one.
*   Coding decisions that no tool enforces SHOULD adhere to the relevant [Google
    Style Guides](https://google.github.io/styleguide/).
*   Makefiles:
    *   When a [GNU standard
        target](https://www.gnu.org/prep/standards/html_node/Standard-Targets.html)
        clearly matches a target's purpose, the target SHOULD use that name.
    *   A target MUST NOT use a GNU standard target name for another purpose.
    *   Makefiles SHOULD use the predefined variables of [GNU
        make](https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html).
    *   Makefiles SHOULD set `SHELL := /bin/bash` for recipe execution.
*   Shell scripts SHOULD target Bash, unless they may run where Bash is missing.
    Scripts targeting `/bin/sh` MUST adhere to the [POSIX Shell Command
    Language](https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html).
*   Web user interfaces:
    *   Accessible markup and dynamic states SHOULD adhere to [W3C
        WAI-ARIA](https://www.w3.org/TR/wai-aria/).
    *   Interfaces MUST conform to [W3C WCAG 2.2](https://www.w3.org/TR/WCAG22/)
        Level AA and SHOULD conform to Level AAA.
*   Version numbers and dependency constraints SHOULD adhere to [Semantic
    Versioning](https://semver.org/spec/v2.0.0.html).

## File conventions

*   Projects SHOULD place configuration, data, state, and cache files according
    to the [XDG Base Directory
    Specification](https://specifications.freedesktop.org/basedir-spec/latest/).

## Workflow

*   Newly created files SHOULD start from the templates in `XDG_TEMPLATES_DIR`
    ([xdg-user-dirs](https://gitlab.freedesktop.org/xdg/xdg-user-dirs)) when a
    matching template exists.
*   Branches SHOULD follow the project's branching model (such as [Git
    Flow](https://nvie.com/posts/a-successful-git-branching-model/) or [GitHub
    Flow](https://docs.github.com/en/get-started/using-github/github-flow)).
*   Commit messages SHOULD adhere to [Conventional
    Commits](https://www.conventionalcommits.org/en/v1.0.0/).
*   Projects MAY record architecturally significant decisions in
    `docs/decisions/` with [MADR](https://adr.github.io/madr/), keeping only the
    sections the decision needs.
