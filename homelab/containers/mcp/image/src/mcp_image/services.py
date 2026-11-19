# SPDX-License-Identifier: MIT
"""Business logic and external API clients for image tasks."""

import asyncio
import base64
from collections.abc import Mapping
import ipaddress
import json
import pathlib
import re
import socket
from typing import Final
import urllib.parse

import httpx
import openai
import pydantic

from mcp_image import models

MAX_JOBS: Final[int] = 4
_MAX_IMAGE_BYTES: Final[int] = 20 * 1024 * 1024
_JOB_ID_PATTERN: Final[re.Pattern[str]] = re.compile(r"^[0-9a-f]{32}$")


def image_path(image_dir: pathlib.Path, job_id: str) -> pathlib.Path | None:
    """Return the validated PNG path for a job ID, or None if invalid."""
    if not _JOB_ID_PATTERN.fullmatch(job_id):
        return None
    return image_dir / f"{job_id}.png"


def create_job(
    jobs: dict[str, models.ImageJob],
    job_id: str,
) -> models.ImageJob:
    """Register a new image job and evict the oldest finished job when full."""
    if len(jobs) >= MAX_JOBS:
        finished_states = {models.JobState.COMPLETED, models.JobState.FAILED}
        evictable_jobs = (
            existing_id
            for existing_id, existing_job in jobs.items()
            if existing_job.status in finished_states
        )
        evictable_job_id = next(evictable_jobs, None)
        if evictable_job_id is None:
            raise RuntimeError("Server is busy.")
        jobs.pop(evictable_job_id)
    job = models.ImageJob(job_id=job_id)
    jobs[job_id] = job
    return job


def format_image_prompt(
    prompt: str,
    *,
    negative_prompt: str,
    default_positive_prompt: str,
    default_negative_prompt: str,
    strength: float | None = None,
) -> str:
    """Combine user prompts with configured defaults and extra arguments."""

    def strip_and_combine(user_prompt: str, default_prompt: str) -> str:
        user_prompt = user_prompt.strip()
        if user_prompt and default_prompt:
            return f"{user_prompt}, {default_prompt}"
        return user_prompt or default_prompt

    prompt = strip_and_combine(prompt, default_positive_prompt)
    negative_prompt = strip_and_combine(
        negative_prompt, default_negative_prompt
    )
    extra_arguments: dict[str, pydantic.JsonValue] = {}
    if negative_prompt:
        extra_arguments["negative_prompt"] = negative_prompt
    if strength is not None:
        extra_arguments["strength"] = strength

    if extra_arguments:
        sd_cpp_extra_args = json.dumps(extra_arguments)
        return f"{prompt} <sd_cpp_extra_args>{sd_cpp_extra_args}</sd_cpp_extra_args>"
    return prompt


async def _generate_image(
    openai_client: openai.AsyncClient,
    prompt: str,
    size: models.ImageSize,
) -> bytes:
    response = await openai_client.images.generate(
        prompt=prompt,
        size=size,
        response_format="b64_json",
    )
    if not response.data or not response.data[0].b64_json:
        raise ValueError("Missing image data in response.")
    return base64.b64decode(response.data[0].b64_json)


async def write_image(
    image_dir: pathlib.Path,
    job_id: str,
    image_bytes: bytes,
) -> None:
    """Validate the job ID and persist PNG bytes to disk."""
    output_path = image_path(image_dir, job_id)
    if output_path is None:
        raise ValueError(f"Invalid job ID: {job_id}")
    await asyncio.to_thread(output_path.write_bytes, image_bytes)


async def run_image_generation(
    job: models.ImageJob,
    state: models.AppState,
    prompt: str,
    size: models.ImageSize,
) -> None:
    """Execute an image generation job and persist its output to disk."""
    job.status = models.JobState.PROCESSING
    try:
        image_bytes = await _generate_image(state.openai_client, prompt, size)
        await write_image(state.image_dir, job.job_id, image_bytes)
        job.status = models.JobState.COMPLETED
    except (OSError, openai.OpenAIError, ValueError) as error:
        job.status = models.JobState.FAILED
        job.error = str(error)
    finally:
        job.event.set()


def resolve_base_url(
    headers: Mapping[str, str] | None,
    allowed_hosts: frozenset[str],
    base_url: str = "",
) -> str:
    """Resolve the effective base URL from config or request headers."""
    if base_url:
        return base_url
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


async def _validate_public_url(url: str) -> None:
    """Validate that a URL uses HTTP or HTTPS and points to a public host."""
    parsed = urllib.parse.urlsplit(url)
    if parsed.scheme not in {"http", "https"} or not parsed.hostname:
        raise ValueError(f"Invalid HTTP(S) URL: {url}")
    await asyncio.to_thread(_check_public_host, parsed.hostname)


async def _fetch_limited_image(
    http_client: httpx.AsyncClient,
    url: str,
) -> bytes:
    """Fetch a public image URL with redirect checks and a byte cap."""
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
                if total_bytes > _MAX_IMAGE_BYTES:
                    raise ValueError("Image file exceeds size limit.")
                chunks.append(chunk)
            return b"".join(chunks)
    raise ValueError(f"Too many redirects fetching: {url}")


async def resolve_input_image(
    state: models.AppState,
    *,
    job_id: str | None = None,
    image_url: str | None = None,
) -> bytes:
    """Resolve input image bytes from an existing completed job or external URL."""
    if job_id:
        source_job = state.jobs.get(job_id)
        if (
            source_job is not None
            and source_job.status != models.JobState.COMPLETED
        ):
            raise ValueError(f"Job {job_id} is not completed.")
        source_path = image_path(state.image_dir, job_id)
        if source_path is None or not source_path.is_file():
            raise ValueError(f"Job {job_id} not found.")
        return await asyncio.to_thread(source_path.read_bytes)

    if image_url:
        return await _fetch_limited_image(state.http_client, image_url)

    raise ValueError("Either job_id or image_url must be provided.")


async def _edit_image(
    openai_client: openai.AsyncClient,
    image_bytes: bytes,
    prompt: str,
    size: models.ImageSize,
) -> bytes:
    response = await openai_client.images.edit(
        image=image_bytes,
        prompt=prompt,
        size=size,
        response_format="b64_json",
    )
    if not response.data or not response.data[0].b64_json:
        raise ValueError("Missing image data in response.")
    return base64.b64decode(response.data[0].b64_json)


async def run_image_edit(
    job: models.ImageJob,
    state: models.AppState,
    prompt: str,
    size: models.ImageSize,
    *,
    job_id: str | None = None,
    image_url: str | None = None,
) -> None:
    """Execute an image editing job and persist its output to disk."""
    job.status = models.JobState.PROCESSING
    try:
        image_bytes = await resolve_input_image(
            state,
            job_id=job_id,
            image_url=image_url,
        )
        edited_bytes = await _edit_image(
            state.openai_client,
            image_bytes,
            prompt,
            size,
        )
        await write_image(state.image_dir, job.job_id, edited_bytes)
        job.status = models.JobState.COMPLETED
    except (OSError, httpx.HTTPError, openai.OpenAIError, ValueError) as error:
        job.status = models.JobState.FAILED
        job.error = str(error)
    finally:
        job.event.set()
