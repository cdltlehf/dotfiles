#!/usr/bin/env python3
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     'anyio>=4.15.1',
#     'httpx>=0.28.1',
#     'mcp[cli]>=2.3.0',
# ]
# ///

# SPDX-License-Identifier: MIT
"""Local AI tools MCP server."""

import asyncio
import base64
import os
from typing import Any, Literal, TypedDict
import uuid

import anyio
import httpx
from mcp.server import mcpserver

HOST = os.environ.get("HOST", "127.0.0.1")
PORT = int(os.environ.get("PORT", "8080"))
SD_ENDPOINT = os.environ.get(
    "SD_ENDPOINT",
    "http://sd-server:8080/v1/images/generations",
)
WHISPER_ENDPOINT = os.environ.get(
    "WHISPER_ENDPOINT",
    "http://whisper-server:8080/inference",
)

DEFAULT_NEGATIVE_PROMPT = ("low quality", "bad quality", "blurry", "deformed")

mcp = mcpserver.MCPServer("local-ai-tools")

ImageResolution = Literal["512x512", "768x768", "1024x1024"]
AudioResponseFormat = Literal["json", "text", "srt", "vtt"]

JOBS: dict[str, dict[str, Any]] = {}
RUNNING_TASKS: set[asyncio.Task[None]] = set()


class GenerateImagePayload(TypedDict):
    """Image generation payload."""

    prompt: str
    negative_prompt: str
    size: ImageResolution
    response_format: Literal["b64_json"]


async def _run_generation(job_id: str, payload: GenerateImagePayload) -> None:
    try:
        async with httpx.AsyncClient(timeout=300.0) as client:
            resp = await client.post(SD_ENDPOINT, json=payload)
            resp.raise_for_status()
            b64_data = resp.json()["data"][0]["b64_json"]
            JOBS[job_id] = {
                "status": "completed",
                "data": base64.b64decode(b64_data),
            }
    except (httpx.HTTPError, KeyError, ValueError) as err:
        JOBS[job_id] = {"status": "failed", "error": str(err)}


@mcp.tool()
def start_image_generation(
    tags: list[str],
    negative_tags: list[str] | None = None,
    size: ImageResolution = "1024x1024",
) -> str:
    """Start asynchronous image generation."""
    job_id = uuid.uuid4().hex[:8]
    JOBS[job_id] = {"status": "pending"}
    payload = GenerateImagePayload(
        prompt=", ".join(p.strip() for p in tags if p.strip()),
        negative_prompt=", ".join(negative_tags or DEFAULT_NEGATIVE_PROMPT),
        size=size,
        response_format="b64_json",
    )
    task = asyncio.create_task(_run_generation(job_id, payload))
    RUNNING_TASKS.add(task)
    task.add_done_callback(RUNNING_TASKS.discard)
    return job_id


@mcp.tool()
def get_image_result(job_id: str) -> mcpserver.Image | str:
    """Fetch status or completed image for a job ID."""
    job = JOBS.get(job_id)
    if not job:
        return "job not found"
    if job["status"] == "pending":
        return "processing"
    if job["status"] == "failed":
        return f"failed: {job.get('error')}"
    return mcpserver.Image(data=job["data"], format="png")


@mcp.tool()
async def transcribe_audio(
    audio_path_or_url: str,
    response_format: AudioResponseFormat = "json",
) -> str:
    """Transcribe speech audio into text using Whisper."""
    async with httpx.AsyncClient(timeout=180.0) as client:
        if audio_path_or_url.startswith(("http://", "https://")):
            audio_resp = await client.get(audio_path_or_url)
            audio_resp.raise_for_status()
            audio_bytes = audio_resp.content
        else:
            audio_bytes = await anyio.Path(audio_path_or_url).read_bytes()

        files = {"file": ("audio.wav", audio_bytes, "audio/wav")}
        data = {"response_format": response_format}
        resp = await client.post(WHISPER_ENDPOINT, files=files, data=data)
        resp.raise_for_status()
        if response_format == "json":
            return str(resp.json().get("text", resp.text))
        return resp.text


if __name__ == "__main__":
    mcp.run(transport="streamable-http", host=HOST, port=PORT)
