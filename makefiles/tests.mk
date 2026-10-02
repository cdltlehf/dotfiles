# Reference: https://bats-core.readthedocs.io/

##@ Tests

.PHONY: test
test: ## Run tests
	@bats tests/*.bats
