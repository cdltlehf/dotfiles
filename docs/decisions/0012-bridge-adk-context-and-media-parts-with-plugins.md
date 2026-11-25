---
status: accepted
date: 2026-11-25
---

# Bridge ADK context trimming and A2A media parts with plugins

## Context and Problem Statement

The `a2a` container runs Google Agent Development Kit (ADK) with `McpToolset` connected to `mcp-server`. Two gaps in the current ADK/MCP/A2A ecosystem require custom runtime glue:

* ADK's built-in `ContextFilterPlugin` only limits history by invocation count, not estimated tokens, risking `llama-server` context overflows on long sessions.
* `mcp-server` returns URL references (`audio_url`, `image_url`) instead of inline binary payloads to avoid 1 MiB MCP payload limits and context bloat. ADK forwards these tool results as `Part(text=...)`, so downstream A2A clients such as Chatroom do not receive A2A `FilePart` (`Part(url=..., media_type=...)`) entries.
* ADK's CLI (`adk web`) executes as a console script without adding `/app` to `sys.path`, so mounted plugin files require either `PYTHONPATH` or installation into `site-packages`.

Should we maintain these workarounds as a small `plugins.py` module installed in the `a2a` image, or wait for upstream ADK/MCP/A2A support?

## Decision Drivers

* Keep `mcp-server` URL-based for generated audio and full-resolution images to avoid 1 MiB payload limits and LLM context bloat.
* Emit standard A2A `Part(url=..., media_type=...)` entries from `a2a` without requiring client-side URL scraping.
* Avoid `PYTHONPATH` hacks in `compose.yaml` by installing `plugins.py` into `site-packages` in `a2a/Containerfile`.
* Keep the custom surface minimal until upstream ecosystems mature.

## Considered Options

* Drop custom plugins and wait for native ADK token-budget context filtering and MCP-URL-to-A2A `FilePart` promotion.
* Install a minimal `plugins.py` module in `a2a/Containerfile` containing `context_filter` and `media_parts`, and revisit when upstream catches up.

## Decision Outcome

Chosen option: "Install a minimal `plugins.py` module in `a2a/Containerfile` containing `context_filter` and `media_parts`," because neither capability exists out of the box in ADK or a standard plugin ecosystem, and keeping both in one small installed module avoids `PYTHONPATH` workarounds while unblocking A2A media clients.

### Consequences

* Good, because `a2a` stays protected against token-limit overflows and emits standard A2A `FilePart` URIs for generated audio and images.
* Good, because `mcp-server` remains free of inline audio payloads and keeps `get_image_result` compressed under 1 MiB.
* Bad, because `homelab/containers/a2a/plugins.py` remains a custom maintenance surface tied to ADK's `BasePlugin` callbacks.

### Revisit Criteria

Revisit and remove or extract `plugins.py` when any of the following hold:

* Google ADK natively supports token-budget history trimming in `ContextFilterPlugin`.
* ADK or MCP standardizes external media URL references so `McpToolset` tool results automatically map to A2A `FilePart` URIs.
* `plugins.py` grows beyond simple glue and warrants extraction into a standalone reusable package.
