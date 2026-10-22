vim.opt.runtimepath:append(vim.fn.expand("$XDG_CONFIG_HOME/vim"))
vim.opt.runtimepath:append(vim.fn.expand("$XDG_CONFIG_HOME/vim/after"))
pcall(vim.cmd.colorscheme, "modus16")
