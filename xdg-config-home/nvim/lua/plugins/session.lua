local session_dir = vim.fn.stdpath('state') .. '/session'
if vim.fn.isdirectory(session_dir) == 0 then
  vim.fn.mkdir(session_dir, 'p')
end

local map = vim.keymap.set
map('n', '<leader>ss', ':Obsession ' .. session_dir .. '/')
map('n', '<leader>sl', ':source ' .. session_dir .. '/')
map('n', '<leader>sD', ':Obsession!<cr>')
