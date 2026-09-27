local map = vim.keymap.set

local function get_current_file_directory()
  return vim.fn.expand("%:p:h")
end

map("ca", "%%", get_current_file_directory, { expr = true, desc = "Current file directory" })
map("n", "<leader>m", ":<c-u>make! ", { desc = "make! ..." })
map("n", "<leader>vv", ":<c-u>edit $MYVIMRC<cr>", { desc = "Edit config" })
map("x", "<", "<gv", { desc = "Indent left and re-select" })
map("x", ">", ">gv", { desc = "Indent right and re-select" })
