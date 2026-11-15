# SPDX-License-Identifier: MIT
"""Reverse proxy that defaults reasoning_effort to none for chat completions."""

import collections.abc
import contextlib
import json
import os

import httpx
from starlette import applications
from starlette import requests
from starlette import responses
from starlette import routing

UPSTREAM_BASE_URL = os.environ.get(
    "UPSTREAM_BASE_URL", "http://llama-server:9931"
).rstrip("/")

_HOP_BY_HOP = frozenset({
    "connection",
    "content-length",
    "host",
    "keep-alive",
    "proxy-authenticate",
    "proxy-authorization",
    "te",
    "trailers",
    "transfer-encoding",
    "upgrade",
})


@contextlib.asynccontextmanager
async def _lifespan(
    app: applications.Starlette,
) -> collections.abc.AsyncGenerator[None]:
    async with httpx.AsyncClient(
        base_url=UPSTREAM_BASE_URL,
        timeout=1800.0,
    ) as client:
        app.state.client = client
        yield


async def _proxy(request: requests.Request) -> responses.Response:
    body = await request.body()
    if request.method == "POST" and request.url.path.endswith(
        "/chat/completions"
    ):
        with contextlib.suppress(UnicodeDecodeError, json.JSONDecodeError):
            payload = json.loads(body)
            if isinstance(payload, dict) and "reasoning_effort" not in payload:
                payload["reasoning_effort"] = "none"
                body = json.dumps(payload).encode()

    headers = {
        k: v for k, v in request.headers.items() if k.lower() not in _HOP_BY_HOP
    }
    client: httpx.AsyncClient = request.app.state.client
    upstream_req = client.build_request(
        method=request.method,
        url=request.url.path,
        params=request.query_params,
        headers=headers,
        content=body,
    )
    upstream_res = await client.send(upstream_req, stream=True)
    res_headers = {
        k: v
        for k, v in upstream_res.headers.items()
        if k.lower() not in _HOP_BY_HOP
    }

    async def _stream() -> collections.abc.AsyncIterator[bytes]:
        try:
            async for chunk in upstream_res.aiter_raw():
                yield chunk
        finally:
            await upstream_res.aclose()

    return responses.StreamingResponse(
        _stream(),
        status_code=upstream_res.status_code,
        headers=res_headers,
        media_type=upstream_res.headers.get("content-type"),
    )


app = applications.Starlette(
    lifespan=_lifespan,
    routes=[
        routing.Route(
            "/{path:path}",
            _proxy,
            methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
        )
    ],
)
