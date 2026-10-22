# AGENTS.md

The key words in this document are to be interpreted as described in
[BCP 14](https://www.rfc-editor.org/info/bcp14) (RFC 2119 and RFC 8174).

Project instructions take precedence over this document.

## Writing conventions

*   Prompts and specifications SHOULD adhere to
    [BCP 14](https://www.rfc-editor.org/info/bcp14).
*   Prompts SHOULD adhere to the
    [OpenAI Prompt Engineering Guide](https://developers.openai.com/api/docs/guides/prompt-engineering).
*   Agent instructions SHOULD adhere to [AGENTS.md](https://agents.md/).
*   Agent skills SHOULD adhere to the
    [Agent Skills specification](https://agentskills.io/specification).

## Tools

*   Code exploration and impact analysis SHOULD use
    [CodeGraph](https://github.com/colbymchenry/codegraph)
    when the repository has a `.codegraph/` index.
*   Code refactoring and diagnostics SHOULD use the
    [Language Server Protocol](https://microsoft.github.io/language-server-protocol/)
    when a language server is configured.

## Changes

* Agents SHOULD ask the user before they commit, amend, rebase, or push.
* Agents SHOULD ask the user before they create or change a decision record.
