# SPDX-License-Identifier: MIT
"""Time and public web fetch tools for mcp-server."""

import asyncio
import datetime as dt
import re
from typing import Annotated, Final
import zoneinfo

import bs4
import markdownify
import pydantic

from mcp_server import models
from mcp_server import net

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


def _html_to_markdown(html: str) -> str:
    soup = bs4.BeautifulSoup(html, "html.parser")
    for tag in soup(["script", "style", "noscript", "svg"]):
        tag.decompose()
    rendered = markdownify.markdownify(str(soup), heading_style="ATX")
    return re.sub(r"\n{3,}", "\n\n", rendered).strip()


def register(server: models.AppServer) -> None:
    """Register time and web fetch tools on server."""

    @server.tool()
    async def get_current_time(
        timezone: TimeZone = "UTC",
    ) -> models.CurrentTimeResult:
        """Return the current date, time, and weekday for an IANA time zone."""
        await asyncio.sleep(0)
        try:
            tz = zoneinfo.ZoneInfo(timezone)
        except zoneinfo.ZoneInfoNotFoundError as error:
            raise ValueError(f"Unknown time zone: {timezone}") from error
        now = dt.datetime.now(tz=tz)
        return models.CurrentTimeResult(
            timezone=timezone,
            iso_datetime=now.isoformat(),
            weekday=now.strftime("%A"),
        )

    @server.tool()
    async def fetch_web(
        url: WebUrl,
        max_length: FetchMaxLength = 8000,
        start_index: FetchStartIndex = 0,
    ) -> str:
        """Fetch a public HTTP or HTTPS web page as Markdown or plain text."""
        raw_bytes, _, content_type, encoding = await net.fetch_limited(
            server.state.http_client, url, max_bytes=_MAX_WEB_BYTES
        )
        raw_text = raw_bytes.decode(encoding, errors="replace")
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
