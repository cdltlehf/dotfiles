# Reference: https://github.com/kubernetes-sigs/kubebuilder/blob/master/Makefile

SHELL := /bin/bash

.PHONY: default
default: setup update

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
references: ## List references sorted by URL
	@git --no-pager grep -E '^[^a-zA-Z0-9]*Reference: [^<]' | \
		sed -E $$'s/^([^:]+):.*Reference: (.*)/\033[36m\\2\033[0m \033[90m\\1\033[0m/' | sort -k1,1

##@ Dotfiles

.PHONY: sync
sync: ## Sync repository and apply setup
	@git pull --ff-only
	@$(MAKE) default

.PHONY: setup
setup: ## Run setup script
	@./scripts/setup

.PHONY: update
update: ## Update package manager indexes
	@./scripts/update

.PHONY: upgrade
upgrade: ## Upgrade tools and dependencies
	@./scripts/upgrade

.PHONY: doctor
doctor: ## Run diagnostic doctor checks across package managers
	@./scripts/doctor

.PHONY: clean
clean: TARGET_DIRS := $(XDG_CONFIG_HOME) $(BIN_DIR) $(CURDIR)
clean: ## Clean dangling symlinks and backup files
	@for d in $(TARGET_DIRS); do \
		[ -d "$$d" ] || continue; \
		symlinks -dr "$$d" | grep -v '^absolute:' || true; \
		find "$$d" \( -type f -o -type l \) \( -name "*.bak" -o -name ".*.bak" \) -delete; \
	done
	@symlinks -d "$(HOME)" | grep -v '^absolute:' || true
	@find "$(HOME)" -maxdepth 1 \( -type f -o -type l \) -name ".*.bak" -delete
	@rm -rf "$(XDG_CACHE_HOME)/evalcache"


-include makefiles/*.mk
