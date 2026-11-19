# SPDX-License-Identifier: MIT
"""Provides the web fetch and time MCP server."""

import argparse
import asyncio
from collections.abc import AsyncGenerator, Sequence
import contextlib
import dataclasses
import datetime as dt
import ipaddress
import logging
import re
import socket
from typing import Annotated, Final
import urllib.parse
import zoneinfo

import bs4
import httpx
import markdownify
from mcp.server import mcpserver
import pydantic

logger = logging.getLogger(__name__)
_MAX_WEB_BYTES: Final[int] = 2 * 1024 * 1024

TimeZone = Annotated[
    str,
    pydantic.Field(
        description="IANA time zone name (e.g., 'UTC', 'Asia/Seoul')."
    ),
]
WebUrl = Annotated[
    str,
    pydantic.Field(description="HTTP or HTTPS URL of a public web page."),
]
FetchMaxLength = Annotated[
    int,
    pydantic.Field(
        ge=1,
        le=32000,
        description="Maximum number of characters to return.",
    ),
]
FetchStartIndex = Annotated[
    int,
    pydantic.Field(
        ge=0,
        description="Character offset to start reading from.",
    ),
]


class CurrentTimeResult(pydantic.BaseModel):
    """Represents the current local date, time, and weekday."""

    timezone: str
    iso_datetime: str
    weekday: str


@dataclasses.dataclass
class AppState:
    """Holds app-scoped HTTP client state."""

    http_client: httpx.AsyncClient


class AppServer(mcpserver.MCPServer[AppState]):
    """MCP server that retains a reference to active app state."""

    state: AppState


@contextlib.asynccontextmanager
async def lifespan(
    server: mcpserver.MCPServer[AppState],
) -> AsyncGenerator[AppState]:
    """Manage the app-scoped HTTP client."""
    del server
    http_client = httpx.AsyncClient(timeout=1800.0)
    state = AppState(http_client=http_client)
    mcp.state = state
    try:
        yield state
    finally:
        await state.http_client.aclose()


mcp = AppServer("local-ai-web", lifespan=lifespan)


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


def _html_to_markdown(html: str) -> str:
    """Strip non-content tags and convert HTML to compact Markdown."""
    soup = bs4.BeautifulSoup(html, "html.parser")
    for tag in soup(["script", "style", "noscript", "svg"]):
        tag.decompose()
    rendered = markdownify.markdownify(str(soup), heading_style="ATX")
    return re.sub(r"\n{3,}", "\n\n", rendered).strip()


@mcp.tool()
async def get_current_time(
    timezone: TimeZone = "UTC",
) -> CurrentTimeResult:
    """Return the current date, time, and weekday for an IANA time zone."""
    await asyncio.sleep(0)
    try:
        tz = zoneinfo.ZoneInfo(timezone)
    except zoneinfo.ZoneInfoNotFoundError as error:
        raise ValueError(f"Unknown time zone: {timezone}") from error
    now = dt.datetime.now(tz=tz)
    return CurrentTimeResult(
        timezone=timezone,
        iso_datetime=now.isoformat(),
        weekday=now.strftime("%A"),
    )


async def _fetch_limited_text(
    http_client: httpx.AsyncClient,
    url: str,
) -> tuple[str, str]:
    """Fetch a public HTTP(S) URL with redirect checks and a byte cap."""
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
                if total_bytes > _MAX_WEB_BYTES:
                    raise ValueError("Response body exceeds size limit.")
                chunks.append(chunk)
            encoding = response.encoding or "utf-8"
            content_type = response.headers.get("content-type", "").lower()
            return b"".join(chunks).decode(
                encoding, errors="replace"
            ), content_type
    raise ValueError(f"Too many redirects fetching: {url}")


@mcp.tool()
async def fetch_web(
    url: WebUrl,
    max_length: FetchMaxLength = 8000,
    start_index: FetchStartIndex = 0,
) -> str:
    """Fetch a public HTTP or HTTPS web page as Markdown or plain text."""
    raw_text, content_type = await _fetch_limited_text(
        mcp.state.http_client, url
    )
    if "html" in content_type or not content_type:
        content = _html_to_markdown(raw_text)
    else:
        content = raw_text

    total = len(content)
    if start_index >= total:
        return ""
    end = min(start_index + max_length, total)
    snippet = content[start_index:end]
    if end < total:
        snippet += (
            f"\n\n[Truncated; total {total} chars. "
            f"Call with start_index={end} to read more.]"
        )
    return snippet


def main(argv: Sequence[str] | None = None) -> int:
    """Run the web MCP server over streamable HTTP."""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
    )
    parser = argparse.ArgumentParser(description="mcp-web")
    parser.add_argument("--host", type=str, default="127.0.0.1")
    args = parser.parse_args(argv)
    mcp.run(transport="streamable-http", host=args.host, json_response=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
