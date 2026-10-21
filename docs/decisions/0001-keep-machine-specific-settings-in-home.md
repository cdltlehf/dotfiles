# Keep machine-specific settings in `*.local` files in `$HOME`

## Context and Problem Statement

The tracked shell, Git, and Vim configurations are shared by every machine.
Each machine still needs settings that are not shared, such as the Git user name and email.
The tracked configurations load these settings from an untracked file.
Where does that file live?

## Considered Options

* `*.local` files in `$HOME`
* `*.local` files beside the tracked sources in `XDG_CONFIG_HOME`

## Decision Outcome

Chosen option: "`*.local` files in `$HOME`", because the directories in `XDG_CONFIG_HOME` are symbolic links into this repository, so a file beside the tracked sources lives in the working tree.

The tracked configurations load these files last:

* `~/.profile.local`
* `~/.bashrc.local`
* `~/.zshrc.local`
* `~/.gitconfig.local`
* `~/.vimrc.local`

### Consequences

* Good, because machine-specific settings stay outside the working tree and cannot be committed by mistake.
* Good, because a fresh clone of this repository does not lose them.
* Bad, because these files deviate from the XDG Base Directory Specification.
