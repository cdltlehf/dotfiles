# SPDX-License-Identifier: MIT
"""Background job runners and backend client integrations."""

import base64

import httpx
import pydantic

from mcp_server import config
from mcp_server import models


async def post_generation(
    payload: models.ImageGenerationPayload,
    client: httpx.AsyncClient | None = None,
) -> bytes:
    """Send image generation request to image backend.

    Args:
        payload: Image generation request payload.
        client: Optional shared HTTP client for the request.

    Returns:
        Decoded image bytes.
    """
    if client is None:
        async with httpx.AsyncClient() as local_client:
            return await post_generation(payload, client=local_client)

    response = await client.post(
        config.IMAGE_GENERATION_ENDPOINT,
        json=payload.model_dump(),
        timeout=config.IMAGE_TIMEOUT_SECONDS,
    )
    response.raise_for_status()
    parsed = models.ImageServiceResponse.model_validate(response.json())
    return base64.b64decode(parsed.data[0].b64_json)


async def run_generation(
    job_id: str,
    payload: models.ImageGenerationPayload,
    jobs: dict[str, models.JobRecord],
    client: httpx.AsyncClient | None = None,
) -> None:
    """Execute image generation in the background.

    Args:
        job_id: Identifier of the job record to update.
        payload: Image generation parameters.
        jobs: In-memory registry of image jobs.
        client: Optional shared HTTP client for the request.
    """
    jobs[job_id]["status"] = "processing"
    try:
        image_bytes = await post_generation(payload, client=client)
    except (
        httpx.HTTPError,
        IndexError,
        KeyError,
        pydantic.ValidationError,
        TypeError,
        ValueError,
    ) as err:
        jobs[job_id]["status"] = "failed"
        jobs[job_id]["error"] = str(err)
    else:
        jobs[job_id]["status"] = "completed"
        jobs[job_id]["data"] = image_bytes
    finally:
        event = jobs[job_id].get("event")
        if event is not None:
            event.set()


async def post_editing(
    payload: models.ImageEditPayload,
    image_bytes: bytes,
    client: httpx.AsyncClient | None = None,
) -> bytes:
    """Send image editing request to image backend.

    Args:
        payload: Image editing request payload.
        image_bytes: Raw bytes of the source image to edit.
        client: Optional shared HTTP client for the request.

    Returns:
        Decoded modified image bytes.
    """
    if client is None:
        async with httpx.AsyncClient() as local_client:
            return await post_editing(payload, image_bytes, client=local_client)

    form_data = {k: str(v) for k, v in payload.model_dump().items()}
    files = {"image": ("source.png", image_bytes, "image/png")}
    response = await client.post(
        config.IMAGE_EDIT_ENDPOINT,
        files=files,
        data=form_data,
        timeout=config.IMAGE_TIMEOUT_SECONDS,
    )
    response.raise_for_status()
    parsed = models.ImageServiceResponse.model_validate(response.json())
    return base64.b64decode(parsed.data[0].b64_json)


async def run_editing(
    job_id: str,
    payload: models.ImageEditPayload,
    image_bytes: bytes,
    jobs: dict[str, models.JobRecord],
    client: httpx.AsyncClient | None = None,
) -> None:
    """Execute image editing in the background.

    Args:
        job_id: Identifier of the job record to update.
        payload: Image edit parameters.
        image_bytes: Raw bytes of the source image to edit.
        jobs: In-memory registry of image jobs.
        client: Optional shared HTTP client for the request.
    """
    jobs[job_id]["status"] = "processing"
    try:
        edited_bytes = await post_editing(payload, image_bytes, client=client)
    except (
        httpx.HTTPError,
        IndexError,
        KeyError,
        pydantic.ValidationError,
        TypeError,
        ValueError,
    ) as err:
        jobs[job_id]["status"] = "failed"
        jobs[job_id]["error"] = str(err)
    else:
        jobs[job_id]["status"] = "completed"
        jobs[job_id]["data"] = edited_bytes
    finally:
        event = jobs[job_id].get("event")
        if event is not None:
            event.set()


async def transcribe_audio_data(
    audio_bytes: bytes,
    payload: models.AudioTranscriptionPayload,
    client: httpx.AsyncClient | None = None,
) -> str:
    """Send audio bytes to transcription backend.

    Args:
        audio_bytes: Raw audio binary content.
        payload: Transcription request configuration.
        client: Optional shared HTTP client for the request.

    Returns:
        Transcribed speech text.
    """
    if client is None:
        async with httpx.AsyncClient() as local_client:
            return await transcribe_audio_data(
                audio_bytes, payload, client=local_client
            )

    files = {"file": ("audio.wav", audio_bytes, "audio/wav")}
    form_data = {k: str(v) for k, v in payload.model_dump().items()}
    response = await client.post(
        config.AUDIO_TRANSCRIPTION_ENDPOINT,
        files=files,
        data=form_data,
        timeout=config.AUDIO_TIMEOUT_SECONDS,
    )
    response.raise_for_status()
    if payload.response_format == "json":
        json_response = response.json()
        if isinstance(json_response, dict):
            return str(json_response.get("text", response.text))
        return str(json_response)
    return response.text
