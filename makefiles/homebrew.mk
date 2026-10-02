##@ Homebrew

BREWFILE ?= platforms/darwin/Brewfile

.PHONY: brew-diff
brew-diff: ## Diff Brewfile
	@diff -u --color=auto $(BREWFILE) <(brew bundle dump --file=-) || true

.PHONY: brew-check
brew-check: ## Check Brewfile
	@brew bundle check --file=$(BREWFILE)
