##@ Tests

.PHONY: test
test: ## Run tests
	@bats tests/*.bats
