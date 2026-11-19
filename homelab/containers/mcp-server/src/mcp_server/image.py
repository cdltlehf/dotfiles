# SPDX-License-Identifier: MIT
"""Image generation, editing, and serving tools for mcp-server."""

import asyncio
import base64
import contextlib
import json
import pathlib
from typing import Annotated, Final
import uuid

import httpx
from mcp.server import mcpserver
import openai
import pydantic
from starlette import requests
from starlette import responses

from mcp_server import models
from mcp_server import net

_MAX_JOBS: Final[int] = 4
_MAX_IMAGE_BYTES: Final[int] = 20 * 1024 * 1024

ImagePrompt = Annotated[
    str,
    pydantic.Field(description="Visual description of the desired image."),
]
EditPrompt = Annotated[
    str,
    pydantic.Field(
        description="Target image description excluding removed subjects."
    ),
]
NegativePrompt = Annotated[
    str,
    pydantic.Field(
        description="Visual elements or subjects to exclude or remove."
    ),
]
EditStrength = Annotated[
    float,
    pydantic.Field(
        ge=0.0,
        le=1.0,
        description="Denoising strength between 0.0 and 1.0.",
    ),
]
ImageUrl = Annotated[
    str,
    pydantic.Field(
        description="HTTP or HTTPS URL of an external source image."
    ),
]
JobId = Annotated[
    str,
    pydantic.Field(
        description=(
            "Identifier of an image job (for status checking or input source)."
        )
    ),
]
WaitSeconds = Annotated[
    float,
    pydantic.Field(
        ge=0.0,
        le=30.0,
        description="Maximum seconds to wait for job completion.",
    ),
]


def _create_job(
    jobs: dict[str, models.ImageJob],
    job_id: str,
) -> models.ImageJob:
    if len(jobs) >= _MAX_JOBS:
        finished = {models.JobState.COMPLETED, models.JobState.FAILED}
        evictable = (
            existing_id
            for existing_id, existing_job in jobs.items()
            if existing_job.status in finished
        )
        evictable_id = next(evictable, None)
        if evictable_id is None:
            raise RuntimeError("Server is busy.")
        jobs.pop(evictable_id)
    job = models.ImageJob(job_id=job_id)
    jobs[job_id] = job
    return job


def _format_prompt(
    prompt: str,
    *,
    negative_prompt: str,
    default_positive: str,
    default_negative: str,
    strength: float | None = None,
) -> str:
    def combine(user_val: str, default_val: str) -> str:
        stripped = user_val.strip()
        if stripped and default_val:
            return f"{stripped}, {default_val}"
        return stripped or default_val

    pos = combine(prompt, default_positive)
    neg = combine(negative_prompt, default_negative)
    extra: dict[str, pydantic.JsonValue] = {}
    if neg:
        extra["negative_prompt"] = neg
    if strength is not None:
        extra["strength"] = strength
    if extra:
        return (
            f"{pos} <sd_cpp_extra_args>{json.dumps(extra)}</sd_cpp_extra_args>"
        )
    return pos


async def _write_image(
    image_dir: pathlib.Path,
    job_id: str,
    image_bytes: bytes,
) -> None:
    output_path = net.artifact_path(image_dir, job_id, "png")
    if output_path is None:
        raise ValueError(f"Invalid job ID: {job_id}")
    await asyncio.to_thread(output_path.write_bytes, image_bytes)


def _decode_image_response(response: object) -> bytes:
    data = getattr(response, "data", None)
    if not data or not data[0].b64_json:
        raise ValueError("Missing image data in response.")
    return base64.b64decode(data[0].b64_json)


async def _run_generation(
    job: models.ImageJob,
    state: models.AppState,
    prompt: str,
    size: models.ImageSize,
) -> None:
    job.status = models.JobState.PROCESSING
    try:
        response = await state.image_client.images.generate(
            prompt=prompt,
            size=size,
            response_format="b64_json",
        )
        await _write_image(
            state.image_dir,
            job.job_id,
            _decode_image_response(response),
        )
        job.status = models.JobState.COMPLETED
    except (OSError, openai.OpenAIError, ValueError) as error:
        job.status = models.JobState.FAILED
        job.error = str(error)
    finally:
        job.event.set()


async def _resolve_input(
    state: models.AppState,
    *,
    job_id: str | None,
    image_url: str | None,
) -> bytes:
    if job_id:
        source_job = state.jobs.get(job_id)
        if (
            source_job is not None
            and source_job.status != models.JobState.COMPLETED
        ):
            raise ValueError(f"Job {job_id} is not completed.")
        source_path = net.artifact_path(state.image_dir, job_id, "png")
        if source_path is None or not source_path.is_file():
            raise ValueError(f"Job {job_id} not found.")
        return await asyncio.to_thread(source_path.read_bytes)

    if image_url:
        body, _, _, _ = await net.fetch_limited(
            state.http_client, image_url, max_bytes=_MAX_IMAGE_BYTES
        )
        return body

    raise ValueError("Either job_id or image_url must be provided.")


async def _run_edit(
    job: models.ImageJob,
    state: models.AppState,
    prompt: str,
    size: models.ImageSize,
    *,
    job_id: str | None,
    image_url: str | None,
) -> None:
    job.status = models.JobState.PROCESSING
    try:
        source_bytes = await _resolve_input(
            state, job_id=job_id, image_url=image_url
        )
        response = await state.image_client.images.edit(
            image=source_bytes,
            prompt=prompt,
            size=size,
            response_format="b64_json",
        )
        await _write_image(
            state.image_dir,
            job.job_id,
            _decode_image_response(response),
        )
        job.status = models.JobState.COMPLETED
    except (OSError, httpx.HTTPError, openai.OpenAIError, ValueError) as error:
        job.status = models.JobState.FAILED
        job.error = str(error)
    finally:
        job.event.set()


