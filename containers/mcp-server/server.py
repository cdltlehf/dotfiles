#!/usr/bin/env python3

import base64
import os
from typing import Literal, TypedDict

import anyio  # ty: ignore[unresolved-import]
import httpx  # ty: ignore[unresolved-import]
from mcp.server import mcpserver  # ty: ignore[unresolved-import]

PORT = int(os.environ.get("PORT", "8080"))
SD_ENDPOINT = os.environ.get(
    "SD_ENDPOINT",
    "http://sd-server:8080/v1/images/generations",
)
WHISPER_ENDPOINT = os.environ.get(
    "WHISPER_ENDPOINT",
    "http://whisper-server:8080/inference",
)

DEFAULT_NEGATIVE_PROMPT = ["low quality", "bad quality", "blurry", "deformed"]

mcp = mcpserver.MCPServer("local-ai-tools")

ImageResolution = Literal["512x512", "768x768", "1024x1024"]
AudioResponseFormat = Literal["json", "text", "srt", "vtt"]


class GenerateImagePayload(TypedDict):
    prompt: str
    negative_prompt: str
    size: ImageResolution
    response_format: Literal["b64_json"]


@mcp.tool()
async def generate_image(
    prompt: list[str],
    negative_prompt: list[str] | None = None,
    size: ImageResolution = "1024x1024",
) -> mcpserver.Image:
    merged_prompt = ", ".join(p.strip() for p in prompt if p.strip())
    merged_negative_prompt = ", ".join(negative_prompt or DEFAULT_NEGATIVE_PROMPT)
    payload = GenerateImagePayload(
        prompt=merged_prompt,
        negative_prompt=merged_negative_prompt,
        size=size,
        response_format="b64_json",
    )
    async with httpx.AsyncClient(timeout=300.0) as client:
        resp = await client.post(SD_ENDPOINT, json=payload)
        resp.raise_for_status()
        b64_data = resp.json()["data"][0]["b64_json"]
        return mcpserver.Image(data=base64.b64decode(b64_data), format="png")


@mcp.tool()
async def transcribe_audio(
    audio_path_or_url: str,
    response_format: AudioResponseFormat = "json",
) -> str:
    """Transcribe speech audio into text using local Whisper."""
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
            return resp.json().get("text", resp.text)
        return resp.text


if __name__ == "__main__":
    mcp.run(transport="sse", host="0.0.0.0", port=PORT)
