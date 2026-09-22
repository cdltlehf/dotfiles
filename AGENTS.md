# AGENTS.md

<!--toc:start-->

- [AGENTS.md](#agentsmd)
  - [Writing conventions](#writing-conventions)
  - [Coding conventions](#coding-conventions)
    - [General conventions](#general-conventions)
    - [Shell conventions](#shell-conventions)
      - [Shell environments and portability](#shell-environments-and-portability)
      - [Idempotency](#idempotency)
      - [Shell tools and style](#shell-tools-and-style)
    - [Makefile conventions](#makefile-conventions)
    - [Reference conventions](#reference-conventions)
    - [Testing and verification](#testing-and-verification)

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
- Documentation and comments MUST explain intent, edge cases, and design
  rationale ("why"), rather than restating code execution ("what").
- For any style or documentation decision not enforced by automated tooling,
  text MUST adhere to the
  [Google Developer Documentation Style Guide](https://developers.google.com/style).

## Coding conventions

### General conventions

- Code MUST prefer clear, descriptive naming over abbreviations.
- Code MUST NOT introduce hacks, workarounds, or compatibility shims to bypass
  missing structure or architectural debt. Domain concepts MUST be modeled
  explicitly.
- For any style, convention, or architectural decision not strictly enforced by
  automated linters or formatters, code MUST adhere to the relevant
  [Google Style Guide](https://google.github.io/styleguide/).

### Shell conventions

#### Shell environments and portability

- Shared shell startup files in `xdg-config-home/sh/` MUST remain strictly
  POSIX shell (`sh`) compliant and MUST NOT include Bashisms or Zshisms.
- Bash-specific configurations MUST reside in `xdg-config-home/bash/`.
- Zsh-specific configurations MUST reside in `xdg-config-home/zsh/`.
- Executable scripts in `bin/` MUST specify their target shell via a shebang
  (e.g., `#!/bin/sh` or `#!/bin/bash`) and adhere strictly to that dialect.

#### Idempotency

- Shell initialization files (e.g., `profile`, `shrc`, `bashrc`, `zshenv`,
  `zshrc`) MUST be idempotent.
- Repeated sourcing or execution of initialization files MUST NOT produce
  duplicate `$PATH` entries or accumulate unintended side effects.

#### Shell tools and style

- Shell scripts MUST pass `shellcheck` linting without errors.
- Shell scripts MUST be formatted by `shfmt`.
- Shell code SHOULD adhere to the
  [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html).

### Makefile conventions

- Target orchestration SHOULD be coordinated via GNU `make`.
- The root `Makefile` SHOULD delegate domain-specific targets to modular files
  in `makefiles/*.mk` via `-include makefiles/*.mk`.
- Targets SHOULD provide self-documenting help comments formatted as
  `## <Description>` following the Kubebuilder help pattern.
- Makefile recipes MUST remain concise and MUST NOT introduce multi-line
  script state machines directly inside recipes; complex procedures MUST be
  extracted into standalone scripts under `bin/` or `scripts/`.

### Reference conventions

- Documentation and upstream specifications MUST be cited using standard
  single-line reference comments (e.g., `# Reference: <URL>`).
- Reference comments MUST be consolidated into a header block at the top of
  the file.
- Reference URLs MUST use HTTPS where supported.
- Reference URLs SHOULD NOT retain unnecessary URL fragment anchors (`#...`),
  unless referencing a specific section in a multi-topic specification.

### Testing and verification

- All changes affecting shell initialization, path resolution, or tool
  compatibility MUST pass the BATS test suites executed via `make test`.
