# AGENTS.md

<!--toc:start-->
- [AGENTS.md](#agentsmd)
  - [Writing conventions](#writing-conventions)
  - [Coding conventions](#coding-conventions)
<!--toc:end-->

The key words in this document are to be interpreted as described in
[BCP 14](https://www.rfc-editor.org/info/bcp14) (RFC 2119 and RFC 8174).

## Writing conventions

- Agent prompts and technical specifications SHOULD follow
  [BCP 14](https://www.rfc-editor.org/info/bcp14) (RFC 2119 and RFC 8174).
- Agent prompts SHOULD adhere to the
  [OpenAI Prompt Engineering Guide](https://developers.openai.com/api/docs/guides/prompt-engineering).
- For any style or documentation decision not enforced by automated tooling,
  text MUST adhere to the
  [Google Developer Documentation Style Guide](https://developers.google.com/style).

## Coding conventions

- Code MUST NOT introduce hacks, workarounds, or compatibility shims to bypass
  missing structure or architectural debt. Domain concepts MUST be modeled
  explicitly.
- For any style, convention, or architectural decision not strictly enforced by
  automated linters or formatters, code MUST adhere to the relevant
  [Google Style Guides](https://google.github.io/styleguide/).
- Source files MUST consolidate upstream reference comments (`# Reference: <URL>`)
  into a top header block.
- Reference URLs MUST use HTTPS and SHOULD NOT retain unnecessary fragment
  anchors.
