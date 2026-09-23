vim.pack.add({
  "https://github.com/junegunn/fzf",
  "https://github.com/junegunn/fzf.vim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-obsession",
  "https://github.com/tpope/vim-surround",
  "https://github.com/tpope/vim-repeat",
  "https://github.com/tpope/vim-abolish",
  "https://github.com/tpope/vim-unimpaired",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/tpope/vim-projectionist",
  "https://github.com/github/copilot.vim",
  "https://github.com/lervag/vimtex",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/sphamba/smear-cursor.nvim",
})

-- vim.pack.add installs into opt/; packadd is required to actually load them.
for _, name in ipairs({
  "fzf",
  "fzf.vim",
  "gitsigns.nvim",
  "vim-fugitive",
  "vim-obsession",
  "vim-surround",
  "vim-repeat",
  "vim-abolish",
  "vim-unimpaired",
  "nvim-web-devicons",
  "oil.nvim",
  "vim-projectionist",
  "copilot.vim",
  "vimtex",
  "which-key.nvim",
  "smear-cursor.nvim",
}) do
  vim.cmd.packadd(name)
end

require("plugins.lsp")
require("plugins.fzf")
require("plugins.copilot")
require("plugins.git")
require("plugins.session")
require("plugins.vimtex")
require("plugins.oil")
require("plugins.projectionist")
require("plugins.which_key")
require("plugins.smear_cursor")
