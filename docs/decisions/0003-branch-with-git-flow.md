# Branch with Git Flow

## Context and Problem Statement

This repository and the projects from its templates need one branching model.
The project conventions version releases with Semantic Versioning, and this repository already keeps `main` and `develop`.
Which branching model do they follow?

## Considered Options

* [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
* [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow)
* The [develop + master variation of OneFlow](https://www.endoflineblog.com/oneflow-a-git-branching-model-and-workflow), which keeps only `main` and `develop`

## Decision Outcome

Chosen option: "Git Flow", because:

* this repository already keeps `main` and `develop`;
* versioned releases with Semantic Versioning fit release branches and tags;
* `main` stays at the last release.

Work happens on `feature/*`, `release/*`, and `hotfix/*` branches, and reaches `main` and `develop` only by merges.
The `no-commit-to-branch` hook blocks direct commits to both, in this repository and in the templates.

### Consequences

* Good, because `main` always holds a released state.
* Bad, because every change needs a branch and a merge, which agents can handle but which adds steps.
