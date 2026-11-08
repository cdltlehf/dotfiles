# SPDX-License-Identifier: MIT
"""Data models and type definitions for MCP requests and responses."""

import asyncio
import dataclasses
import typing

import httpx
import pydantic

type ImageResolution = typing.Literal[
    "512x512",
    "768x768",
    "1024x1024",
]
type AudioResponseFormat = typing.Literal[
    "json",
    "text",
    "srt",
    "vtt",
]
type JobStatusType = typing.Literal[
    "pending",
    "processing",
    "completed",
    "failed",
]


class JobRecord(typing.TypedDict):
    """Internal record for tracking asynchronous image generation jobs.

    Attributes:
        status: Current lifecycle state of the processing job.
        data: Decoded raw binary data of the completed image.
        error: Descriptive error message if processing failed.
        event: Synchronization event signaled on completion or failure.
    """

    status: JobStatusType
    data: typing.NotRequired[bytes]
    error: typing.NotRequired[str]
    event: typing.NotRequired[asyncio.Event]


@dataclasses.dataclass(slots=True)
class AppState:
    """Application state holding in-memory job records and active tasks.

    Attributes:
        jobs: Registry mapping job identifiers to JobRecord dictionaries.
        running_tasks: Set of active asynchronous background tasks.
        http_client: Shared HTTP client session for upstream API requests.
    """

    jobs: dict[str, JobRecord] = dataclasses.field(
        default_factory=dict[str, JobRecord]
    )
    running_tasks: set[asyncio.Task[None]] = dataclasses.field(
        default_factory=set[asyncio.Task[None]]
    )
    http_client: httpx.AsyncClient | None = None


class ImageGenerationPayload(pydantic.BaseModel):
    """Request payload for image generation.

    Attributes:
        prompt: Text description of the desired image.
        negative_prompt: Elements to avoid in the generated image.
        size: Output image dimensions.
        response_format: Expected response format from the backend.
    """

    prompt: str = pydantic.Field(
        description="Text description of the desired image."
    )
    negative_prompt: str = pydantic.Field(
        description="Elements to avoid in the generated image."
    )
    size: ImageResolution = pydantic.Field(
        default="1024x1024", description="Output image dimensions."
    )
    response_format: typing.Literal["b64_json"] = "b64_json"


class ImageEditPayload(pydantic.BaseModel):
    """Request payload for image-to-image editing.

    Attributes:
        prompt: Description of the desired modification.
        negative_prompt: Elements to avoid in the generated image.
        strength: Denoising strength between 0.0 and 1.0.
        size: Output image dimensions.
        response_format: Expected response format from the backend.
    """

    prompt: str = pydantic.Field(
        description="Description of the desired modification."
    )
    negative_prompt: str = pydantic.Field(
        description="Elements to avoid in the generated image."
    )
    strength: float = pydantic.Field(
        default=0.75,
        ge=0.0,
        le=1.0,
        description=(
            "Denoising strength (0.0 keeps original, 1.0 completely redraws)."
        ),
    )
    size: ImageResolution = pydantic.Field(
        default="1024x1024", description="Output image dimensions."
    )
    response_format: typing.Literal["b64_json"] = "b64_json"


class JobStatus(pydantic.BaseModel):
    """Status of an asynchronous image processing job.

    Attributes:
        job_id: Unique identifier for the job.
        status: Current job status.
        error: Error message if the job failed.
    """

    job_id: str = pydantic.Field(description="Unique identifier for the job.")
    status: JobStatusType = pydantic.Field(description="Current job status.")
    error: str | None = pydantic.Field(
        default=None, description="Error message if failed."
    )


class AudioTranscriptionPayload(pydantic.BaseModel):
    """Request payload for audio transcription.

    Attributes:
        response_format: Output format ('json', 'text', 'srt', 'vtt').
    """

    response_format: AudioResponseFormat = pydantic.Field(
        default="json",
        description="Output format ('json', 'text', 'srt', 'vtt').",
    )


class GeneratedImageItem(pydantic.BaseModel):
    """Single image item returned by image service backend.

    Attributes:
        b64_json: Base64-encoded image payload string.
    """

    b64_json: str


class ImageServiceResponse(pydantic.BaseModel):
    """Response payload from image service backend endpoints.

    Attributes:
        data: List of generated image payloads.
    """

    data: list[GeneratedImageItem]
