# Reference: https://bats-core.readthedocs.io/

##@ Tests

.PHONY: test
test: ## Run tests
	@bats tests/*.bats

.PHONY: lint
lint: ## Run linters
	@prek run --all-files
