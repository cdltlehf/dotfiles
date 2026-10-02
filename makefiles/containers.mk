##@ Containers

CONTAINER_ENGINE ?= $(shell command -v podman >/dev/null 2>&1 && echo "podman" || echo "docker")
IMAGE_NAME ?= dotfiles:latest

.PHONY: container-build
container-build: ## Build image
	@$(CONTAINER_ENGINE) build -t $(IMAGE_NAME) -f Containerfile .

.PHONY: container-run
container-run: ## Run shell
	@$(CONTAINER_ENGINE) run -it --rm $(IMAGE_NAME)
