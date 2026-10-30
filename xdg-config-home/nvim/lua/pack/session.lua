local session_dir = vim.fn.stdpath("state") .. "/session"
vim.fn.mkdir(session_dir, "p")

local map = vim.keymap.set
map("n", "<leader>ss", ":Obsession " .. session_dir .. "/")
map("n", "<leader>sl", ":source " .. session_dir .. "/")
map("n", "<leader>sD", ":Obsession!<cr>")
