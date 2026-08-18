vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<c-j>", 'copilot#Accept("")', { expr = true, silent = true, replace_keycodes = false })
vim.keymap.set("i", "<c-l>", "<plug>(copilot-accept-word)")

