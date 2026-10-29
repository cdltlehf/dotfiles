# Reference: https://karabiner-elements.pqrs.org/docs/json/root-data-structure/

##@ Karabiner

.PHONY: karabiner-diff
karabiner-diff: ## Diff the Karabiner rules against karabiner.json
	@./scripts/karabiner-diff
