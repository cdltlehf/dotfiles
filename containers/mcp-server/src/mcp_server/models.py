# SPDX-License-Identifier: MIT
"""Data models and state definitions for the MCP server."""

import asyncio
import dataclasses
import enum
from typing import Annotated, Literal

import httpx
import openai
import pydantic

ImageSize = Annotated[
    Literal[
        "256x256",
        "512x512",
        "768x768",
        "1024x1024",
        "896x1152",
        "1152x896",
        "832x1216",
        "1216x832",
        "768x1344",
        "1344x768",
        "640x1536",
        "1536x640",
        "1024x1536",
        "1536x1024",
        "1536x1536",
        "1024x1792",
        "1792x1024",
        "2048x2048",
    ],
    pydantic.Field(description="Output image dimensions in pixels."),
]
AudioResponseFormat = Annotated[
    Literal["json", "text", "srt", "vtt"],
    pydantic.Field(description="Output format for the transcription response."),
]
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
        description="Identifier of an image job (for status checking or input source)."
    ),
]
WaitSeconds = Annotated[
    float,
    pydantic.Field(
        ge=0.0,
        description="Maximum seconds to wait for job completion.",
    ),
]
AudioUrl = Annotated[
    str,
    pydantic.Field(description="HTTP or HTTPS URL of the source audio file."),
]


class JobState(enum.StrEnum):
    """Lifecycle states for an asynchronous image job."""

    PENDING = "pending"
    PROCESSING = "processing"
    COMPLETED = "completed"
    FAILED = "failed"


@dataclasses.dataclass
class ImageJob:
    """Represents an asynchronous image generation or editing job."""

    status: JobState = JobState.PENDING
    event: asyncio.Event = dataclasses.field(default_factory=asyncio.Event)
    image_bytes: bytes = b""
    error: str | None = None


@dataclasses.dataclass
class AppState:
    """Holds application-scoped clients, configuration, and active jobs."""

    openai_client: openai.AsyncClient
    http_client: httpx.AsyncClient
    mcp_base_url: str
    allowed_hosts: frozenset[str]
    audio_model: str
    default_positive_prompt: str
    default_negative_prompt: str
    jobs: dict[str, ImageJob] = dataclasses.field(
        default_factory=dict[str, ImageJob]
    )
    running_tasks: set[asyncio.Task[None]] = dataclasses.field(
        default_factory=set[asyncio.Task[None]]
    )


class JobStatus(pydantic.BaseModel):
    """Represents the serialized status of an asynchronous image job."""

    job_id: str
    status: JobState
    image_url: str | None = None
    error: str | None = None
