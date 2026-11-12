# Agent instructions

The key words in this document are to be interpreted as described in [BCP
14][bcp-14] (RFC 2119 and RFC 8174).

A rule does not apply where its condition does not hold. The user MUST approve
deviations from a SHOULD, a SHOULD NOT, or a lint rule in committed work. Each
deviated rule MUST state its reason in a decision record or in a comment at the
deviation. One decision record MAY state the reasons for several deviations.

## Documentation conventions

*   Documentation decisions that no tool enforces SHOULD adhere to the [Google
    Developer Documentation Style Guide][google-doc-style].

## Coding conventions

*   Code SHOULD use the newest features available in the language version that
    the project declares, and MUST use current, supported syntax. If the project
    declares no language version, agents SHOULD ask the user to declare one.
*   Coding decisions that no tool enforces SHOULD adhere to the relevant [Google
    Style Guides][google-style-guides].
*   Engineering decisions that no tool enforces SHOULD adhere to the [Google
    Engineering Practices Documentation][google-eng-practices].
*   Code and configurations SHOULD maintain vendor neutrality and avoid
    coupling to specific implementations.
*   Services SHOULD adhere to [The Twelve-Factor App][twelve-factor].
*   Makefiles:
    *   When a [GNU standard target][gnu-targets] clearly matches a target's
        purpose, the target SHOULD use that name.
    *   A target that uses a GNU standard target name MUST serve that standard
        purpose.
    *   Makefiles SHOULD use the predefined variables of [GNU make][gnu-make].
    *   Makefiles SHOULD set `SHELL := /bin/bash` for recipe execution.
*   Shell scripts SHOULD target Bash, unless they may run where Bash is missing.
    Scripts targeting `/bin/sh` MUST adhere to the [Portable Operating System
    Interface (POSIX) Shell Command Language][posix-shell].
*   Web user interfaces:
    *   Accessible markup and dynamic states SHOULD adhere to [W3C Web
        Accessibility Initiative Accessible Rich Internet Applications
        (WAI-ARIA)][wai-aria].
    *   Interfaces MUST conform to [W3C Web Content Accessibility Guidelines
        (WCAG) 2.2][wcag-2.2] Level AA and SHOULD conform to Level AAA.
*   Version numbers and dependency constraints SHOULD adhere to [Semantic
    Versioning][semver].

## File conventions

*   Projects SHOULD place configuration, data, state, and cache files according
    to the [X Desktop Group (XDG) Base Directory Specification][xdg-basedir].

## Workflow

*   Newly created files SHOULD start from the templates in `XDG_TEMPLATES_DIR`
    ([xdg-user-dirs][xdg-user-dirs]) when a matching template exists.
*   Branches SHOULD follow a branching model such as [Git Flow][git-flow] or
    [GitHub Flow][github-flow].
*   Commit messages SHOULD adhere to [Conventional
    Commits][conventional-commits].
*   Projects MAY record architecturally significant decisions in
    `docs/decisions/` with [Markdown Architectural Decision Records
    (MADR)][madr], keeping only the sections the decision needs.
*   Decision records depending on external tools SHOULD specify revisit
    criteria.

[bcp-14]: https://www.rfc-editor.org/info/bcp14
[conventional-commits]: https://www.conventionalcommits.org/en/v1.0.0/
[git-flow]: https://nvie.com/posts/a-successful-git-branching-model/
[github-flow]: https://docs.github.com/en/get-started/using-github/github-flow.md
[gnu-make]: https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html
[gnu-targets]: https://www.gnu.org/prep/standards/html_node/Standard-Targets.html
[google-doc-style]: https://developers.google.com/style
[google-eng-practices]: https://google.github.io/eng-practices/README.md
[google-style-guides]: https://google.github.io/styleguide/README.md
[madr]: https://adr.github.io/madr/
[posix-shell]: https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html
[semver]: https://semver.org/spec/v2.0.0.md
[twelve-factor]: https://12factor.net/
[wai-aria]: https://www.w3.org/TR/wai-aria/
[wcag-2.2]: https://www.w3.org/TR/WCAG22/
[xdg-basedir]: https://specifications.freedesktop.org/basedir-spec/latest/
[xdg-user-dirs]: https://gitlab.freedesktop.org/xdg/xdg-user-dirs
