##@ Homebrew

BREWFILE ?= platforms/darwin/Brewfile

.PHONY: brew-diff diff
brew-diff: ## Diff Brewfile (alias: diff)
	@diff -u --color=auto $(BREWFILE) <(brew bundle dump --file=- --no-describe) || true
diff: brew-diff

.PHONY: brew-check check
brew-check: ## Check Brewfile (alias: check)
	@brew bundle check --file=$(BREWFILE)
check: brew-check
