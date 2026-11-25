# SPDX-License-Identifier: MIT
"""Shared HTTP fetching, SSRF validation, and URL/path helpers."""

import asyncio
from collections.abc import Mapping
import ipaddress
import pathlib
import re
import socket
from typing import Final
import urllib.parse

import httpx

_ARTIFACT_ID_PATTERN: Final[re.Pattern[str]] = re.compile(r"^[0-9a-f]{32}$")


def artifact_path(
    base_dir: pathlib.Path,
    artifact_id: str,
    extension: str,
) -> pathlib.Path | None:
    """Return the validated artifact path for a hex ID, or None if invalid."""
    if not _ARTIFACT_ID_PATTERN.fullmatch(artifact_id):
        return None
    return base_dir / f"{artifact_id}.{extension}"


def resolve_base_url(
    headers: Mapping[str, str] | None,
    allowed_hosts: frozenset[str],
    public_url: str = "",
) -> str:
    """Resolve the effective base URL from config or request headers."""
    if public_url:
        return public_url
    if not headers:
        return ""
    raw_host = headers.get("x-forwarded-host") or headers.get("host")
    if not raw_host:
        return ""
    hostname = raw_host.split(":", 1)[0].lower()
    if hostname not in allowed_hosts:
        return ""
    scheme = headers.get("x-forwarded-proto") or "http"
    return f"{scheme}://{raw_host}"


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


async def validate_public_url(url: str) -> None:
    """Validate that a URL uses HTTP or HTTPS and points to a public host."""
    parsed = urllib.parse.urlsplit(url)
    if parsed.scheme not in {"http", "https"} or not parsed.hostname:
        raise ValueError(f"Invalid HTTP(S) URL: {url}")
    await asyncio.to_thread(_check_public_host, parsed.hostname)


async def fetch_limited(
    http_client: httpx.AsyncClient,
    url: str,
    *,
    max_bytes: int,
) -> tuple[bytes, str, str, str]:
    """Fetch a public URL with redirect validation and a byte cap.

    Returns (body_bytes, final_url, content_type, encoding).
    """
    current_url = url
    for _ in range(5):
        await validate_public_url(current_url)
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
                if total_bytes > max_bytes:
                    raise ValueError("Response body exceeds size limit.")
                chunks.append(chunk)
            content_type = (
                response.headers
                .get("content-type", "")
                .split(";", 1)[0]
                .strip()
                .lower()
            )
            encoding = response.encoding or "utf-8"
            return b"".join(chunks), current_url, content_type, encoding
    raise ValueError(f"Too many redirects fetching: {url}")
