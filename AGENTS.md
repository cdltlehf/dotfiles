# AGENTS.md

<!--toc:start-->
- [AGENTS.md](#agentsmd)
  - [Writing conventions](#writing-conventions)
  - [Coding conventions](#coding-conventions)
<!--toc:end-->

The key words in this document are to be interpreted as described in
[BCP 14](https://www.rfc-editor.org/info/bcp14) (RFC 2119 and RFC 8174).

## Writing conventions

- Prompts and specifications SHOULD adhere to
  [BCP 14](https://www.rfc-editor.org/info/bcp14) (RFC 2119 and RFC 8174).
- Prompts SHOULD adhere to the
  [OpenAI Prompt Engineering Guide](https://developers.openai.com/api/docs/guides/prompt-engineering).
- Unenforced documentation decisions MUST adhere to the
  [Google Developer Documentation Style Guide](https://developers.google.com/style).

## Coding conventions

- Unenforced coding decisions MUST adhere to the relevant
  [Google Style Guides](https://google.github.io/styleguide/).
- Makefiles SHOULD adhere to conventional target names
  ([POSIX make](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html)
  and
  [GNU standard targets](https://www.gnu.org/prep/standards/html_node/Standard-Targets.html))
  and use standard predefined variables
  ([GNU make](https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html)).
- HTML documents MUST use semantic elements for their intended purpose
  according to the [WHATWG HTML Living Standard](https://html.spec.whatwg.org/).
- Source files MUST consolidate upstream reference comments (`# Reference: <URL>`)
  into a top header block.
- Reference URLs MUST use HTTPS and SHOULD NOT retain unnecessary fragment
  anchors.
