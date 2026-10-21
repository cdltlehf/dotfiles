# Reference: https://neovim.io/doc/user/lsp.html

##@ Neovim

.PHONY: nvim-lsp-check
nvim-lsp-check: ## Check that language server commands are executable
	@nvim --headless --clean -l scripts/lsp-check.lua
