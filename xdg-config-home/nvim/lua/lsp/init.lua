-- Reference: https://neovim.io/doc/user/lsp.html#lsp-defaults
-- :help vim.lsp.config()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
    vim.keymap.set("n", "<c-k>", function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = args.buf })
  end,
})

local configs = require("lsp.config")
for server, config in pairs(configs) do
  vim.lsp.config[server] = config
  vim.lsp.enable(server)
end
