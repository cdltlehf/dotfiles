# User-agnostic model and environment configuration

## Context and Problem Statement

The dotfiles repository is designed for any user to clone and run without modification.
It strictly excludes personal identity (such as emails, usernames, and private credentials).
Local AI models vary widely in quantization format, architecture, and user preference.
How do the local container stacks manage models and configuration without hardcoding a specific user's model choices or personal defaults?

## Decision Outcome

Chosen option: "Decouple model storage by OpenAI API endpoints and inject model selection via environment variables", because it keeps the repository user-agnostic and privacy-first while providing a standardized interface.

* Model directories under `~/.local/share/models/` follow the OpenAI API endpoint names (`responses`, `embeddings`, `audio`, `images`) instead of personal taxonomy or specific model architectures.
* Multi-model runtimes (`llama-server`) run as the default service and scan endpoint directories automatically with `--models-dir`, requiring zero configuration for basic text and embedding inference.
* Optional single-model add-ons (`whisper-server`, `sd-server`) activate via profiles (`COMPOSE_PROFILES=whisper,sd`) and accept environment variables (`AUDIO_MODEL`, `IMAGE_MODEL`) in `.env` to override default filenames without renaming files.
* `.env` is optional and ignored by Git, while `example.env` documents supported variables using common public base models (`ggml-base.bin`, `v1-5-pruned-emaonly.safetensors`).

### Consequences

* Good, because any user can clone and run the stack with their own models without modifying tracked files.
* Good, because no personal information, private model paths, or credentials leak into the repository.
* Bad, because single-model containers require users to either set an environment variable or rename their files to the fallback name.
