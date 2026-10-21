# Split package manifests by platform

## Context and Problem Statement

This repository installs tools on macOS and Linux.
Each platform has its own package managers, and some tools need the same version everywhere.
Which manifest declares each tool?

## Decision Outcome

Chosen option: "One manifest per platform, and one shared mise configuration for pinned versions":

| Manifest | Platform | Contents |
| -- | -- | -- |
| `platforms/darwin/Brewfile` | macOS | Command-line tools, applications, and fonts |
| `platforms/linux/mise.toml` | Linux | The command-line tools of the Brewfile, as far as mise provides them |
| `xdg-config-home/mise/config.toml` | All | Tools that need the same version on every platform, such as language runtimes and the tools that projects and hooks depend on |

The reasons are:

* Homebrew is the de facto package manager of macOS, and one Brewfile also covers applications and fonts, which mise cannot install.
* mise on Linux keeps one manifest for every distribution, and it installs into the user directory without root.
* The shared mise configuration pins the versions that must not differ between platforms.

### Consequences

* Good, because each platform uses the package manager that suits it.
* Bad, because a command-line tool added to the Brewfile must also be added to `platforms/linux/mise.toml`.
