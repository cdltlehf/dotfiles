# SPDX-License-Identifier: MIT
"""Provides the unified JSON-response MCP server entry point."""

import argparse
import asyncio
from collections.abc import AsyncGenerator, Sequence
import contextlib
import logging
import os
import pathlib
import urllib.parse

import httpx
from mcp.server import mcpserver
import openai

from mcp_server import audio
from mcp_server import image
from mcp_server import models
from mcp_server import web


def _env_enabled(name: str, *, default: bool = False) -> bool:
    raw = os.environ.get(name)
    if raw is None:
        return default
    return raw.strip().lower() in {"1", "true", "yes", "on"}


@contextlib.asynccontextmanager
async def lifespan(
    server: mcpserver.MCPServer[models.AppState],
) -> AsyncGenerator[models.AppState]:
    """Manage app-scoped HTTP/OpenAI clients and background tasks."""
    del server
    openai_client = openai.AsyncClient(
        base_url=os.environ["OPENAI_BASE_URL"],
        api_key=os.environ["OPENAI_API_KEY"],
        timeout=1800.0,
    )
    image_client = openai.AsyncClient(
        base_url=os.environ.get("IMAGE_BASE_URL", "http://sd-server:1234/v1"),
        api_key="unused",
        timeout=1800.0,
    )
    http_client = httpx.AsyncClient(timeout=1800.0)
    public_url = os.environ.get("PUBLIC_URL", "").strip().rstrip("/")
    allowed_hosts = {"localhost", "127.0.0.1"}
    if public_url:
        parsed_host = urllib.parse.urlsplit(public_url).hostname
        if parsed_host:
            allowed_hosts.add(parsed_host.lower())
    for host in os.environ.get("ALLOWED_HOSTS", "").split(","):
        stripped = host.strip().lower()
        if stripped:
            allowed_hosts.add(stripped)
    image_dir = pathlib.Path(os.environ.get("IMAGE_DIR", "/data/images"))
    audio_dir = pathlib.Path(os.environ.get("AUDIO_DIR", "/data/audio"))
    await asyncio.to_thread(image_dir.mkdir, parents=True, exist_ok=True)
    await asyncio.to_thread(audio_dir.mkdir, parents=True, exist_ok=True)
    state = models.AppState(
        openai_client=openai_client,
        image_client=image_client,
        http_client=http_client,
        allowed_hosts=frozenset(allowed_hosts),
        public_url=public_url,
        image_dir=image_dir,
        audio_dir=audio_dir,
        speech_model=os.environ.get("SPEECH_MODEL", "default").strip(),
        default_positive_prompt=os.environ.get(
            "IMAGE_DEFAULT_POSITIVE_PROMPT", ""
        ).strip(),
        default_negative_prompt=os.environ.get(
            "IMAGE_DEFAULT_NEGATIVE_PROMPT", ""
        ).strip(),
    )
    mcp.state = state
    try:
        yield state
    finally:
        pending_tasks = tuple(state.running_tasks)
        for task in pending_tasks:
            task.cancel()
        if pending_tasks:
            await asyncio.gather(*pending_tasks, return_exceptions=True)
        await state.http_client.aclose()
        await state.image_client.close()
        await state.openai_client.close()


mcp = models.AppServer("local-ai-tools", lifespan=lifespan)
web.register(mcp)
if _env_enabled("MCP_ENABLE_IMAGE", default=True):
    image.register(mcp)
audio.register(
    mcp,
    enable_transcribe=_env_enabled("MCP_ENABLE_AUDIO", default=True),
    enable_speech=_env_enabled("MCP_ENABLE_SPEECH", default=True),
)


def main(argv: Sequence[str] | None = None) -> int:
    """Run the MCP server over streamable HTTP with JSON responses."""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
    )
    parser = argparse.ArgumentParser(description="mcp-server")
    parser.add_argument("--host", type=str, default="127.0.0.1")
    args = parser.parse_args(argv)
    mcp.run(transport="streamable-http", host=args.host, json_response=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
