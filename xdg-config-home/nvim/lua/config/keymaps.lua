local map = vim.keymap.set

map("n", "<leader>mm", ":<c-u>make!<cr>", { desc = "make!" })
map("n", "<leader>ma", ":<c-u>make! all<cr>", { desc = "make! all" })
map("n", "<leader>mc", ":<c-u>make! clean<cr>", { desc = "make! clean" })
map("n", "<leader>mr", ":<c-u>make! run<cr>", { desc = "make! run" })
map("n", "<leader>mi", ":<c-u>make! install<cr>", { desc = "make! install" })
map("n", "<leader>m<space>", ":<c-u>make! ", { desc = "make! ..." })

map("n", "<leader>vv", ":<c-u>edit $MYVIMRC<cr>", { desc = "Edit config" })
map("n", "<leader>vr", ":<c-u>Reload<cr>", { desc = "Reload config" })

vim.api.nvim_create_user_command("Reload", function()
  vim.cmd("source $MYVIMRC")
  vim.notify("Neovim configuration reloaded!", vim.log.levels.INFO)
end, { desc = "Reload Neovim configuration" })

map("x", "<", "<gv", { desc = "Indent left and re-select" })
map("x", ">", ">gv", { desc = "Indent right and re-select" })

vim.cmd([[cabbr <expr> %% expand('%:p:h')]])
