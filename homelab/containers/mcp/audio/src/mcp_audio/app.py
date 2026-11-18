# SPDX-License-Identifier: MIT
"""Provides the audio transcription MCP server."""

import argparse
from collections.abc import AsyncGenerator, Sequence
import contextlib
import dataclasses
import logging
import os
from typing import Annotated, Literal

import httpx
from mcp.server import mcpserver
import openai
import pydantic

logger = logging.getLogger(__name__)

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


@mcp.tool()
async def transcribe_audio(
    audio_url: AudioUrl,
    response_format: AudioResponseFormat = "json",
) -> str:
    """Transcribe an audio file from a URL into text or subtitles."""
    state = mcp.state
    audio_response = await state.http_client.get(audio_url)
    audio_response.raise_for_status()
    transcription = await state.openai_client.audio.transcriptions.create(
        # The backend serves the one model it loaded and ignores this name.
        model="whisper-1",
        file=("audio.wav", audio_response.content, "audio/wav"),
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
