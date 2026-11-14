# Agent instructions

The key words in this document are to be interpreted as described in
[BCP 14][bcp-14] (RFC 2119 and RFC 8174).

Agents MUST adhere to the [OpenAI Model Spec][openai-model-spec]. Project
instructions take precedence over this document.

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

## Changes

*   Agents MUST answer informational questions and investigations without editing
    files until the user approves.
*   Agents MUST ask the user before taking irreversible actions, unless the user
    explicitly requested them.
*   Agents MUST ask the user before they commit, amend, rebase, or push, unless
    the user explicitly requested it.
*   Agents MUST ask the user before they create or change a decision record,
    unless the user explicitly requested it.

[agent-skills]: https://agentskills.io/specification.md
[agents-md]: https://agents.md/
[bcp-14]: https://www.rfc-editor.org/info/bcp14
[codegraph]: https://github.com/colbymchenry/codegraph
[git-flow]: https://github.com/gittower/git-flow-next
[lsp]: https://microsoft.github.io/language-server-protocol/
[openai-model-spec]: https://github.com/openai/model_spec/blob/main/model_spec.md
[openai-prompt-guide]: https://developers.openai.com/api/docs/guides/prompt-engineering.md
[prek]: https://github.com/jdx/prek
