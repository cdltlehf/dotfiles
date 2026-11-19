---
status: accepted
date: 2026-11-20
---

# Defer rerank, video, and realtime endpoints

## Context and Problem Statement

The homelab inference containers already include binaries that support additional capabilities beyond chat, embeddings, speech synthesis, transcription, and image generation:

* `llama-server` supports cross-encoder reranking (`/v1/rerank`) and realtime WebSocket audio (`/v1/realtime`).
* `sd-server` supports video generation architectures such as Wan2.2 and LTX2.

Other modalities, such as music composition and interactive world models, lack a common OpenAI-compatible API standard or practical GGUF runtimes for a 14.9 GiB container VM.
Should the homelab expose `rerank`, `video`, and `realtime` routes and Compose profiles now, or defer them until a concrete workload requires them?

## Decision Drivers

* Keep container count, memory pressure, and gateway routing proportional to active workloads.
* Avoid shipping unverified Compose profiles and routes without locally tested models.
* Preserve the model-directory profile-detection pattern in `homelab/Makefile` so future additions stay additive.

## Considered Options

* Pre-wire `rerank`, `video`, and `realtime` profiles and routes in `homelab/` without downloading models.
* Defer these endpoints and add each one only when a concrete workload and tested model exist.

## Decision Outcome

Chosen option: "Defer these endpoints and add each one only when a concrete workload and tested model exist," because unexercised routes and flags add configuration surface without current value, while the existing profile-detection mechanism makes adding them later straightforward.

### Consequences

* Good, because `homelab` tracks only verified, actively used model endpoints.
* Good, because the 14.9 GiB VM avoids additional large model weights and experimental latency issues.
* Bad, because enabling one of these capabilities later requires adding its Compose profile, gateway route, and `homelab/Makefile` directory check.

## More Information

Revisit this decision per capability when its trigger condition holds:

* **Rerank (`/v1/rerank`)**: Revisit when a retrieval-augmented generation (RAG) workflow requires cross-encoder document scoring.
* **Video generation**: Revisit when hardware headroom and generation speed make multi-frame video practical alongside existing models.
* **Realtime audio (`/v1/realtime`)**: Revisit when interactive low-latency voice conversation justifies WebSocket routing and a faster model/runtime budget.
* **Music composition and world models**: Revisit if open-weights local runtimes and a stable API or MCP contract emerge.
