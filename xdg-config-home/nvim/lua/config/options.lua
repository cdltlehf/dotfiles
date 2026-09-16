local opt = vim.opt

-- :help mapleader
vim.g.mapleader = " "

opt.number = true
opt.signcolumn = "yes"

opt.ignorecase = true
opt.smartcase = true

opt.wrap = false
opt.foldlevel = 99

-- :help 'formatoptions' (disable auto-wrapping of text and comments)
opt.formatoptions:remove({ "t", "c" })

-- :help 'colorcolumn'
opt.colorcolumn = "+2"

-- :help 'spell'
opt.spell = true

-- :help persistent-undo
opt.undofile = true

-- :help 'laststatus'
opt.laststatus = 3
opt.showmode = false

opt.list = true
-- :help 'listchars'
-- :help 'fillchars'
-- https://en.wikipedia.org/wiki/Non-printing_character_in_word_processors
local glyphs = vim.env.LC_TERMINAL_GLYPHS or "ascii"
if glyphs == "ascii" then
  opt.listchars = { tab = "  >", trail = ".", extends = ">", precedes = "<", nbsp = "_" }
  opt.fillchars = { vert = " ", fold = " ", foldopen = "v", foldclose = ">", foldsep = " " }
elseif glyphs == "unicode" then
  opt.listchars = { tab = "  ⇥", trail = "·", extends = "…", precedes = "…", nbsp = "␣" }
  opt.fillchars = { vert = " ", fold = " ", foldopen = "▾", foldclose = "▸", foldsep = " " }
else -- nerdfont
  opt.listchars = { tab = "  ⇥", trail = "·", extends = "…", precedes = "…", nbsp = "␣" }
  opt.fillchars = { vert = " ", fold = " ", foldopen = "", foldclose = "", foldsep = " " }
end

-- :help wildmode
opt.wildmode = { "longest", "full" }

-- :help 'completeopt'
opt.completeopt = { "menuone", "noinsert" }

opt.lazyredraw = true

-- Share Vim runtimepath (colors, syntax, compiler, ftdetect)
opt.runtimepath:append(vim.fn.expand("$XDG_CONFIG_HOME/vim"))

pcall(vim.cmd.colorscheme, "modus16")

-- Disable syntax highlighting on huge files (> 1MB)
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    if vim.fn.line2byte(vim.fn.line("$") + 1) > 1000000 then
      vim.cmd("syntax clear")
    end
  end,
})
