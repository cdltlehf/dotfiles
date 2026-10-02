##@ Compose

COMPOSE ?= $(shell command -v podman >/dev/null 2>&1 && echo "podman compose" || echo "docker compose")

.PHONY: compose-up
compose-up: ## Start services
	@$(COMPOSE) up -d

.PHONY: compose-down
compose-down: ## Stop services
	@$(COMPOSE) down
