# Reference: https://keith.github.io/xcode-man-pages/defaults.1.html

##@ Defaults

.PHONY: defaults-diff
defaults-diff: ## Diff the macOS defaults against the repository
	@./scripts/defaults-diff
