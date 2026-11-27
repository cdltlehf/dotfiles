---
status: accepted
date: 2026-11-27
---

# Branch with GitHub Flow

## Context and Problem Statement

ADR 0003 chose Git Flow so that `main` would hold the last release.
This repository has never tagged a release, and `main` stayed at 2026-10-07 while `develop` gained 261 commits.
Which branching model does this repository follow?

## Considered Options

* Keep [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
* [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow)

## Decision Outcome

Chosen option: "GitHub Flow," because the repository ships no releases, so `develop` only kept `main` stale.

* Work happens on `feature/*` branches from `main` and reaches `main` by merge.
* The `no-commit-to-branch` hook blocks direct commits to `main`.
* `.gitflow` shares the git-flow-next `github` preset, so `git flow feature start` and `finish` keep working.
* The templates keep Git Flow, as ADR 0003 decided for them.

### Consequences

* Good, because `main` is the current state.
* Bad, because `main` no longer marks a known-good state.

## More Information

This decision supersedes ADR 0003 for this repository.
Revisit it if the repository starts tagging releases, or if git-flow-next drops the `github` preset.
