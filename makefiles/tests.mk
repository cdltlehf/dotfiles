##@ Tests

.PHONY: test
test: ## Run test suites
	@bats tests/*.bats
