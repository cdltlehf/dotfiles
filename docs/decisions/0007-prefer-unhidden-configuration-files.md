---
status: accepted
date: 2026-11-05
---

# Prefer unhidden configuration files

## Context and Problem Statement

Project and tool configurations often reside at the root of a repository or template.
Different tools differ in their discovery rules: some tools only recognize hidden dotfiles, while others support unhidden filenames as well.
Which convention governs configuration file visibility when tools support both?

## Considered Options

* Use hidden dotfiles for all configuration files.
* Use unhidden filenames for all configuration files, passing explicit flags where needed.
* Prefer unhidden configuration files whenever supported, falling back to dotfiles only when required by tool discovery.

## Decision Outcome

Chosen option: "Prefer unhidden configuration files whenever supported, falling back to dotfiles only when required by tool discovery," because keeping configuration files visible improves discoverability while maintaining zero-flag tool execution.

* When a tool supports both unhidden and hidden configuration filenames natively (such as Vale with `vale.ini`), the repository and its templates use the unhidden name.
* When a tool strictly requires a dot-prefixed filename for default discovery (such as `markdownlint-cli2` with `.markdownlint.yaml`), the repository keeps the dotfile name to avoid requiring explicit path flags in CLI tools, pre-commit hooks, or language servers.

### Consequences

* Good, because configuration files remain visible in standard directory listings whenever tools permit it.
* Good, because tools that require dotfiles continue to function with zero configuration flags.
* Bad, because configuration visibility varies depending on each tool's discovery capabilities.

## More Information

Revisit dotfile exceptions when upstream tools (such as `markdownlint-cli2` or `yamllint`) introduce native discovery for unhidden configuration filenames (`markdownlint.yaml`).
