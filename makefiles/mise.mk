# Reference: https://mise.jdx.dev/

##@ mise

.PHONY: mise-diff
mise-diff: ## Diff mise config against installed tools
	@mise ls --prunable

.PHONY: mise-check
mise-check: ## Check if all declared mise tools are installed
	@mise install --dry-run-code

.PHONY: mise-prune
mise-prune: ## Prune unreferenced mise tools
	@mise prune --yes