async def _settle(job: models.ImageJob, wait_seconds: float) -> None:
    if wait_seconds > 0 and job.status in {
        models.JobState.PENDING,
        models.JobState.PROCESSING,
    }:
        with contextlib.suppress(TimeoutError):
            await asyncio.wait_for(job.event.wait(), timeout=wait_seconds)


def _register_jobs(server: models.AppServer) -> None:
    @server.tool()
    async def start_image_generation(
        prompt: ImagePrompt,
        *,
        negative_prompt: NegativePrompt = "",
        size: models.ImageSize = "1024x1024",
    ) -> models.JobStatus:
        """Start an asynchronous image generation job."""
        state = server.state
        await asyncio.sleep(0)
        job_id = uuid.uuid4().hex
        job = _create_job(state.jobs, job_id)
        formatted = _format_prompt(
            prompt,
            negative_prompt=negative_prompt,
            default_positive=state.default_positive_prompt,
            default_negative=state.default_negative_prompt,
        )
        task = asyncio.create_task(_run_generation(job, state, formatted, size))
        state.running_tasks.add(task)
        task.add_done_callback(state.running_tasks.discard)
        return models.JobStatus(job_id=job_id, status=job.status)

    @server.tool()
    async def start_image_edit(
        prompt: EditPrompt,
        *,
        job_id: JobId | None = None,
        image_url: ImageUrl | None = None,
        negative_prompt: NegativePrompt = "",
        strength: EditStrength = 0.75,
        size: models.ImageSize = "1024x1024",
    ) -> models.JobStatus:
        """Start an asynchronous image editing job from a job ID or URL."""
        if not job_id and not image_url:
            raise ValueError("Either job_id or image_url must be provided.")
        state = server.state
        await asyncio.sleep(0)
        new_job_id = uuid.uuid4().hex
        job = _create_job(state.jobs, new_job_id)
        formatted = _format_prompt(
            prompt,
            negative_prompt=negative_prompt,
            default_positive=state.default_positive_prompt,
            default_negative=state.default_negative_prompt,
            strength=strength,
        )
        task = asyncio.create_task(
            _run_edit(
                job,
                state,
                formatted,
                size,
                job_id=job_id,
                image_url=image_url,
            )
        )
        state.running_tasks.add(task)
        task.add_done_callback(state.running_tasks.discard)
        return models.JobStatus(job_id=new_job_id, status=job.status)

    @server.tool()
    async def start_image_upscale(
        *,
        job_id: JobId | None = None,
        image_url: ImageUrl | None = None,
        negative_prompt: NegativePrompt = "",
        strength: EditStrength = 0.55,
        size: models.ImageSize = "1536x1536",
    ) -> models.JobStatus:
        """Start an asynchronous image upscale job."""
        return await start_image_edit(
            prompt=(
                "high resolution, sharp details, intricate textures, "
                "clear focus"
            ),
            job_id=job_id,
            image_url=image_url,
            negative_prompt=negative_prompt,
            strength=strength,
            size=size,
        )


def _register_retrieval(server: models.AppServer) -> None:
    @server.tool()
    async def get_image_url(
        job_id: JobId,
        wait_seconds: WaitSeconds = 0.0,
        ctx: mcpserver.Context[models.AppState] | None = None,
    ) -> models.JobStatus:
        """Return an image job's status and, once finished, its URL."""
        state = server.state
        headers = ctx.headers if ctx else None
        base_url = net.resolve_base_url(
            headers, state.allowed_hosts, state.public_url
        )
        job = state.jobs.get(job_id)
        if job is None:
            persisted = net.artifact_path(state.image_dir, job_id, "png")
            if persisted is not None and persisted.is_file():
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

    @server.tool()
    async def get_image_result(
        job_id: JobId,
        wait_seconds: WaitSeconds = 0.0,
    ) -> mcpserver.Image | models.JobStatus:
        """Return a finished image job's image, or its status if unfinished."""
        state = server.state
        if job := state.jobs.get(job_id):
            await _settle(job, wait_seconds)
            if job.status != models.JobState.COMPLETED:
                return models.JobStatus(
                    job_id=job_id,
                    status=job.status,
                    error=job.error,
                )
        image_path = net.artifact_path(state.image_dir, job_id, "png")
        if image_path is None or not image_path.is_file():
            return models.JobStatus(
                job_id=job_id,
                status=models.JobState.FAILED,
                error=f"Job {job_id} not found.",
            )
        return mcpserver.Image(path=image_path)


def _register_routes(server: models.AppServer) -> None:
    @server.custom_route("/images/{filename}", methods=["GET"])
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
        image_path = net.artifact_path(server.state.image_dir, job_id, "png")
        if image_path is not None and image_path.is_file():
            return responses.FileResponse(image_path, media_type="image/png")
        return responses.Response(
            content="Image not found.",
            status_code=404,
            media_type="text/plain",
        )


def register(server: models.AppServer) -> None:
    """Register all image tools and HTTP routes on server."""
    _register_jobs(server)
    _register_retrieval(server)
    _register_routes(server)
