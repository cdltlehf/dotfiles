##@ Homebrew

BREWFILE ?= platforms/darwin/Brewfile

.PHONY: brew-diff
brew-diff: ## Show Brewfile diff
	@diff -u --color=auto $(BREWFILE) <(brew bundle dump --file=-) || true

.PHONY: brew-check
brew-check: ## Check Brewfile dependencies
	@brew bundle check --file=$(BREWFILE)
