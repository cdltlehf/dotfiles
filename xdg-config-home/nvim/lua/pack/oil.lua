require("oil").setup({
  columns = {},
  view_options = { show_hidden = true },
  keymaps = {
    ["<C-p>"] = false,
    ["K"] = "actions.preview",
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.fillchars:append({ eob = " " })
  end,
})
