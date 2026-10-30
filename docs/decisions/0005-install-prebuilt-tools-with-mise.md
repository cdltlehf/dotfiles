---
status: proposed
date: 2026-10-30
---

# Install prebuilt tools with mise

## Context and Problem Statement

This repository installs tools on macOS and on Linux, and Linux machines often give no root access.
Homebrew installs prebuilt packages on Linux only under `/home/linuxbrew/.linuxbrew`, which needs root, and builds from source elsewhere.
Some mise backends build from source or download from anaconda.org, and these installs fail on machines without a compiler or with missing libraries.
Which tool installs each package?

## Decision Drivers

* The repository assumes as few tools as it can: `sh`, `curl` or `wget`, `git`, and `make`.
* Linux machines are used often and without root.
* An install fails fast instead of building from source.

## Considered Options

* mise for prebuilt tools that both platforms use, Homebrew for the rest on macOS
* Homebrew for all tools on macOS, mise only for runtimes
* mise with a build tier for machines that have a compiler

## Decision Outcome

Chosen option: "mise for prebuilt tools that both platforms use, Homebrew for the rest on macOS," because it is the only option that installs the same tools on a Linux machine without root or a compiler.

* mise installs a tool that both platforms use when a mise backend downloads it prebuilt.
* mise does not use the `asdf` and `conda` backends: `disable_backends = ["asdf", "conda"]`.
* Homebrew installs the other tools on macOS, such as apps, macOS-only tools, and tools without a prebuilt mise backend.
* On Linux, the repository does not install the other tools. It links their configuration, which applies when the system provides them, such as Vim and Zsh.

### Consequences

* Good, because a Linux machine without root gets the same command-line tools as macOS.
* Good, because no install builds from source or depends on the Anaconda terms of service.
* Neutral, because most tools download from GitHub, and unauthenticated API limits can slow the first install until `gh auth login`.
* Bad, because Linux has no Vim or Zsh unless the system provides them.
* Bad, because tools that Homebrew installs exist only on macOS.

### Confirmation

No tool appears in both `platforms/darwin/Brewfile` and `xdg-config-home/mise/config.toml`.
`mise tool <name>` shows no `asdf` or `conda` backend.

## Pros and Cons of the Options

### Homebrew for all tools on macOS, mise only for runtimes

* Good, because Homebrew handles libraries, services, and apps on macOS with one tool.
* Bad, because Linux machines without root get none of the tools.

### mise with a build tier for machines that have a compiler

A `config.build.toml` enables the `asdf` backend and adds Vim, and `MISE_ENV=build` in `~/.profile.local` turns it on.

* Good, because a Linux machine with a compiler gets Vim.
* Bad, because it adds a configuration file and a variable for one tool.
* Bad, because a machine that has a compiler usually has a package manager that installs Vim.

## More Information

Revisit the build tier when several tools need a build.
The `conda` backend installed Vim without `libsodium` on macOS, as [jdx/mise#8336](https://github.com/jdx/mise/discussions/8336) reports.
