# SPDX-License-Identifier: MIT
# ruff: file-ignore[implicit-namespace-package]
"""ADK plugins for the A2A agent server."""

import json
import os
from typing import Final

from google.adk.plugins import context_filter_plugin
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
    while len(kept) > 1 and kept[0].role != "user":
        kept.pop(0)
    return kept


context_filter = context_filter_plugin.ContextFilterPlugin(
    custom_filter=trim_context_by_tokens,
)
