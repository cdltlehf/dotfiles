# Reference: https://www.gnu.org/software/make/manual/make.html
# Setup prerequisites: bash, curl
.PHONY: default
default: setup

.PHONY: help
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Run setup script
	@./scripts/setup

.PHONY: test
test: ## Run BATS test suites
	@bats tests/*.bats

.PHONY: podman-compose-up
podman-compose-up: ## Start the podman compose services
	@podman compose up -d

.PHONY: podman-compose-down
podman-compose-down: ## Stop the podman compose services
	@podman compose down
