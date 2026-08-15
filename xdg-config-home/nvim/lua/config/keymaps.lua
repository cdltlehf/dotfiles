local map = vim.keymap.set

-- Make commands
map("n", "<leader>mm", ":<c-u>make!<cr>", { desc = "make!" })
map("n", "<leader>ma", ":<c-u>make! all<cr>", { desc = "make! all" })
map("n", "<leader>mc", ":<c-u>make! clean<cr>", { desc = "make! clean" })
map("n", "<leader>mr", ":<c-u>make! run<cr>", { desc = "make! run" })
map("n", "<leader>mi", ":<c-u>make! install<cr>", { desc = "make! install" })
map("n", "<leader>m<space>", ":<c-u>make! ", { desc = "make! ..." })

-- Config commands
map("n", "<leader>vv", ":<c-u>edit $MYVIMRC<cr>", { desc = "Edit config" })

-- Visual mode indent retention
map("x", "<", "<gv", { desc = "Indent left and re-select" })
map("x", ">", ">gv", { desc = "Indent right and re-select" })

-- Section jump mappings
map("n", "[[", "?{<cr>w99[{", { desc = "Jump to previous section" })
map("n", "][", "/{<cr>b99[{", { desc = "Jump to next section start" })
map("n", "]]", "j0[[%/{<cr>", { desc = "Jump to next section" })
map("n", "[]", "k$][%?}<cr>", { desc = "Jump to previous section end" })

-- Command-line abbreviation for current buffer directory
vim.cmd([[cabbr <expr> %% expand('%:p:h')]])
