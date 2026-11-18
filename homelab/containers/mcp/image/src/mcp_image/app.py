# SPDX-License-Identifier: MIT
"""Provides the image MCP server tools, custom HTTP routes, and entry point."""

import argparse
import asyncio
from collections.abc import AsyncGenerator, Sequence
import contextlib
import logging
import os
import pathlib
import urllib.parse
import uuid

import httpx
from mcp.server import mcpserver
import openai
from starlette import requests
from starlette import responses

from mcp_image import models
from mcp_image import services

logger = logging.getLogger(__name__)


class AppServer(mcpserver.MCPServer[models.AppState]):
    """MCP server that retains a reference to active app state."""

    state: models.AppState


@contextlib.asynccontextmanager
async def lifespan(
    server: mcpserver.MCPServer[models.AppState],
) -> AsyncGenerator[models.AppState]:
    """Manage app-scoped HTTP clients and background tasks."""
    del server
    openai_client = openai.AsyncClient(
        base_url=os.environ["OPENAI_BASE_URL"],
        api_key=os.environ["OPENAI_API_KEY"],
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
    default_positive_prompt = os.environ.get(
        "IMAGE_DEFAULT_POSITIVE_PROMPT", ""
    ).strip()
    default_negative_prompt = os.environ.get(
        "IMAGE_DEFAULT_NEGATIVE_PROMPT", ""
    ).strip()
    image_dir = pathlib.Path(os.environ.get("IMAGE_DIR", "/data/images"))
    await asyncio.to_thread(image_dir.mkdir, parents=True, exist_ok=True)
    state = models.AppState(
        openai_client=openai_client,
        http_client=http_client,
        allowed_hosts=frozenset(allowed_hosts),
        public_url=public_url,
        image_dir=image_dir,
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


mcp = AppServer("local-ai-image", lifespan=lifespan)


async def _settle(job: models.ImageJob, wait_seconds: float) -> None:
    """Wait up to wait_seconds for an active job to finish."""
    if wait_seconds > 0 and job.status in {
        models.JobState.PENDING,
        models.JobState.PROCESSING,
    }:
        with contextlib.suppress(TimeoutError):
            await asyncio.wait_for(job.event.wait(), timeout=wait_seconds)


@mcp.tool()
async def start_image_generation(
    prompt: models.ImagePrompt,
    *,
    negative_prompt: models.NegativePrompt = "",
    size: models.ImageSize = "1024x1024",
) -> models.JobStatus:
    """Start an asynchronous image generation job."""
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
        state,
        formatted_prompt,
        size,
    )
    task = asyncio.create_task(coro)
    state.running_tasks.add(task)
    task.add_done_callback(state.running_tasks.discard)
    return models.JobStatus(job_id=job_id, status=job.status)


@mcp.tool()
async def start_image_edit(
    prompt: models.EditPrompt,
    *,
    job_id: models.JobId | None = None,
    image_url: models.ImageUrl | None = None,
    negative_prompt: models.NegativePrompt = "",
    strength: models.EditStrength = 0.75,
    size: models.ImageSize = "1024x1024",
) -> models.JobStatus:
    """Start an asynchronous image editing job from an existing job ID or image URL."""
    if not job_id and not image_url:
        raise ValueError("Either job_id or image_url must be provided.")
    state = mcp.state
    await asyncio.sleep(0)
    new_job_id = uuid.uuid4().hex
    job = services.create_job(state.jobs, new_job_id)
    formatted_prompt = services.format_image_prompt(
        prompt,
        negative_prompt=negative_prompt,
        default_positive_prompt=state.default_positive_prompt,
        default_negative_prompt=state.default_negative_prompt,
        strength=strength,
    )
    coro = services.run_image_edit(
        job,
        state,
        formatted_prompt,
        size,
        job_id=job_id,
        image_url=image_url,
    )
    task = asyncio.create_task(coro)
    state.running_tasks.add(task)
    task.add_done_callback(state.running_tasks.discard)
    return models.JobStatus(job_id=new_job_id, status=job.status)


@mcp.tool()
async def start_image_upscale(
    *,
    job_id: models.JobId | None = None,
    image_url: models.ImageUrl | None = None,
    negative_prompt: models.NegativePrompt = "",
    strength: models.EditStrength = 0.55,
    size: models.ImageSize = "1536x1536",
) -> models.JobStatus:
    """Start an asynchronous image upscale job using high-resolution refinement."""
    return await start_image_edit(
        prompt=(
            "high resolution, sharp details, intricate textures, clear focus"
        ),
        job_id=job_id,
        image_url=image_url,
        negative_prompt=negative_prompt,
        strength=strength,
        size=size,
    )


@mcp.tool()
async def get_image_url(
    job_id: models.JobId,
    wait_seconds: models.WaitSeconds = 0.0,
    ctx: mcpserver.Context[models.AppState] | None = None,
) -> models.JobStatus:
    """Return an image job's status and, once finished, its URL."""
    state = mcp.state
    job = state.jobs.get(job_id)
    if job is None:
        persisted_path = services.image_path(state.image_dir, job_id)
        if persisted_path is not None and persisted_path.is_file():
            headers = ctx.headers if ctx else None
            base_url = services.resolve_base_url(
                headers,
                state.allowed_hosts,
                state.public_url,
            )
            return models.JobStatus(
                job_id=job_id,
                status=models.JobState.COMPLETED,
                image_url=f"{base_url}/images/{job_id}.png",
            )
        return models.JobStatus(
            job_id=job_id,
            status=models.JobState.FAILED,
            error=f"Job {job_id} not found.",
        )

    await _settle(job, wait_seconds)
    headers = ctx.headers if ctx else None
    base_url = services.resolve_base_url(
        headers,
        state.allowed_hosts,
        state.public_url,
    )
    image_url = (
        f"{base_url}/images/{job_id}.png"
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
async def get_image_result(
    job_id: models.JobId,
    wait_seconds: models.WaitSeconds = 0.0,
) -> mcpserver.Image | models.JobStatus:
    """Return a finished image job's image, or its status if unfinished."""
    state = mcp.state
    if job := state.jobs.get(job_id):
        await _settle(job, wait_seconds)
        if job.status != models.JobState.COMPLETED:
            return models.JobStatus(
                job_id=job_id,
                status=job.status,
                error=job.error,
            )
    image_path = services.image_path(state.image_dir, job_id)
    if image_path is None or not image_path.is_file():
        return models.JobStatus(
            job_id=job_id,
            status=models.JobState.FAILED,
            error=f"Job {job_id} not found.",
        )
    return mcpserver.Image(path=image_path)


@mcp.custom_route("/images/{filename}", methods=["GET"])
async def serve_image(request: requests.Request) -> responses.Response:
    """Serve a completed job image as a PNG response."""
    await asyncio.sleep(0)
    filename = str(request.path_params.get("filename", ""))
    if not filename.endswith(".png"):
        return responses.Response(
            content="Image not found.",
            status_code=404,
            media_type="text/plain",
        )
    job_id = filename.removesuffix(".png")
    image_path = services.image_path(mcp.state.image_dir, job_id)
    if image_path is not None and image_path.is_file():
        return responses.FileResponse(image_path, media_type="image/png")
    return responses.Response(
        content="Image not found.",
        status_code=404,
        media_type="text/plain",
    )


def main(argv: Sequence[str] | None = None) -> int:
    """Run the image MCP server over streamable HTTP."""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
    )
    parser = argparse.ArgumentParser(description="mcp-image")
    parser.add_argument("--host", type=str, default="127.0.0.1")
    args = parser.parse_args(argv)
    mcp.run(transport="streamable-http", host=args.host, json_response=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
