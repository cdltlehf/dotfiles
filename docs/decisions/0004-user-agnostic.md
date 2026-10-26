# User-agnostic model and environment configuration

## Context and Problem Statement

The dotfiles repository is designed for any user to clone and run without modification.
It strictly excludes personal identity (such as emails, usernames, and private credentials).
Local AI models vary widely in quantization format, architecture, and user preference.
How do the local container stacks manage models and configuration without hardcoding a specific user's model choices or requiring personal configuration files?

## Decision Outcome

Chosen option: "Decouple model storage by OpenAI API endpoints and auto-activate services based on model presence", because it keeps the repository user-agnostic, privacy-first, and completely free of configuration files.

* Model directories under `~/.local/share/models/` follow the OpenAI API endpoint names (`responses`, `embeddings`, `audio`, `images`) instead of personal taxonomy or specific model architectures.
* All inference services (`llama-server`, `whisper-server`, `sd-server`) are treated as equal components and activate automatically through Makefile profile detection whenever model files exist in their respective directories (`responses`/`embeddings`, `audio`, `images`).
* Multi-model runtimes (`llama-server`) scan their endpoint directories automatically with `--models-dir`.
* Single-model runtimes (`whisper-server`, `sd-server`) receive the detected model filename directly, eliminating the need for `.env` or `example.env` configuration files entirely.
* Models can be downloaded into their respective XDG directories via `make models-download REPO=<repo>`.

### Consequences

* Good, because any user can clone and run the stack with zero configuration files.
* Good, because services automatically start when models are present and stay dormant when models are absent.
* Good, because no personal information, private model paths, or credentials leak into the repository.
* Bad, because automatic discovery in single-model directories selects the first model file when multiple files exist in `audio/` or `images/`.
