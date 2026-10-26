##@ Compose

COMPOSE ?= $(shell command -v podman >/dev/null 2>&1 && echo "podman compose" || echo "docker compose")

COMPOSE_RESPONSES_FILES  := $(wildcard $(XDG_DATA_HOME)/models/responses/*)
COMPOSE_EMBEDDINGS_FILES := $(wildcard $(XDG_DATA_HOME)/models/embeddings/*)
COMPOSE_AUDIO_FILE       := $(notdir $(firstword $(wildcard $(XDG_DATA_HOME)/models/audio/*)))
COMPOSE_IMAGE_FILE       := $(notdir $(firstword $(wildcard $(XDG_DATA_HOME)/models/images/*)))

COMPOSE_PROFILES :=
COMPOSE_ENV :=

ifneq ($(strip $(COMPOSE_RESPONSES_FILES)),)
  COMPOSE_PROFILES += --profile responses
endif

ifneq ($(strip $(COMPOSE_EMBEDDINGS_FILES)),)
  COMPOSE_PROFILES += --profile embeddings
endif

ifneq ($(COMPOSE_AUDIO_FILE),)
  COMPOSE_PROFILES += --profile audio
  COMPOSE_ENV += AUDIO_MODEL="$(COMPOSE_AUDIO_FILE)"
endif

ifneq ($(COMPOSE_IMAGE_FILE),)
  COMPOSE_PROFILES += --profile images
  COMPOSE_ENV += IMAGE_MODEL="$(COMPOSE_IMAGE_FILE)"
endif

.PHONY: compose-up up
compose-up: ## Start services (alias: up)
	@$(COMPOSE_ENV) $(COMPOSE) $(COMPOSE_PROFILES) up -d
up: compose-up

.PHONY: compose-down down
compose-down: ## Stop services (alias: down)
	@$(COMPOSE) $(COMPOSE_PROFILES) down
down: compose-down

.PHONY: compose-build
compose-build: ## Build services (SERVICE=...)
	@$(COMPOSE) --profile "*" build $(SERVICE)

.PHONY: compose-rebuild
compose-rebuild: ## Rebuild services ignoring layer cache (SERVICE=...)
	@$(COMPOSE) --profile "*" build --no-cache $(SERVICE)

.PHONY: compose-ps
compose-ps: ## Status of services
	@$(COMPOSE) $(COMPOSE_PROFILES) ps

.PHONY: compose-logs logs
compose-logs: ## Follow service logs (alias: logs)
	@$(COMPOSE) $(COMPOSE_PROFILES) logs -f
logs: compose-logs

.PHONY: models-download
models-download: ## Download a model from Hugging Face into ~/.local/share/models (REPO=... PATTERN=... DEST=...)
	@./scripts/models-download "$(REPO)" "$(PATTERN)" "$(DEST)"
