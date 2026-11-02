-- Share the Vim runtime files. Only vimrc and vimrc.d stay Vim-only.
local vim_dir = vim.fn.expand("$XDG_CONFIG_HOME/vim")
vim.opt.runtimepath:append({ vim_dir, vim_dir .. "/after" })
vim.opt.packpath:append(vim_dir)

require("opt")
require("keymap")
require("cmd")
require("diagnostic")
require("lsp")
require("pack")
