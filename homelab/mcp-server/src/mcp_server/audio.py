# SPDX-License-Identifier: MIT
"""Audio transcription and speech synthesis tools for mcp-server."""

import asyncio
import pathlib
from typing import Annotated, Final
import urllib.parse
import uuid

from mcp.server import mcpserver
import pydantic
from starlette import requests
from starlette import responses

from mcp_server import models
from mcp_server import net

_MAX_AUDIO_BYTES: Final[int] = 20 * 1024 * 1024

AudioUrl = Annotated[
    str,
    pydantic.Field(description="HTTP or HTTPS URL of the source audio file."),
]
AudioLanguage = Annotated[
    str,
    pydantic.Field(
        description="Optional ISO-639-1 language code (e.g., 'ko', 'en')."
    ),
]
SpeechText = Annotated[
    str,
    pydantic.Field(description="Text to synthesize into speech audio."),
]


def _register_transcribe(server: models.AppServer) -> None:
    @server.tool()
    async def transcribe_audio(
        audio_url: AudioUrl,
        response_format: models.AudioResponseFormat = "json",
        language: AudioLanguage | None = None,
    ) -> str:
        """Transcribe an audio file from a URL into text or subtitles."""
        state = server.state
        audio_bytes, final_url, content_type, _ = await net.fetch_limited(
            state.http_client, audio_url, max_bytes=_MAX_AUDIO_BYTES
        )
        filename = (
            pathlib.PurePosixPath(urllib.parse.urlsplit(final_url).path).name
            or "audio.wav"
        )
        optional_args: dict[str, str] = {}
        if language is not None:
            optional_args["language"] = language
        transcription = await state.openai_client.audio.transcriptions.create(
            # The backend serves the one model it loaded and ignores this name.
            model="whisper-1",
            file=(
                filename,
                audio_bytes,
                content_type or "application/octet-stream",
            ),
            response_format=response_format,
            **optional_args,
        )
        return (
            transcription
            if isinstance(transcription, str)
            else transcription.text
        )


def _register_speech(server: models.AppServer) -> None:
    @server.tool()
    async def generate_speech(
        text: SpeechText,
        ctx: mcpserver.Context[models.AppState] | None = None,
    ) -> models.SpeechResult:
        """Synthesize speech from text and return its WAV audio URL."""
        state = server.state
        audio_id = uuid.uuid4().hex
        output_path = net.artifact_path(state.audio_dir, audio_id, "wav")
        if output_path is None:
            raise ValueError(f"Invalid audio ID: {audio_id}")

        response = await state.openai_client.audio.speech.create(
            model=state.speech_model,
            voice="alloy",
            input=text,
            response_format="wav",
        )
        await asyncio.to_thread(output_path.write_bytes, response.content)
        headers = ctx.headers if ctx else None
        base_url = net.resolve_base_url(
            headers, state.allowed_hosts, state.public_url
        )
        return models.SpeechResult(
            audio_id=audio_id,
            audio_url=f"{base_url}/audio/{audio_id}.wav",
        )

    @server.custom_route("/audio/{filename}", methods=["GET"])
    async def serve_audio(request: requests.Request) -> responses.Response:
        """Serve a generated speech clip as a WAV response."""
        await asyncio.sleep(0)
        filename = str(request.path_params.get("filename", ""))
        if not filename.endswith(".wav"):
            return responses.Response(
                content="Audio not found.",
                status_code=404,
                media_type="text/plain",
            )
        audio_id = filename.removesuffix(".wav")
        audio_path = net.artifact_path(server.state.audio_dir, audio_id, "wav")
        if audio_path is not None and audio_path.is_file():
            return responses.FileResponse(audio_path, media_type="audio/wav")
        return responses.Response(
            content="Audio not found.",
            status_code=404,
            media_type="text/plain",
        )


def register(
    server: models.AppServer,
    *,
    enable_transcribe: bool,
    enable_speech: bool,
) -> None:
    """Register enabled audio tools and routes on server."""
    if enable_transcribe:
        _register_transcribe(server)
    if enable_speech:
        _register_speech(server)
