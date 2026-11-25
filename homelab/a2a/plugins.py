# SPDX-License-Identifier: MIT
# ruff: file-ignore[implicit-namespace-package]
"""ADK plugins for the A2A agent server."""

import collections
import json
import os
from typing import Any, Final

from google.adk.agents import invocation_context
from google.adk.events import event as adk_event
from google.adk.plugins import base_plugin
from google.adk.plugins import context_filter_plugin
from google.adk.tools import base_tool
from google.adk.tools import tool_context as adk_tool_context
from google.genai import types

_DEFAULT_TOKEN_LIMIT: Final[int] = 16384
_MEDIA_TOKEN_ESTIMATE: Final[int] = 1024
_CHARS_PER_TOKEN: Final[int] = 3


def _estimate_content_tokens(content: types.Content) -> int:
    """Estimate token count for a single Content message."""
    total_chars = 0
    media_tokens = 0
    for part in content.parts or ():
        if part.text:
            total_chars += len(part.text)
        if part.function_call:
            total_chars += len(
                json.dumps(part.function_call.model_dump(exclude_none=True))
            )
        if part.function_response:
            total_chars += len(
                json.dumps(part.function_response.model_dump(exclude_none=True))
            )
        if part.inline_data or part.file_data:
            media_tokens += _MEDIA_TOKEN_ESTIMATE
    return (total_chars // _CHARS_PER_TOKEN) + media_tokens + 4


def _is_user_prompt(content: types.Content) -> bool:
    return content.role == "user" and not any(
        part.function_response is not None for part in (content.parts or ())
    )


def trim_context_by_tokens(
    contents: list[types.Content],
) -> list[types.Content]:
    """Keep the most recent conversation turns within the token budget."""
    limit = int(
        os.environ.get("ADK_HISTORY_TOKEN_LIMIT", str(_DEFAULT_TOKEN_LIMIT))
    )
    if not contents or limit <= 0:
        return contents

    kept: list[types.Content] = []
    used_tokens = 0
    for item in reversed(contents):
        cost = _estimate_content_tokens(item)
        if kept and used_tokens + cost > limit:
            break
        kept.append(item)
        used_tokens += cost

    kept.reverse()
    while len(kept) > 1 and not _is_user_prompt(kept[0]):
        kept.pop(0)
    return kept


context_filter = context_filter_plugin.ContextFilterPlugin(
    custom_filter=trim_context_by_tokens,
)

_MEDIA_TOOLS: Final[dict[str, tuple[str, str]]] = {
    "generate_speech": ("audio_url", "audio/wav"),
    "get_image_url": ("image_url", "image/png"),
}


def _extract_field(payload: object, key: str) -> str | None:
    if hasattr(payload, "model_dump"):
        payload = payload.model_dump(mode="python")
    if isinstance(payload, dict):
        value = payload.get(key)
        if isinstance(value, str) and value:
            return value
        if "structuredContent" in payload:
            found = _extract_field(payload["structuredContent"], key)
            if found:
                return found
        for item in payload.get("content", ()):
            if isinstance(item, dict) and isinstance(item.get("text"), str):
                try:
                    parsed = json.loads(item["text"])
                except ValueError:
                    continue
                found = _extract_field(parsed, key)
                if found:
                    return found
    return None


class MediaPartPlugin(base_plugin.BasePlugin):
    """Attach MCP media URLs as A2A FilePart URI entries on final responses."""

    def __init__(self, name: str = "media_parts") -> None:
        """Initialize the media part plugin state."""
        super().__init__(name=name)
        self._pending: dict[str, list[tuple[str, str]]] = (
            collections.defaultdict(list)
        )

    async def after_tool_callback(
        self,
        *,
        tool: base_tool.BaseTool,
        tool_args: dict[str, Any],
        tool_context: adk_tool_context.ToolContext,
        result: dict[str, Any],
    ) -> dict[str, Any] | None:
        """Record generated media URLs from MCP tool results."""
        del tool_args
        spec = _MEDIA_TOOLS.get(tool.name)
        if spec is None:
            return None
        field_name, mime_type = spec
        url = _extract_field(result, field_name)
        if url:
            entries = self._pending[tool_context.invocation_id]
            entry = (url, mime_type)
            if entry not in entries:
                entries.append(entry)
        return None

    async def on_event_callback(
        self,
        *,
        invocation_context: invocation_context.InvocationContext,
        event: adk_event.Event,
    ) -> adk_event.Event | None:
        """Append pending media URIs to the agent's final response event."""
        if (
            event.partial
            or not event.is_final_response()
            or event.content is None
        ):
            return None
        entries = self._pending.pop(invocation_context.invocation_id, None)
        if not entries:
            return None
        parts = list(event.content.parts or ())
        existing_uris = {
            part.file_data.file_uri
            for part in parts
            if part.file_data and part.file_data.file_uri
        }
        for url, mime_type in entries:
            if url not in existing_uris:
                parts.append(
                    types.Part.from_uri(file_uri=url, mime_type=mime_type)
                )
        event.content.parts = parts
        return event

    async def after_run_callback(
        self,
        *,
        invocation_context: invocation_context.InvocationContext,
    ) -> None:
        """Clear any pending media entries if an invocation exits early."""
        self._pending.pop(invocation_context.invocation_id, None)


media_parts = MediaPartPlugin()
