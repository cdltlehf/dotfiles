-- Reference: https://neovim.io/doc/user/diagnostic.html
-- :help vim.diagnostic.config
-- :help g:lsp_diagnostics_signs_enabled

local glyphs = vim.env.LC_TERMINAL_GLYPHS or "ascii"
local diagnostic_signs = ({
  ascii = {
    [vim.diagnostic.severity.ERROR] = "E",
    [vim.diagnostic.severity.WARN] = "W",
    [vim.diagnostic.severity.INFO] = "I",
    [vim.diagnostic.severity.HINT] = "H",
  },
  unicode = {
    [vim.diagnostic.severity.ERROR] = "✖",
    [vim.diagnostic.severity.WARN] = "⚠",
    [vim.diagnostic.severity.INFO] = "ℹ",
    [vim.diagnostic.severity.HINT] = "?",
  },
  nerdfont = {
    [vim.diagnostic.severity.ERROR] = "",
    [vim.diagnostic.severity.WARN] = "",
    [vim.diagnostic.severity.INFO] = "",
    [vim.diagnostic.severity.HINT] = "",
  },
})[glyphs]

vim.diagnostic.config({
  severity_sort = true,
  signs = { text = diagnostic_signs },
  underline = true,
  update_in_insert = false,
  virtual_text = { source = "if_many" },
})
