# Keep configurations and services user-agnostic

## Context and Problem Statement

Dotfiles repositories often mix shared configurations with personal identity, hardcoded filesystem paths, private credentials, and machine-specific states.
When configurations hardcode personal paths or identity, other users cannot clone and run the repository without manual modifications, and personal secrets risk leaking into version control.
How does this repository provide a consistent environment across different users and machines while remaining strictly user-agnostic?

## Decision Outcome

Chosen option: "Isolate personal identity and local overrides outside the repository, follow standard directory specifications, and discover local resources dynamically," because any user can clone and run the repository without modification, and no private data leaks into revision control.

* All paths adhere to the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/) and standard POSIX environment variables, avoiding hardcoded user names, user identifiers, or absolute home directory paths.
* Tracked configurations link into `XDG_CONFIG_HOME`, while personal identities, credentials, and machine-local overrides reside outside the repository in `$HOME/.<tool>.local` (such as `~/.gitconfig.local` and `~/.profile.local`) so that local changes cannot be committed by mistake.
* Identity-bearing tools require explicit local configuration, such as setting Git's `user.useConfigOnly = true` to prevent automatic fallback to guessed usernames or email addresses.
* Services and container stacks avoid hardcoded environment files and fixed user-specific taxonomies, relying instead on dynamic capability discovery from standard XDG data directories to activate profiles only when relevant resources are present.

### Consequences

* Good, because any user can clone and initialize the repository without modifying tracked files.
* Good, because personal identity, private keys, and machine-specific credentials never leak into git.
* Good, because standard directory structures provide consistent behavior across different POSIX-compliant operating systems.
* Bad, because users must explicitly declare personal identity and credentials in external local files on new systems.
* Bad, because services requiring local data remain dormant until resources are placed in their respective standard directories.
