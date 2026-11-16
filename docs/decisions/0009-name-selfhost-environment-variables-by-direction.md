---
status: accepted
date: 2026-11-16
---

# Name self-hosted service variables by direction

## Context and Problem Statement

The compose files under `containers/` read their settings from `~/.profile.local`, which starts from `profile.local.example`.
The variables shared the `COMPOSE_` prefix, which Docker Compose also uses for its own settings, such as `COMPOSE_FILE` and `COMPOSE_PROJECT_NAME`.
`BASE_URL` meant both the address at which a service is reachable and the address of a service it calls.
No variable held the A2A server's public address, so its agent cards advertised `http://localhost:9999` to every client.
How are these variables named, and which settings become variables at all?

## Decision Drivers

* A variable's name tells whether it is a service's own address or an address the service calls.
* Setting up a machine takes as few values as possible.
* The layout of the compose network lives in one place.

## Considered Options

* Keep the `COMPOSE_` prefix and add variables as needed.
* Make every setting of every service a variable.
* Name variables by direction under their own prefix, and make only settings that vary between machines variables.

## Decision Outcome

Chosen option: "Name variables by direction under their own prefix, and make only settings that vary between machines variables," because it is the only option that keeps the names unambiguous while the profile needs a single required value.

* Variables that compose reads use the `SELFHOST_` prefix.
* Three kinds of setting are variables: values that several services share, the public address of a service, and a target that may live outside compose, such as the LLM that a2a calls.
* Calls between services inside compose stay fixed in the compose files, such as `http://mcp-server:8000/mcp`.
* `SELFHOST_<NAME>` holds a shared value, such as `SELFHOST_API_KEY`.
* `SELFHOST_<SERVICE>_PUBLIC_URL` holds the origin at which a service is reachable, without a trailing slash.
* `SELFHOST_<CONSUMER>_<TARGET>_URL` holds an endpoint that the consumer calls as is, and `SELFHOST_<CONSUMER>_<TARGET>_BASE_URL` holds a base to which the consumer appends paths.
* Inside a container the service is implied: `PUBLIC_URL`, `<TARGET>_BASE_URL`, and `<TARGET>_URL`.
  Names that an SDK or tool reads keep their own form, such as `OPENAI_BASE_URL` or pi's `LLAMA_BASE_URL`.
* A service has one public address, not one per feature: its endpoints and files stay behind the same origin, and the service derives its own paths.
  A feature gets its own `PUBLIC_URL` variable only when it is served from another address, and that variable falls back to the service's.
* Fallbacks run from a service-specific value, to the shared value it overrides, to a default in the compose file, and otherwise the service fails to start.
  Compose files use `${VAR:-default}` so that an empty value also falls back, and code inside a container reads one name without a fallback.
* `profile.local.example` leaves only `SELFHOST_API_KEY` uncommented and lists every other variable as a commented override with its default.
  Host tools read their variables directly, so their derived values and defaults are written in the example, such as `AGENT_MCP_URL`.

### Consequences

* Good, because a machine needs only `SELFHOST_API_KEY` until it serves something publicly.
* Good, because the names no longer share a namespace with Docker Compose settings.
* Good, because agent cards advertise the address that `SELFHOST_A2A_PUBLIC_URL` sets.
* Bad, because the default public address of mcp-server for host tools appears both in the example and in its gateway port, so a port change touches both.

### Confirmation

`git grep -E '\$\{COMPOSE_' -- 'containers/*/compose.yaml'` finds nothing.
Every address between services inside a compose file is a literal service name, not a variable.

## More Information

Revisit the prefix if Docker Compose starts reading `SELFHOST_` variables.
Revisit the single public address of a service when one of its features is served from another origin.
