# SPDX-License-Identifier: MIT
"""Shared data models and server state for mcp-server."""

import asyncio
import dataclasses
import enum
import pathlib
from typing import Annotated, Literal

import httpx
from mcp.server import mcpserver
import openai
import pydantic


class JobState(enum.StrEnum):
    """Represents the execution state of an asynchronous image job."""

    PENDING = "pending"
    PROCESSING = "processing"
    COMPLETED = "completed"
    FAILED = "failed"


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


@dataclasses.dataclass
class ImageJob:
    """Represents an asynchronous image generation or editing job."""

    job_id: str
    status: JobState = JobState.PENDING
    event: asyncio.Event = dataclasses.field(default_factory=asyncio.Event)
    error: str | None = None


class JobStatus(pydantic.BaseModel):
    """Represents the serialized status of an asynchronous image job."""

    job_id: str
    status: JobState
    image_url: str | None = None
    error: str | None = None


class SpeechResult(pydantic.BaseModel):
    """Represents a synthesized speech audio file and its URL."""

    audio_id: str
    audio_url: str


class CurrentTimeResult(pydantic.BaseModel):
    """Represents the current local date, time, and weekday."""

    timezone: str
    iso_datetime: str
    weekday: str


class SearchResultItem(pydantic.BaseModel):
    """Represents a single web search result."""

    title: str
    url: str
    snippet: str
    engine: str | None = None


@dataclasses.dataclass
class AppState:
    """Holds app-scoped clients, configuration, and active jobs."""

    openai_client: openai.AsyncClient
    image_client: openai.AsyncClient
    http_client: httpx.AsyncClient
    allowed_hosts: frozenset[str]
    public_url: str
    searxng_base_url: str
    image_dir: pathlib.Path
    audio_dir: pathlib.Path
    speech_model: str
    transcribe_model: str
    default_positive_prompt: str
    default_negative_prompt: str
    jobs: dict[str, ImageJob] = dataclasses.field(
        default_factory=dict[str, ImageJob]
    )
    running_tasks: set[asyncio.Task[None]] = dataclasses.field(
        default_factory=set[asyncio.Task[None]]
    )


class AppServer(mcpserver.MCPServer[AppState]):
    """MCP server that retains a reference to active app state."""

    state: AppState
