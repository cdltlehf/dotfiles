-- Reference: https://microsoft.github.io/language-server-protocol/implementors/servers/

local M = {}

M["ruff"] = require("lsp.config.ruff")
M["ty"] = require("lsp.config.ty")
M["rust_analyzer"] = require("lsp.config.rust_analyzer")
M["clangd"] = require("lsp.config.clangd")
M["denols"] = require("lsp.config.denols")
M["taplo"] = require("lsp.config.taplo")
M["marksman"] = require("lsp.config.marksman")
M["markdownlint"] = require("lsp.config.markdownlint")
M["html"] = require("lsp.config.html")
M["bashls"] = require("lsp.config.bashls")
M["stylua"] = require("lsp.config.stylua")
M["yamlls"] = require("lsp.config.yamlls")
M["efm"] = require("lsp.config.efm")
M["vimls"] = require("lsp.config.vimls")
M["lua_ls"] = require("lsp.config.lua_ls")

return M
