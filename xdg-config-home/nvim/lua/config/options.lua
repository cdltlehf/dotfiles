local opt = vim.opt

-- :help mapleader
vim.g.mapleader = " "

opt.number = true

opt.ignorecase = true
opt.smartcase = true

opt.wrap = false
opt.foldlevel = 99

-- :help 'colorcolumn'
opt.colorcolumn = "+2"

-- :help 'spell'
opt.spell = true

-- :help persistent-undo
opt.undofile = true

-- :help 'clipboard'
opt.clipboard = "unnamedplus"

-- :help 'laststatus'
opt.laststatus = 3

opt.list = true
-- :help listchars
-- https://en.wikipedia.org/wiki/Non-printing_character_in_word_processors
opt.listchars = { tab = "→ ", trail = "·", extends = "»", precedes = "«", nbsp = "°" }

opt.fillchars = { vert = "│", fold = "·", foldsep = "│" }

-- :help wildmode
opt.wildmode = { "longest", "full" }

-- :help 'completeopt'
opt.completeopt = { "menuone", "noinsert" }

opt.lazyredraw = true

pcall(vim.cmd.colorscheme, "dracula16")

-- Disable syntax highlighting on huge files (> 1MB)
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		if vim.fn.line2byte(vim.fn.line("$") + 1) > 1000000 then
			vim.cmd("syntax clear")
		end
	end,
})

-- Neovim 0.12 built-in treesitter highlighting
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})
