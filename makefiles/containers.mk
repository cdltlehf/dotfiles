##@ Containers

CONTAINER_ENGINE ?= $(shell command -v podman >/dev/null 2>&1 && echo "podman" || echo "docker")
IMAGE_NAME ?= dotfiles:latest

.PHONY: container-build build
container-build: ## Build image (alias: build)
	@$(CONTAINER_ENGINE) build -t $(IMAGE_NAME) -f Containerfile .
build: container-build

.PHONY: container-run run
container-run: ## Run shell (alias: run)
	@$(CONTAINER_ENGINE) run -it --rm $(IMAGE_NAME)
run: container-run
