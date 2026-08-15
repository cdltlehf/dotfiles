vim.g.fzf_layout = { down = "8" }

local map = vim.keymap.set
map("n", "<c-p>", ":Files<cr>", { silent = true })
map("n", "<leader>b", ":Buffers<cr>", { silent = true })
map("n", "<leader><tab>", "<plug>(fzf-maps-n)")
map("x", "<leader><tab>", "<plug>(fzf-maps-x)")
map("o", "<leader><tab>", "<plug>(fzf-maps-o)")
map("i", "<c-f>", "<plug>(fzf-complete-path)")
