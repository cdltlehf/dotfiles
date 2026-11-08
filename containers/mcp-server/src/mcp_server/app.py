# SPDX-License-Identifier: MIT
"""Main MCP server application exposing AI processing tools."""

import asyncio
import collections.abc
import contextlib
import uuid

import httpx
from mcp.server import mcpserver
from starlette import requests
from starlette import responses

from mcp_server import config
from mcp_server import models
from mcp_server import services
from mcp_server import storage


class AppServer(mcpserver.MCPServer[models.AppState]):
    """MCPServer extension holding application state.

    Attributes:
        state: Current application state instance or None.
    """

    state: models.AppState | None = None


@contextlib.asynccontextmanager
async def lifespan(
    app: mcpserver.MCPServer[models.AppState],
) -> collections.abc.AsyncGenerator[models.AppState, None]:
    """Manage application state lifecycle, HTTP client pool, and task cleanup.

    Args:
        app: Application server instance.

    Yields:
        Initialized AppState with job storage, tasks, and HTTP client.
    """
    client = httpx.AsyncClient()
    state = models.AppState(http_client=client)
    if isinstance(app, AppServer):
        app.state = state
    try:
        yield state
    finally:
        tasks = tuple(state.running_tasks)
        for task in tasks:
            task.cancel()
        if tasks:
            await asyncio.gather(*tasks, return_exceptions=True)
        await client.aclose()
        if isinstance(app, AppServer):
            app.state = None


mcp: AppServer = AppServer("local-ai-tools", lifespan=lifespan)


def _get_app_state(ctx: mcpserver.Context | None = None) -> models.AppState:
    """Retrieve AppState from request context or server instance.

    Args:
        ctx: Optional request context carrying lifespan context.

    Returns:
        The active AppState instance.

    Raises:
        RuntimeError: If the application state is not initialized.
    """
    if ctx and ctx.request_context:
        lifespan_context = ctx.request_context.lifespan_context
        if isinstance(lifespan_context, models.AppState):
            return lifespan_context
    if mcp.state is not None:
        return mcp.state
    raise RuntimeError("Application state is not available.")


def _resolve_base_url(ctx: mcpserver.Context | None) -> str:
    """Resolve base URL from incoming request headers or config fallback.

    Args:
        ctx: Optional request context carrying transport headers.

    Returns:
        Resolved base URL string without trailing slash.
    """
    if ctx and ctx.headers:
        proto = ctx.headers.get("x-forwarded-proto", "http")
        host = ctx.headers.get("x-forwarded-host") or ctx.headers.get("host")
        if host:
            return f"{proto}://{host}"
    return config.MCP_BASE_URL


def _build_prompt(prompt: str) -> str:
    """Combine user prompt with default positive tags if configured.

    Args:
        prompt: User-supplied image prompt.

    Returns:
        Combined prompt string.
    """
    clean_prompt = prompt.strip()
    if not config.DEFAULT_POSITIVE_PROMPT:
        return clean_prompt
    suffix = ", ".join(config.DEFAULT_POSITIVE_PROMPT)
    if not clean_prompt:
        return suffix
    return f"{clean_prompt}, {suffix}"


@mcp.tool()
async def start_image_generation(
    prompt: str,
    *,
    negative_prompt: str | None = None,
    size: models.ImageResolution = "1024x1024",
    ctx: mcpserver.Context | None = None,
) -> models.JobStatus:
    """Start asynchronous image generation.

    Args:
        prompt: Descriptive visual prompt for the desired image.
        negative_prompt: Visual elements or styles to avoid in the output.
        size: Output image dimensions.
        ctx: Request context carrying application state.

    Returns:
        JobStatus containing assigned job_id and pending status.
    """
    state = _get_app_state(ctx)
    job_id = uuid.uuid4().hex
    event = asyncio.Event()
    state.jobs[job_id] = {"status": "pending", "event": event}
    effective_negative_prompt = (
        negative_prompt
        if negative_prompt is not None
        else ", ".join(config.DEFAULT_NEGATIVE_PROMPT)
    )
    payload = models.ImageGenerationPayload(
        prompt=_build_prompt(prompt),
        negative_prompt=effective_negative_prompt,
        size=size,
    )
    task = asyncio.create_task(
        services.run_generation(
            job_id, payload, state.jobs, client=state.http_client
        )
    )
    state.running_tasks.add(task)
    task.add_done_callback(state.running_tasks.discard)
    await asyncio.sleep(0)
    return models.JobStatus(job_id=job_id, status="pending")


