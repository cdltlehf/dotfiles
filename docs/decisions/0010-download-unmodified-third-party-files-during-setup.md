---
status: accepted
date: 2026-11-17
---

# Download unmodified third-party files during setup

## Context and Problem Statement

Setup installs files that other projects publish, such as the MADR templates, the terminal diagnostics scripts, and `git-prompt.sh`.
The repository uses these files as published and never edits them.
A copy committed to the repository falls behind its upstream and adds history that the repository does not own.
How does the repository obtain files that it uses unmodified?

## Decision Drivers

* The repository tracks only what it owns.
* A machine gets upstream fixes without a commit to this repository.
* A failed download leaves a working machine.

## Considered Options

* Commit a copy of each file.
* Download each file during setup.

## Decision Outcome

Chosen option: "Download each file during setup," because the repository then holds only its own work, and upgrade can refresh every file.

* `download` in `scripts/lib.sh` fetches each file with `curl` or `wget`.
* Setup records each downloaded file in `${XDG_STATE_HOME}/dotfiles/downloads`, and upgrade downloads the recorded files again.
* A download writes to a temporary file first, so a failed download keeps the previous file.
* Installers that setup runs once stream into a shell and stay unrecorded.
* A download that lands inside the repository, such as `xdg-templates-dir/madr`, is listed in `.gitignore`.
* A file adapted from an upstream is committed, and names its source in a `Reference:` comment or in `REFERENCES`.

### Consequences

* Good, because the history holds only the repository's own changes.
* Good, because upgrade brings every downloaded file up to date.
* Bad, because setup needs network access and fails if an upstream removes a file.
* Bad, because a URL that follows a branch, such as `master`, can change a file without notice; a URL pins a tag only where the format matters, such as MADR `4.0.0`.

### Confirmation

Every `download` call in `scripts/` and `platforms/` writes outside the repository or to a path that `.gitignore` lists.

## More Information

Revisit a file when a package manager that setup already uses, such as mise or Homebrew, can install it.
