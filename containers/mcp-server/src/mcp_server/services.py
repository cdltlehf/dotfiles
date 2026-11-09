# SPDX-License-Identifier: MIT
"""Business logic and external API clients for image and audio tasks."""

import base64
from collections.abc import Mapping
import json
from typing import Final

import httpx
import openai
import pydantic

from mcp_server import models

MAX_JOBS: Final[int] = 4


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
    job = models.ImageJob()
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


async def run_image_generation(
    job: models.ImageJob,
    openai_client: openai.AsyncClient,
    prompt: str,
    size: models.ImageSize,
) -> None:
    """Execute an image generation job and record its outcome."""
    job.status = models.JobState.PROCESSING
    try:
        job.image_bytes = await _generate_image(openai_client, prompt, size)
        job.status = models.JobState.COMPLETED
    except (openai.OpenAIError, ValueError) as error:
        job.status = models.JobState.FAILED
        job.error = str(error)
    finally:
        job.event.set()


def resolve_base_url(
    headers: Mapping[str, str] | None,
    allowed_hosts: frozenset[str],
    fallback_base_url: str = "",
) -> str:
    """Resolve the effective base URL from request headers if permitted."""
    if not headers:
        return fallback_base_url
    raw_host = headers.get("x-forwarded-host") or headers.get("host")
    if not raw_host:
        return fallback_base_url
    hostname = raw_host.split(":", 1)[0].lower()
    if hostname not in allowed_hosts:
        return fallback_base_url
    scheme = headers.get("x-forwarded-proto") or "http"
    return f"{scheme}://{raw_host}"


async def resolve_input_image(
    http_client: httpx.AsyncClient,
    jobs: Mapping[str, models.ImageJob],
    *,
    job_id: str | None = None,
    image_url: str | None = None,
) -> bytes:
    """Resolve input image bytes from an existing completed job or external URL."""
    if job_id:
        source_job = jobs.get(job_id)
        if source_job is None:
            raise ValueError(f"Job {job_id} not found.")
        if (
            source_job.status != models.JobState.COMPLETED
            or not source_job.image_bytes
        ):
            raise ValueError(f"Job {job_id} is not completed.")
        return source_job.image_bytes

    if image_url:
        response = await http_client.get(image_url)
        response.raise_for_status()
        return response.content

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
    """Execute an image editing job and record its outcome."""
    job.status = models.JobState.PROCESSING
    try:
        image_bytes = await resolve_input_image(
            state.http_client,
            state.jobs,
            job_id=job_id,
            image_url=image_url,
        )
        job.image_bytes = await _edit_image(
            state.openai_client,
            image_bytes,
            prompt,
            size,
        )
        job.status = models.JobState.COMPLETED
    except (httpx.HTTPError, openai.OpenAIError, ValueError) as error:
        job.status = models.JobState.FAILED
        job.error = str(error)
    finally:
        job.event.set()


async def transcribe_audio(
    openai_client: openai.AsyncClient,
    http_client: httpx.AsyncClient,
    audio_url: str,
    model: str,
    response_format: models.AudioResponseFormat,
) -> str:
    """Download an audio file and transcribe it via the backend."""
    audio_response = await http_client.get(audio_url)
    audio_response.raise_for_status()
    transcription = await openai_client.audio.transcriptions.create(
        model=model,
        file=("audio.wav", audio_response.content, "audio/wav"),
        response_format=response_format,
    )
    return (
        transcription if isinstance(transcription, str) else transcription.text
    )
