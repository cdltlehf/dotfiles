# Reference: https://github.com/kubernetes-sigs/kubebuilder/blob/master/Makefile

SHELL := /bin/bash

.PHONY: default
default: setup

export XDG_CONFIG_HOME ?= $(HOME)/.config
export XDG_DATA_HOME ?= $(HOME)/.local/share
export XDG_STATE_HOME ?= $(HOME)/.local/state
export XDG_CACHE_HOME ?= $(HOME)/.cache
export BIN_DIR ?= $(HOME)/.local/bin

##@ General

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: references
references: ## List references
	@git --no-pager grep -P -o '[R]eference:\K[ ].*'

##@ Dotfiles

.PHONY: setup
setup: ## Run setup script
	@./scripts/setup

.PHONY: upgrade
upgrade: ## Upgrade tools and dependencies across package managers
	@./scripts/upgrade

.PHONY: clean
clean: TARGET_DIRS := $(XDG_CONFIG_HOME) $(BIN_DIR)
clean: ## Clean dangling symlinks and backup files
	@for d in $(TARGET_DIRS); do \
		[ -d "$$d" ] || continue; \
		symlinks -dr "$$d" | grep -v '^absolute:' || true; \
		find "$$d" -type f -name "*.bak" -delete; \
	done
	@symlinks -d "$(HOME)" | grep -v '^absolute:' || true
	@find "$(HOME)" -maxdepth 1 -type f -name ".*.bak" -delete

-include makefiles/*.mk
