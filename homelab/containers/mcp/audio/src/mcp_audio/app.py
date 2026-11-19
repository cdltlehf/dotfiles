# SPDX-License-Identifier: MIT
"""Provides the audio transcription MCP server."""

import argparse
import asyncio
from collections.abc import AsyncGenerator, Sequence
import contextlib
import dataclasses
import ipaddress
import logging
import os
import pathlib
import socket
from typing import Annotated, Final, Literal
import urllib.parse

import httpx
from mcp.server import mcpserver
import openai
import pydantic

logger = logging.getLogger(__name__)
_MAX_AUDIO_BYTES: Final[int] = 20 * 1024 * 1024

AudioResponseFormat = Annotated[
    Literal["json", "text", "srt", "vtt"],
    pydantic.Field(description="Output format for the transcription response."),
]
AudioUrl = Annotated[
    str,
    pydantic.Field(description="HTTP or HTTPS URL of the source audio file."),
]


@dataclasses.dataclass
class AppState:
    """Holds app-scoped HTTP and OpenAI clients."""

    openai_client: openai.AsyncClient
    http_client: httpx.AsyncClient


class AppServer(mcpserver.MCPServer[AppState]):
    """MCP server that retains a reference to active app state."""

    state: AppState


@contextlib.asynccontextmanager
async def lifespan(
    server: mcpserver.MCPServer[AppState],
) -> AsyncGenerator[AppState]:
    """Manage app-scoped HTTP and OpenAI clients."""
    del server
    openai_client = openai.AsyncClient(
        base_url=os.environ["OPENAI_BASE_URL"],
        api_key=os.environ["OPENAI_API_KEY"],
        timeout=1800.0,
    )
    http_client = httpx.AsyncClient(timeout=1800.0)
    state = AppState(openai_client=openai_client, http_client=http_client)
    mcp.state = state
    try:
        yield state
    finally:
        await state.http_client.aclose()
        await state.openai_client.close()


mcp = AppServer("local-ai-audio", lifespan=lifespan)


def _check_public_host(hostname: str) -> None:
    """Verify that every resolved IP for hostname is globally routable."""
    try:
        addr_info = socket.getaddrinfo(hostname, None, type=socket.SOCK_STREAM)
    except socket.gaierror as error:
        raise ValueError(f"Could not resolve host: {hostname}") from error
    if not addr_info:
        raise ValueError(f"Could not resolve host: {hostname}")
    for entry in addr_info:
        raw_ip = entry[4][0]
        ip = ipaddress.ip_address(raw_ip.split("%", 1)[0])
        if not ip.is_global:
            raise ValueError(f"Refusing non-public IP address: {ip}")


async def _validate_public_url(url: str) -> None:
    """Validate that a URL uses HTTP or HTTPS and points to a public host."""
    parsed = urllib.parse.urlsplit(url)
    if parsed.scheme not in {"http", "https"} or not parsed.hostname:
        raise ValueError(f"Invalid HTTP(S) URL: {url}")
    await asyncio.to_thread(_check_public_host, parsed.hostname)


async def _fetch_limited_audio(
    http_client: httpx.AsyncClient,
    url: str,
) -> tuple[bytes, str, str]:
    """Fetch a public audio URL with redirect checks and a byte cap."""
    current_url = url
    for _ in range(5):
        await _validate_public_url(current_url)
        async with http_client.stream(
            "GET", current_url, follow_redirects=False
        ) as response:
            if response.is_redirect and "location" in response.headers:
                current_url = urllib.parse.urljoin(
                    current_url, response.headers["location"]
                )
                continue
            response.raise_for_status()
            chunks: list[bytes] = []
            total_bytes = 0
            async for chunk in response.aiter_bytes():
                total_bytes += len(chunk)
                if total_bytes > _MAX_AUDIO_BYTES:
                    raise ValueError("Audio file exceeds size limit.")
                chunks.append(chunk)
            filename = (
                pathlib.PurePosixPath(
                    urllib.parse.urlsplit(current_url).path
                ).name
                or "audio.wav"
            )
            content_type = (
                response.headers
                .get("content-type", "")
                .split(";", 1)[0]
                .strip()
                or "application/octet-stream"
            )
            return b"".join(chunks), filename, content_type
    raise ValueError(f"Too many redirects fetching: {url}")


@mcp.tool()
async def transcribe_audio(
    audio_url: AudioUrl,
    response_format: AudioResponseFormat = "json",
) -> str:
    """Transcribe an audio file from a URL into text or subtitles."""
    state = mcp.state
    audio_bytes, filename, content_type = await _fetch_limited_audio(
        state.http_client, audio_url
    )
    transcription = await state.openai_client.audio.transcriptions.create(
        # The backend serves the one model it loaded and ignores this name.
        model="whisper-1",
        file=(filename, audio_bytes, content_type),
        response_format=response_format,
    )
    return (
        transcription if isinstance(transcription, str) else transcription.text
    )


def main(argv: Sequence[str] | None = None) -> int:
    """Run the audio MCP server over streamable HTTP."""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
    )
    parser = argparse.ArgumentParser(description="mcp-audio")
    parser.add_argument("--host", type=str, default="127.0.0.1")
    args = parser.parse_args(argv)
    mcp.run(transport="streamable-http", host=args.host, json_response=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
