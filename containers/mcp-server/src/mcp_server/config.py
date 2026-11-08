# SPDX-License-Identifier: MIT
"""Configuration settings and environment variable bindings."""

import os

HOST = (
    os.environ.get("HOST") or "0.0.0.0"  # ruff: ignore[hardcoded-bind-all-interfaces]
)
PORT = int(os.environ.get("PORT") or 8080)
IMAGE_GENERATION_ENDPOINT = os.environ.get(
    "IMAGE_GENERATION_ENDPOINT",
    "http://sd-server:8080/v1/images/generations",
)
IMAGE_EDIT_ENDPOINT = os.environ.get(
    "IMAGE_EDIT_ENDPOINT",
    "http://sd-server:8080/v1/images/edits",
)
AUDIO_TRANSCRIPTION_ENDPOINT = os.environ.get(
    "AUDIO_TRANSCRIPTION_ENDPOINT",
    "http://whisper-server:8080/inference",
)
MCP_BASE_URL = (
    os.environ.get("MCP_BASE_URL") or "http://localhost:3001"
).rstrip("/")

DEFAULT_POSITIVE_PROMPT: tuple[str, ...] = tuple(
    filter(
        None,
        (
            tag.strip()
            for tag in os.environ.get(
                "IMAGE_DEFAULT_POSITIVE_PROMPT", ""
            ).split(",")
        ),
    )
)
DEFAULT_NEGATIVE_PROMPT: tuple[str, ...] = tuple(
    filter(
        None,
        (
            tag.strip()
            for tag in os.environ.get(
                "IMAGE_DEFAULT_NEGATIVE_PROMPT", ""
            ).split(",")
        ),
    )
)
DEFAULT_DOWNLOAD_TIMEOUT_SECONDS = 60.0
IMAGE_TIMEOUT_SECONDS = 600.0
AUDIO_TIMEOUT_SECONDS = 180.0
MAX_WAIT_SECONDS = 30
