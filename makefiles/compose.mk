##@ Compose

COMPOSE ?= $(shell command -v podman >/dev/null 2>&1 && echo "podman compose" || echo "docker compose")

.PHONY: compose-up up
compose-up: ## Start services (alias: up)
	@$(COMPOSE) up -d
up: compose-up

.PHONY: compose-down down
compose-down: ## Stop services (alias: down)
	@$(COMPOSE) down
down: compose-down

.PHONY: compose-ps
compose-ps: ## Status of services
	@$(COMPOSE) ps

.PHONY: compose-logs logs
compose-logs: ## Follow service logs (alias: logs)
	@$(COMPOSE) logs -f
logs: compose-logs
