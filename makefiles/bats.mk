# Reference: https://bats-core.readthedocs.io/

##@ Bats

.PHONY: bats-test
bats-test: ## Run the Bats tests
	@bats tests/*.bats
