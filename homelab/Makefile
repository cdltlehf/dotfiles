SHELL := /bin/bash
.DEFAULT_GOAL := help

XDG_DATA_HOME ?= $(HOME)/.local/share

##@ General

.PHONY: help
help: ## Display help
	@awk ' \
		BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
		/^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } \
	' $(MAKEFILE_LIST)

.PHONY: upgrade
upgrade: ## Upgrade locked dependencies of every container
	@for d in $(dir $(wildcard containers/*/Makefile)); do $(MAKE) -C "$$d" upgrade || exit; done

##@ Compose

COMPOSE ?= $(shell command -v podman >/dev/null 2>&1 && echo "podman compose" || echo "docker compose")

ifeq ($(strip $(SELFHOST_RESPONSES_DIR)),)
  SELFHOST_RESPONSES_DIR := $(XDG_DATA_HOME)/models/responses
endif

responses_files  := $(wildcard $(SELFHOST_RESPONSES_DIR)/*)
embeddings_files := $(wildcard $(XDG_DATA_HOME)/models/embeddings/*)
audio_file := $(notdir $(firstword $(wildcard $(XDG_DATA_HOME)/models/audio/*)))
image_file := $(notdir $(firstword $(wildcard $(XDG_DATA_HOME)/models/images/*)))

detected_profiles := pi
compose_env :=

ifneq ($(strip $(responses_files)),)
  detected_profiles := $(detected_profiles),responses,mcp,a2a
  ifeq ($(strip $(SELFHOST_RESPONSES_MODEL)),)
    SELFHOST_RESPONSES_MODEL := $(patsubst %.gguf,%,$(notdir $(firstword $(responses_files))))
  endif
  compose_env += SELFHOST_RESPONSES_DIR="$(SELFHOST_RESPONSES_DIR)" SELFHOST_RESPONSES_MODEL="$(SELFHOST_RESPONSES_MODEL)"
endif

ifneq ($(strip $(embeddings_files)),)
  detected_profiles := $(detected_profiles),embeddings
endif

ifneq ($(audio_file),)
  detected_profiles := $(detected_profiles),audio
  ifeq ($(strip $(SELFHOST_AUDIO_MODEL)),)
    SELFHOST_AUDIO_MODEL := $(audio_file)
  endif
  compose_env += SELFHOST_AUDIO_MODEL="$(SELFHOST_AUDIO_MODEL)"
endif

ifneq ($(image_file),)
  detected_profiles := $(detected_profiles),images
  ifeq ($(strip $(SELFHOST_IMAGE_MODEL)),)
    SELFHOST_IMAGE_MODEL := $(image_file)
  endif
  compose_env += SELFHOST_IMAGE_MODEL="$(SELFHOST_IMAGE_MODEL)"
endif

# Compose reads COMPOSE_PROFILES itself; set it in the shell or on the command
# line to replace the profiles detected from the model files.
ifeq ($(strip $(COMPOSE_PROFILES)),)
  COMPOSE_PROFILES := $(detected_profiles)
endif
export COMPOSE_PROFILES

.PHONY: compose-up up
compose-up: ## Start services (alias: up) (COMPOSE_PROFILES=...)
	@$(compose_env) $(COMPOSE) up -d
up: compose-up

.PHONY: compose-down down
compose-down: ## Stop services (alias: down)
	@$(compose_env) $(COMPOSE) down
down: compose-down

.PHONY: compose-build
compose-build: ## Build services (SERVICE=...)
	@$(compose_env) $(COMPOSE) --profile "*" build $(SERVICE)

.PHONY: compose-rebuild
compose-rebuild: ## Rebuild services ignoring layer cache (SERVICE=...)
	@$(compose_env) $(COMPOSE) --profile "*" build --pull --no-cache $(SERVICE)

.PHONY: compose-ps
compose-ps: ## Status of services
	@$(compose_env) $(COMPOSE) ps

.PHONY: compose-logs logs
compose-logs: ## Follow service logs (alias: logs)
	@$(compose_env) $(COMPOSE) logs -f
logs: compose-logs

MODAL ?= text

.PHONY: models-download
models-download: ## Download model from Hugging Face (REPO=... [MODAL=text|audio|image|embedding] [FILE=...])
	@./scripts/models-download "$(REPO)" "$(MODAL)" "$(FILE)" "$(PATTERN)"
