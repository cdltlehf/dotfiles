# SPDX-License-Identifier: MIT
"""ASGI reverse proxy that defaults reasoning_effort to none."""

import argparse
from collections.abc import Awaitable, Callable, MutableMapping, Sequence
import contextlib
import json
import logging
import os
from typing import Any

import httpx
import uvicorn

type Scope = MutableMapping[str, Any]
type Message = MutableMapping[str, Any]
type Receive = Callable[[], Awaitable[Message]]
type Send = Callable[[Message], Awaitable[None]]
type ASGIApp = Callable[[Scope, Receive, Send], Awaitable[None]]


def _inject_no_reasoning(body: bytes) -> bytes:
    with contextlib.suppress(UnicodeDecodeError, json.JSONDecodeError):
        payload = json.loads(body)
        if isinstance(payload, dict) and "reasoning_effort" not in payload:
            payload["reasoning_effort"] = "none"
            return json.dumps(payload).encode()
    return body


async def _read_body(receive: Receive) -> bytes:
    chunks: list[bytes] = []
    while True:
        message = await receive()
        chunks.append(message.get("body", b""))
        if not message.get("more_body", False):
            return b"".join(chunks)


def create_app(upstream_base_url: str) -> ASGIApp:
    """Build an ASGI proxy app targeting upstream_base_url."""
    client = httpx.AsyncClient(
        base_url=upstream_base_url.rstrip("/"),
        timeout=1800.0,
    )

    async def app(scope: Scope, receive: Receive, send: Send) -> None:
        if scope["type"] == "lifespan":
            while True:
                message = await receive()
                if message["type"] == "lifespan.startup":
                    await send({"type": "lifespan.startup.complete"})
                elif message["type"] == "lifespan.shutdown":
                    await client.aclose()
                    await send({"type": "lifespan.shutdown.complete"})
                    return

        if scope["type"] != "http":
            return

        body = await _read_body(receive)
        path: str = scope["path"]
        if scope["method"] == "POST" and path.endswith("/chat/completions"):
            body = _inject_no_reasoning(body)

        req_headers = [
            (k, v)
            for k, v in scope["headers"]
            if k.lower() not in {b"host", b"content-length"}
        ]
        upstream_req = client.build_request(
            method=scope["method"],
            url=path,
            params=scope.get("query_string", b"").decode("latin-1") or None,
            headers=req_headers,
            content=body,
        )
        upstream_res = await client.send(upstream_req, stream=True)
        res_headers = [
            (k, v)
            for k, v in upstream_res.headers.raw
            if k.lower() not in {b"content-length", b"transfer-encoding"}
        ]
        await send({
            "type": "http.response.start",
            "status": upstream_res.status_code,
            "headers": res_headers,
        })
        try:
            async for chunk in upstream_res.aiter_raw():
                await send({
                    "type": "http.response.body",
                    "body": chunk,
                    "more_body": True,
                })
            await send({
                "type": "http.response.body",
                "body": b"",
                "more_body": False,
            })
        finally:
            await upstream_res.aclose()

    return app


def main(argv: Sequence[str] | None = None) -> int:
    """Execute main application logic."""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
    )
    parser = argparse.ArgumentParser(description="llm-proxy")
    parser.add_argument("--host", type=str, default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8000)
    args = parser.parse_args(argv)
    upstream_base_url = os.environ["UPSTREAM_BASE_URL"].strip()
    uvicorn.run(create_app(upstream_base_url), host=args.host, port=args.port)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
