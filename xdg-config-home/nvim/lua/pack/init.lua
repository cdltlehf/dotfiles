local gh = function(x)
  return "https://github.com/" .. x
end

vim.pack.add({
  gh("junegunn/fzf"),
  gh("junegunn/fzf.vim"),
  gh("lewis6991/gitsigns.nvim"),
  gh("tpope/vim-fugitive"),
  gh("tpope/vim-obsession"),
  gh("tpope/vim-surround"),
  gh("tpope/vim-repeat"),
  gh("tpope/vim-abolish"),
  gh("tpope/vim-unimpaired"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("stevearc/oil.nvim"),
  gh("tpope/vim-projectionist"),
  gh("github/copilot.vim"),
  gh("lervag/vimtex"),
  gh("folke/which-key.nvim"),
  gh("sphamba/smear-cursor.nvim"),
})

require("pack.fzf")
require("pack.copilot")
require("pack.git")
require("pack.session")
require("pack.vimtex")
require("pack.oil")
require("pack.projectionist")
require("pack.which_key")
require("pack.smear_cursor")
