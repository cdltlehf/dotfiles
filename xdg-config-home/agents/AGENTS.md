# Agent instructions

The key words in this document are to be interpreted as described in
[BCP 14][bcp-14] (RFC 2119 and RFC 8174).

Project instructions take precedence over this document.

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
    [Language Server Protocol][lsp] when a language server is configured.
*   Branch management SHOULD use [Git Flow][git-flow] when the repository is
    configured for Git Flow.
*   Pre-commit validation SHOULD use [prek][prek] when configured.

## Evaluation

*   Evaluations of changes, designs, or solutions SHOULD use a contextless
    subagent to ensure objective judgment.
*   Comparative evaluations, such as A/B testing, SHOULD invoke contextless
    subagents twice with alternating presentation order to eliminate position
    bias.

## Changes

* Agents SHOULD ask the user before they commit, amend, rebase, or push.
* Agents SHOULD ask the user before they create or change a decision record.

[agent-skills]: https://agentskills.io/specification.md
[agents-md]: https://agents.md/
[bcp-14]: https://www.rfc-editor.org/info/bcp14
[codegraph]: https://github.com/colbymchenry/codegraph
[git-flow]: https://github.com/gittower/git-flow-next
[lsp]: https://microsoft.github.io/language-server-protocol/
[openai-prompt-guide]: https://developers.openai.com/api/docs/guides/prompt-engineering.md
[prek]: https://github.com/jdx/prek
