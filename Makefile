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
help: ## Display help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: references
references: ## List references
	@git --no-pager grep -E '^[^a-zA-Z0-9]*Reference: [^<]' | \
		sed -E $$'s/^([^:]+):.*Reference: (.*)/\033[36m\\2\033[0m \033[90m\\1\033[0m/' | sort -k1,1

.PHONY: todo
todo: ## List todos
	@git --no-pager grep -n -E '(TODO|FIXME|XXX)(\([^)]+\))?:' | \
		sed -E $$'s/^([^:]+):([0-9]+):[[:space:]]*[^a-zA-Z0-9]*((TODO|FIXME|XXX)(\\([^)]+\\))?:[[:space:]]*(.*))/\033[36m\\3\033[0m \033[90m\\1:\\2\033[0m/' | sort

##@ Dotfiles

.PHONY: sync
sync: ## Sync repo and apply setup
	@git pull --ff-only
	@$(MAKE) default

.PHONY: setup
setup: ## Apply setup
	@./scripts/setup

.PHONY: update
update: ## Update package indexes
	@./scripts/update

.PHONY: upgrade
upgrade: ## Upgrade tools
	@./scripts/upgrade

.PHONY: clean
clean: TARGET_DIRS := $(XDG_CONFIG_HOME) $(BIN_DIR) $(CURDIR)
clean: ## Clean dangling symlinks and cache
	@for d in $(TARGET_DIRS); do \
		[ -d "$$d" ] || continue; \
		symlinks -dr "$$d" | grep -v '^absolute:' || true; \
		find "$$d" \( -type f -o -type l \) \( -name "*.bak" -o -name ".*.bak" \) -delete; \
	done
	@symlinks -d "$(HOME)" | grep -v '^absolute:' || true
	@find "$(HOME)" -maxdepth 1 \( -type f -o -type l \) -name ".*.bak" -delete
	@rm -rf "$(XDG_CACHE_HOME)/evalcache"


-include makefiles/*.mk
