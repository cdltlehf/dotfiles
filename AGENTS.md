# AGENTS.md

<!--toc:start-->
- [AGENTS.md](#agentsmd)
  - [Writing conventions](#writing-conventions)
  - [Coding conventions](#coding-conventions)
    - [General conventions](#general-conventions)
    - [Reference conventions](#reference-conventions)
<!--toc:end-->

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in BCP 14 (RFC 2119 and RFC 8174)
when, and only when, they appear in all capitals, as shown here.

## Writing conventions

- Agent prompts and technical specifications SHOULD follow BCP 14 (RFC 2119 and
  RFC 8174).
- When specifying requirements, text SHOULD prefer the canonical terms "MUST",
  "SHOULD", and "MAY" (and their negative forms) over their synonyms.
- Documentation and comments MUST explain "why", rather than "what".
- For any style or documentation decision not enforced by automated tooling,
  text MUST adhere to the
  [Google Developer Documentation Style Guide](https://developers.google.com/style).

## Coding conventions

### General conventions

- Code MUST NOT introduce hacks, workarounds, or compatibility shims to bypass
  missing structure or architectural debt. Domain concepts MUST be modeled
  explicitly.
- For any style, convention, or architectural decision not strictly enforced by
  automated linters or formatters, code MUST adhere to the relevant
  [Google Style Guides](https://google.github.io/styleguide/).

### Reference conventions

- Documentation and upstream specifications MUST be cited using standard
  single-line reference comments (e.g., `# Reference: <URL>`).
- Reference comments MUST be consolidated into a header block at the top of
  the file.
- Reference URLs MUST use HTTPS where supported.
- Reference URLs SHOULD NOT retain unnecessary URL fragment anchors (`#...`),
  unless referencing a specific section in a multi-topic specification.
