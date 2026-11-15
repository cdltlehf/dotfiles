##@ Compose

COMPOSE ?= $(shell command -v podman >/dev/null 2>&1 && echo "podman compose" || echo "docker compose")

COMPOSE_RESPONSES_FILES  := $(wildcard $(XDG_DATA_HOME)/models/responses/*)
COMPOSE_EMBEDDINGS_FILES := $(wildcard $(XDG_DATA_HOME)/models/embeddings/*)
COMPOSE_AUDIO_FILE := $(notdir $(firstword $(wildcard $(XDG_DATA_HOME)/models/audio/*)))
COMPOSE_IMAGE_FILE := $(notdir $(firstword $(wildcard $(XDG_DATA_HOME)/models/images/*)))

COMPOSE_PROFILES := --profile pi
COMPOSE_ENV :=

ifneq ($(strip $(COMPOSE_RESPONSES_FILES)),)
  COMPOSE_PROFILES += --profile responses --profile mcp --profile a2a
  ifeq ($(strip $(RESPONSES_MODEL)),)
    RESPONSES_MODEL := $(notdir $(firstword $(COMPOSE_RESPONSES_FILES)))
  endif
  COMPOSE_ENV += RESPONSES_MODEL="$(RESPONSES_MODEL)"
endif

ifneq ($(strip $(COMPOSE_EMBEDDINGS_FILES)),)
  COMPOSE_PROFILES += --profile embeddings
endif

ifneq ($(COMPOSE_AUDIO_FILE),)
  COMPOSE_PROFILES += --profile audio
  ifeq ($(strip $(AUDIO_MODEL)),)
    AUDIO_MODEL := $(COMPOSE_AUDIO_FILE)
  endif
  COMPOSE_ENV += AUDIO_MODEL="$(AUDIO_MODEL)"
endif

ifneq ($(COMPOSE_IMAGE_FILE),)
  COMPOSE_PROFILES += --profile images
  ifeq ($(strip $(IMAGE_MODEL)),)
    IMAGE_MODEL := $(COMPOSE_IMAGE_FILE)
  endif
  COMPOSE_ENV += IMAGE_MODEL="$(IMAGE_MODEL)"
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
	@$(COMPOSE) --profile "*" build --pull --no-cache $(SERVICE)

.PHONY: compose-ps
compose-ps: ## Status of services
	@$(COMPOSE) $(COMPOSE_PROFILES) ps

.PHONY: compose-logs logs
compose-logs: ## Follow service logs (alias: logs)
	@$(COMPOSE) $(COMPOSE_PROFILES) logs -f
logs: compose-logs

MODAL ?= text

.PHONY: models-download
models-download: ## Download model from Hugging Face (REPO=... [MODAL=text|audio|image|embedding] [FILE=...])
	@./scripts/models-download "$(REPO)" "$(MODAL)" "$(FILE)" "$(PATTERN)"