@mcp.tool()
async def start_image_edit(
    image: str,
    prompt: str,
    *,
    negative_prompt: str | None = None,
    strength: float = 0.75,
    size: models.ImageResolution = "1024x1024",
    ctx: mcpserver.Context | None = None,
) -> models.JobStatus:
    """Start asynchronous image-to-image editing.

    Args:
        image: Source image reference (job_id, URL, data URI, or base64).
        prompt: Visual description of the desired target scene.
        negative_prompt: Visual elements or original subjects to avoid.
        strength: Denoising strength (0.0 keeps source, 1.0 redraws completely).
        size: Output image dimensions.
        ctx: Request context carrying application state.

    Returns:
        JobStatus containing assigned job_id and pending status.
    """
    state = _get_app_state(ctx)
    image_bytes = await storage.resolve_image_bytes(
        image, state.jobs, client=state.http_client
    )
    job_id = uuid.uuid4().hex
    event = asyncio.Event()
    state.jobs[job_id] = {"status": "pending", "event": event}
    effective_negative_prompt = (
        negative_prompt
        if negative_prompt is not None
        else ", ".join(config.DEFAULT_NEGATIVE_PROMPT)
    )
    payload = models.ImageEditPayload(
        prompt=_build_prompt(prompt),
        negative_prompt=effective_negative_prompt,
        strength=strength,
        size=size,
    )
    task = asyncio.create_task(
        services.run_editing(
            job_id, payload, image_bytes, state.jobs, client=state.http_client
        )
    )
    state.running_tasks.add(task)
    task.add_done_callback(state.running_tasks.discard)
    return models.JobStatus(job_id=job_id, status="pending")


@mcp.custom_route("/images/{filename}", methods=["GET"])  # type: ignore[untyped-decorator]
async def get_image_file(request: requests.Request) -> responses.Response:
    """Serve a generated image file by job ID.

    Args:
        request: Incoming HTTP request containing filename in path params.

    Returns:
        HTTP response containing the PNG image binary or 404 error.
    """
    state = _get_app_state()
    filename = request.path_params.get("filename", "")
    job_id = filename.removesuffix(".png")
    job = state.jobs.get(job_id)
    if not job or "data" not in job:
        return responses.Response(content="Image not found", status_code=404)
    await asyncio.sleep(0)
    return responses.Response(content=job["data"], media_type="image/png")


@mcp.tool()
async def get_image_result(
    job_id: str,
    wait_seconds: int = 0,
    ctx: mcpserver.Context | None = None,
) -> list[mcpserver.Image | str] | models.JobStatus:
    """Fetch status or completed image for an image generation or edit job.

    Args:
        job_id: The unique identifier of the job.
        wait_seconds: Optional seconds to wait (up to 30) for completion.
        ctx: Request context carrying transport headers.

    Returns:
        The generated Image and download URL if completed, or JobStatus if
        pending, processing, or failed.
    """
    state = _get_app_state(ctx)
    job = state.jobs.get(job_id)
    if not job:
        return models.JobStatus(
            job_id=job_id, status="failed", error="Job not found."
        )

    clamped_wait = max(0, min(wait_seconds, config.MAX_WAIT_SECONDS))
    if clamped_wait > 0 and job["status"] in {"pending", "processing"}:
        event = job.get("event")
        if event is not None:
            with contextlib.suppress(TimeoutError):
                await asyncio.wait_for(event.wait(), timeout=clamped_wait)

    if job["status"] == "completed" and "data" in job:
        base_url = _resolve_base_url(ctx)
        url = f"{base_url}/images/{job_id}.png"
        return [
            mcpserver.Image(data=job["data"], format="png"),
            f"Image URL: {url}",
        ]
    return models.JobStatus(
        job_id=job_id,
        status=job["status"],
        error=job.get("error"),
    )


@mcp.tool()
async def transcribe_audio(
    audio: str,
    response_format: models.AudioResponseFormat = "json",
    ctx: mcpserver.Context | None = None,
) -> str:
    """Transcribe speech audio into text.

    Args:
        audio: Audio URL, data URI, or base64 of the audio file.
        response_format: Output format ('json', 'text', 'srt', 'vtt').
        ctx: Request context carrying application state.

    Returns:
        Transcribed speech text.
    """
    state = _get_app_state(ctx)
    payload = models.AudioTranscriptionPayload(response_format=response_format)
    audio_bytes = await storage.fetch_binary_data(
        audio, client=state.http_client
    )
    return await services.transcribe_audio_data(
        audio_bytes, payload, client=state.http_client
    )


def main(argv: collections.abc.Sequence[str] | None = None) -> int:
    """Run the MCP server.

    Args:
        argv: Command-line arguments.

    Returns:
        Process exit code 0 on success.
    """
    del argv
    mcp.run(transport="streamable-http", host=config.HOST, port=config.PORT)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
