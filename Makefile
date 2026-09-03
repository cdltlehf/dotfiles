# Reference: https://www.gnu.org/software/make/manual/make.html
# Setup prerequisites: bash, curl
.PHONY: default
default: setup test

.PHONY: help
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Run dotfiles setup script
	@./setup

.PHONY: test
test: ## Run BATS test suites (compatibility and idempotency)
	@bats tests/*.bats

.PHONY: podman-compose-up
podman-compose-up: ## Start llama-server container in background
	@podman compose up -d

.PHONY: podman-compose-down
podman-compose-down: ## Stop llama-server container
	@podman compose down
