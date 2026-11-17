# Agent instructions

The key words in this document are to be interpreted as described in
[BCP 14][bcp-14] (RFC 2119 and RFC 8174).

Agents MUST adhere to the [OpenAI Model Spec][openai-model-spec]. Project
instructions take precedence over this document. A rule does not apply where its
condition does not hold.

## Writing conventions

*   Prompts and specifications SHOULD adhere to [BCP 14][bcp-14].
*   Prompts SHOULD adhere to the
    [OpenAI Prompt Engineering Guide][openai-prompt-guide].
*   Agent instructions SHOULD adhere to [AGENTS.md][agents-md].
*   Agent skills SHOULD adhere to the
    [Agent Skills specification][agent-skills].

## Tools

*   Code exploration and impact analysis SHOULD use [CodeGraph][codegraph]
    when the repository has a `.codegraph/` index.
*   Code refactoring and diagnostics SHOULD use the
    [Language Server Protocol][lsp] when the repository configures a language
    server.
*   Branch management SHOULD use [Git Flow][git-flow] when the repository uses
    Git Flow.
*   Pre-commit validation SHOULD use [prek][prek] when the repository
    configures prek.

## Evaluation

*   Evaluations of changes, designs, or solutions SHOULD use a contextless
    subagent to ensure objective judgment.
*   Comparative evaluations, such as A/B testing, SHOULD invoke contextless
    subagents twice with alternating presentation order to eliminate position
    bias.

## Engineering

*   Engineering decisions that no tool enforces SHOULD adhere to the [Google
    Engineering Practices Documentation][google-eng-practices].
*   Before committing, agents SHOULD check changed code for [code
    smells][code-smells].
*   Code smells that agents find SHOULD be removed with refactorings from
    the [Refactoring catalog][refactoring-catalog].
*   Code and configurations SHOULD maintain vendor neutrality and avoid
    coupling to specific implementations.
*   Scripts targeting `/bin/sh` MUST adhere to the [Portable Operating System
    Interface (POSIX) Shell Command Language][posix-shell].
*   Tests SHOULD adhere to [Software Engineering at Google: Testing
    Overview][swe-book-testing] and [Unit Testing][swe-book-unit-testing],
    testing behaviors through public APIs rather than implementation details.
*   Defect fixes SHOULD address the root cause rather than symptoms or
    workarounds, and strengthen existing tests or checks rather than adding
    redundant ones.

## Guardrails

*   Agents MUST answer questions and investigations without editing files.
*   Unless explicitly requested, agents MUST ask before irreversible actions,
    external side effects, VCS-history changes, or decision-record changes.
*   After three failed attempts or recurring errors, agents SHOULD stop and
    consult the user or a contextless subagent.
*   Agents SHOULD verify user premises against observed evidence and raise
    technical objections rather than agreeing uncritically.

[agent-skills]: https://agentskills.io/specification.md
[agents-md]: https://agents.md/
[bcp-14]: https://www.rfc-editor.org/info/bcp14
[code-smells]: https://refactoring.guru/refactoring/smells
[codegraph]: https://github.com/colbymchenry/codegraph
[git-flow]: https://github.com/gittower/git-flow-next
[google-eng-practices]: https://google.github.io/eng-practices/README.md
[lsp]: https://microsoft.github.io/language-server-protocol/
[openai-model-spec]: https://github.com/openai/model_spec/blob/main/model_spec.md
[openai-prompt-guide]: https://developers.openai.com/api/docs/guides/prompt-engineering.md
[posix-shell]: https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html
[prek]: https://github.com/jdx/prek
[refactoring-catalog]: https://refactoring.com/catalog/
[swe-book-testing]: https://abseil.io/resources/swe-book/html/ch11.html
[swe-book-unit-testing]: https://abseil.io/resources/swe-book/html/ch12.html
