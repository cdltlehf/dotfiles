# SPDX-License-Identifier: MIT
"""Storage and retrieval helpers for binary assets."""

import base64

import httpx

from mcp_server import config
from mcp_server import models


async def fetch_binary_data(
    source: str, client: httpx.AsyncClient | None = None
) -> bytes:
    """Download or decode raw bytes from an HTTP URL, data URI, or base64 text.

    Args:
        source: Remote URL, data URI, or base64-encoded string.
        client: Optional shared HTTP client for fetching remote URLs.

    Returns:
        Decoded binary content.
    """
    if source.startswith(("http://", "https://")):
        if client is None:
            async with httpx.AsyncClient() as local_client:
                return await fetch_binary_data(source, client=local_client)
        response = await client.get(
            source, timeout=config.DEFAULT_DOWNLOAD_TIMEOUT_SECONDS
        )
        response.raise_for_status()
        return response.content

    if source.startswith("data:"):
        _, _, b64_payload = source.partition(",")
        return base64.b64decode(b64_payload)

    return base64.b64decode(source)


async def resolve_image_bytes(
    source: str,
    jobs: dict[str, models.JobRecord],
    client: httpx.AsyncClient | None = None,
) -> bytes:
    """Resolve raw image bytes from job ID, remote URL, or base64.

    Args:
        source: Previous job ID, URL, data URI, or base64 string.
        jobs: In-memory registry of image jobs.
        client: Optional shared HTTP client for fetching remote URLs.

    Returns:
        Raw image bytes.

    Raises:
        ValueError: If the referenced job is pending, failed, or not found.
    """
    if source in jobs:
        job = jobs[source]
        if job.get("status") == "completed" and "data" in job:
            return job["data"]
        status = job.get("status", "unknown")
        if status == "failed":
            error_msg = job.get("error", "unknown error")
            raise ValueError(f"Job '{source}' failed: {error_msg}")
        raise ValueError(
            f"Job '{source}' is not completed yet (current status: '{status}')."
        )

    if source.startswith(("http://", "https://")):
        filename = source.rstrip("/").split("/")[-1]
        job_id = filename.removesuffix(".png")
        if job_id in jobs:
            return await resolve_image_bytes(job_id, jobs, client=client)

    return await fetch_binary_data(source, client=client)
