# Reference: https://prek.j178.dev/

##@ prek

.PHONY: prek-run
prek-run: ## Run the hooks on all files
	@prek run --all-files
