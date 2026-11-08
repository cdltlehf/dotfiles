# SPDX-License-Identifier: MIT
"""Provides the MCP server tools, custom HTTP routes, and entry point."""

import argparse
import asyncio
from collections.abc import AsyncGenerator, Sequence
import contextlib
import logging
import os
import uuid

import httpx
from mcp.server import mcpserver
import openai
from starlette import requests
from starlette import responses

from mcp_server import models
from mcp_server import services

logger = logging.getLogger(__name__)


class AppServer(mcpserver.MCPServer[models.AppState]):
    """MCP server that retains a reference to active application state."""

    state: models.AppState


@contextlib.asynccontextmanager
async def lifespan(
    server: mcpserver.MCPServer[models.AppState],
) -> AsyncGenerator[models.AppState]:
    """Manage application-scoped HTTP clients and background tasks."""
    del server
    openai_client = openai.AsyncClient(
        base_url=os.environ["OPENAI_BASE_URL"],
        api_key=os.environ["OPENAI_API_KEY"],
    )
    http_client = httpx.AsyncClient()
    mcp_base_url = os.environ["MCP_BASE_URL"].rstrip("/")
    audio_model = os.environ["AUDIO_MODEL"]
    default_positive_prompt = os.environ.get(
        "IMAGE_DEFAULT_POSITIVE_PROMPT", ""
    ).strip()
    default_negative_prompt = os.environ.get(
        "IMAGE_DEFAULT_NEGATIVE_PROMPT", ""
    ).strip()
    state = models.AppState(
        openai_client=openai_client,
        http_client=http_client,
        mcp_base_url=mcp_base_url,
        audio_model=audio_model,
        default_positive_prompt=default_positive_prompt,
        default_negative_prompt=default_negative_prompt,
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
        await state.openai_client.close()


mcp = AppServer("local-ai-tools", lifespan=lifespan)


@mcp.tool()
async def start_image_generation(
    prompt: str,
    *,
    negative_prompt: str = "",
    size: models.ImageSize = "1024x1024",
) -> models.JobStatus:
    """Start an asynchronous image generation job.

    Args:
        prompt: A comma-separated list of descriptive visual tags.
        negative_prompt: A comma-separated list of visual tags to avoid.
        size: Output image dimensions in pixels.

    Returns:
        Initial job status containing the assigned job_id.
    """
    state = mcp.state
    await asyncio.sleep(0)
    job_id = uuid.uuid4().hex
    job = services.create_job(state.jobs, job_id)
    formatted_prompt = services.format_image_prompt(
        prompt,
        negative_prompt=negative_prompt,
        default_positive_prompt=state.default_positive_prompt,
        default_negative_prompt=state.default_negative_prompt,
    )
    coro = services.run_image_generation(
        job,
        state.openai_client,
        formatted_prompt,
        size,
    )
    task = asyncio.create_task(coro)
    state.running_tasks.add(task)
    task.add_done_callback(state.running_tasks.discard)
    return models.JobStatus(job_id=job_id, status=job.status)


@mcp.tool()
async def start_image_edit(
    image_url: str,
    prompt: str,
    *,
    negative_prompt: str = "",
    strength: float = 0.75,
    size: models.ImageSize = "1024x1024",
) -> models.JobStatus:
    """Start an asynchronous image editing job from an existing image URL.

    Args:
        image_url: HTTP or HTTPS URL of the source image to edit.
        prompt: A comma-separated list of visual tags describing the desired
            target image only, excluding any subjects being removed.
        negative_prompt: A comma-separated list of visual tags to avoid or
            remove, such as original subjects being replaced.
        strength: Denoising strength between 0.0 and 1.0 controlling how much
            the output diverges from the source image.
        size: Output image dimensions in pixels.

    Returns:
        Initial job status containing the assigned job_id.
    """
    state = mcp.state
    await asyncio.sleep(0)
    job_id = uuid.uuid4().hex
    job = services.create_job(state.jobs, job_id)
    formatted_prompt = services.format_image_prompt(
        prompt,
        negative_prompt=negative_prompt,
        default_positive_prompt=state.default_positive_prompt,
        default_negative_prompt=state.default_negative_prompt,
        strength=strength,
    )
    coro = services.run_image_edit(
        job,
        state.openai_client,
        state.http_client,
        image_url,
        formatted_prompt,
        size,
    )
    task = asyncio.create_task(coro)
    state.running_tasks.add(task)
    task.add_done_callback(state.running_tasks.discard)
    return models.JobStatus(job_id=job_id, status=job.status)


@mcp.tool()
async def get_image_result(
    job_id: str,
    wait_seconds: float = 0.0,
) -> models.JobStatus:
    """Retrieve the status or completed output URL of an image job.

    Args:
        job_id: Identifier returned when the image job was started.
        wait_seconds: Maximum time in seconds to wait for completion before
            returning the current job status.

    Returns:
        Current job status, including image_url when status is completed.
    """
    state = mcp.state
    job = state.jobs.get(job_id)
    if job is None:
        return models.JobStatus(
            job_id=job_id,
            status=models.JobState.FAILED,
            error=f"Job {job_id} not found.",
        )

    if wait_seconds > 0 and job.status in {
        models.JobState.PENDING,
        models.JobState.PROCESSING,
    }:
        with contextlib.suppress(TimeoutError):
            await asyncio.wait_for(job.event.wait(), timeout=wait_seconds)

    image_url = (
        f"{state.mcp_base_url}/images/{job_id}.png"
        if job.status == models.JobState.COMPLETED
        else None
    )
    return models.JobStatus(
        job_id=job_id,
        status=job.status,
        image_url=image_url,
        error=job.error,
    )


@mcp.tool()
async def transcribe_audio(
    audio_url: str,
    response_format: models.AudioResponseFormat = "json",
) -> str:
    """Transcribe an audio file from a URL into text or subtitles.

    Args:
        audio_url: HTTP or HTTPS URL of the source audio file.
        response_format: Output format for the transcription response.

    Returns:
        Transcribed text or formatted subtitle content.
    """
    state = mcp.state
    return await services.transcribe_audio(
        state.openai_client,
        state.http_client,
        audio_url,
        state.audio_model,
        response_format,
    )


@mcp.custom_route("/images/{filename}", methods=["GET"])
async def serve_image(request: requests.Request) -> responses.Response:
    """Serve a completed job image as a PNG response."""
    await asyncio.sleep(0)
    filename = str(request.path_params.get("filename", ""))
    job_id = filename.removesuffix(".png")
    job = mcp.state.jobs.get(job_id)
    match job:
        case models.ImageJob(status=models.JobState.COMPLETED):
            return responses.Response(
                content=job.image_bytes,
                media_type="image/png",
            )
        case _:
            return responses.Response(
                content="Image not found.",
                status_code=404,
                media_type="text/plain",
            )


def main(argv: Sequence[str] | None = None) -> int:
    """Execute main application logic."""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
    )
    parser = argparse.ArgumentParser(description="mcp-server")
    parser.parse_args(argv)

    host = os.environ["HOST"]
    port = int(os.environ["PORT"])
    mcp.run(transport="streamable-http", host=host, port=port)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
