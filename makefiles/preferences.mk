# Reference: https://keith.github.io/xcode-man-pages/defaults.1.html

##@ Preferences

.PHONY: preferences-diff
preferences-diff: ## Diff the macOS preferences against the repository
	@./scripts/preferences diff
