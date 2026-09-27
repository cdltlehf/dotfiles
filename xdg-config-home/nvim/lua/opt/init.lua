-- Reference: https://en.wikipedia.org/wiki/Non-printing_character_in_word_processors

vim.g.mapleader = " "
local opt = vim.opt

opt.colorcolumn = "+1"
opt.completeopt:append({ "menuone", "noinsert", "noselect" })
opt.foldlevel = 99
opt.ignorecase = true
opt.laststatus = 3
opt.list = true
opt.number = true
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true
opt.spell = true
opt.undofile = true
opt.wildmode = { "longest:full", "full" }
opt.wrap = false

local glyphs = vim.env.LC_TERMINAL_GLYPHS or "ascii"
opt.listchars:append({
  tab = "  →",
  trail = "·",
  extends = "…",
  precedes = "…",
  nbsp = "°",
})
opt.fillchars:append({ diff = "─", foldopen = "▾", foldclose = "▸", lastline = "⋮" })
if glyphs == "ascii" then
  opt.listchars:append({ tab = "> ", trail = "-", extends = ">", precedes = "<", nbsp = "+" })
  opt.fillchars:remove({ "diff", "lastline" })
  opt.fillchars:append({
    vert = "|",
    fold = "-",
    foldsep = "|",
    verthoriz = "+",
    vertleft = "+",
    vertright = "+",
    foldopen = "-",
    foldclose = "+",
  })
elseif glyphs == "unicode" then
elseif glyphs == "nerdfont" then
  opt.fillchars:append({ foldopen = "", foldclose = "" })
end

require("opt.statusline")
