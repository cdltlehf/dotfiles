# Reference: https://github.com/kubernetes-sigs/kubebuilder/blob/master/Makefile

SHELL := /bin/bash

.PHONY: default
default: update install ## Update package indexes and install (default)

export XDG_CONFIG_HOME ?= $(HOME)/.config
export XDG_DATA_HOME ?= $(HOME)/.local/share
export XDG_STATE_HOME ?= $(HOME)/.local/state
export XDG_CACHE_HOME ?= $(HOME)/.cache
export BIN_DIR ?= $(HOME)/.local/bin

##@ General

.PHONY: help
help: ## Display help
	@awk ' \
		BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
		/^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } \
	' $(MAKEFILE_LIST)

.PHONY: references
references: ## List references
	@{ \
		git --no-pager grep -E '^[^a-zA-Z0-9]*Reference: [^<]' -- ':!REFERENCES' | \
			awk -F: '{ \
				file = $$1; \
				sub(/^[^:]+:[[:space:]]*[^a-zA-Z0-9]*Reference:[[:space:]]*/, ""); \
				print $$0 "\t" file \
			}'; \
		awk '/^Files:/ { $$1 = ""; files = $$0; next } \
			/^ / { n = split(files, f); for (i = 1; i <= n; i++) print $$1 "\t" f[i] }' REFERENCES; \
	} | \
		sort | \
		awk -F'\t' '{ printf "\033[36m%s\033[0m \033[90m%s\033[0m\n", $$1, $$2 }'

.PHONY: todo
todo: ## List to-dos
	@git --no-pager grep -n -E '(TODO|FIXME|XXX)(\([^)]+\))?:' | \
		awk -F: '{ \
			file = $$1; \
			line = $$2; \
			sub(/^[^:]+:[0-9]+:[[:space:]]*/, ""); \
			sub(/^[^a-zA-Z0-9]*/, ""); \
			printf "\033[36m%s\033[0m \033[90m%s:%s\033[0m\n", $$0, file, line \
		}' | \
		sort

##@ Dotfiles

.PHONY: sync
sync: ## Sync repo and install
	@git pull --ff-only
	@$(MAKE) default

.PHONY: install setup
install: ## Install dotfiles, links, and tools (alias: setup)
	@./scripts/setup
setup: install

.PHONY: dev
dev: ## Prepare the repository for development
	@./scripts/dev

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
		[[ -d "$$d" ]] || continue; \
		symlinks -dr "$$d" | grep -v '^absolute:' || true; \
		find "$$d" \( -type f -o -type l \) \
			\( -name "*.bak" -o -name ".*.bak" \) -delete; \
	done
	@symlinks -d "$(HOME)" | grep -v '^absolute:' || true
	@find "$(HOME)" -maxdepth 1 \( -type f -o -type l \) -name ".*.bak" -delete
	@rm -rf "$(XDG_CACHE_HOME)/evalcache"

.PHONY: installcheck
installcheck: brew-check mise-check nvim-lsp-check ## Check that declared packages and language servers are installed

.PHONY: check
check: bats-test ## Run tests

.PHONY: lint
lint: prek-run ## Run linters

.PHONY: diff
# TODO: Run this and installcheck from a git-flow pre-flow-feature-finish
# hook, so that a feature reaches develop only after the check.
diff: brew-diff mise-diff templates-diff ## Diff package manifests and repository configs

##@ Diagnostics

BASH_BIN := $(shell command -v bash)
ZSH_BIN := $(shell command -v zsh)

.PHONY: doctor
doctor: ## Check tool health
	./scripts/doctor

.PHONY: trace
trace: ## Trace startup order
ifneq ($(BASH_BIN),)
	@printf "\033[36m==> $(BASH_BIN) -l -i\033[0m\n"
	@printf "%b\n" "$(subst :,\n,$(shell ./scripts/trace $(BASH_BIN) -l -i))"
	@printf "\n\033[36m==> $(BASH_BIN) -i\033[0m\n"
	@printf "%b\n" "$(subst :,\n,$(shell ./scripts/trace $(BASH_BIN) -i))"
endif
ifneq ($(ZSH_BIN),)
	@printf "\n\033[36m==> $(ZSH_BIN) -l -i\033[0m\n"
	@printf "%b\n" "$(subst :,\n,$(shell ./scripts/trace $(ZSH_BIN) -l -i))"
	@printf "\n\033[36m==> $(ZSH_BIN) -i\033[0m\n"
	@printf "%b\n" "$(subst :,\n,$(shell ./scripts/trace $(ZSH_BIN) -i))"
endif

-include makefiles/*.mk
