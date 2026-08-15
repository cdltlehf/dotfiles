local map = vim.keymap.set

-- :help <cmd>
map('n', '<c-l>', '<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>')

map('i', '<c-u>', '<c-g>u<c-u>')
map('i', '<c-w>', '<c-g>u<c-w>')

-- :help /\V
map('x', '*', 'y/\\V<c-r>"<cr>')
map('x', '#', 'y?\\V<c-r>"<cr>')

map('n', '&', ':&&<cr>')

-- :help section
map('', '[[', '?{<cr>w99[{')
map('', '][', '/{<cr>b99[{')
map('', ']]', 'j0[[%/{<cr>')
map('', '[]', 'k$][%?}<cr>')

-- :help <leader>
map('n', '<leader>=', "mzHmygg=G'yz`z", { silent = true })

map('n', '<leader>mm', ':<c-u>make!<cr>')
map('n', '<leader>ma', ':<c-u>make! all<cr>')
map('n', '<leader>mc', ':<c-u>make! clean<cr>')
map('n', '<leader>mr', ':<c-u>make! run<cr>')
map('n', '<leader>mi', ':<c-u>make! install<cr>')
map('n', '<leader>m<space>', ':<c-u>make! ')

local config_dir = vim.fn.stdpath('config')
map('n', '<leader>vv', ':<c-u>edit ' .. config_dir .. '/init.lua<cr>')
map('n', '<leader>vV', ':<c-u>edit ' .. config_dir .. '<cr>')
map('n', '<leader>vr', ':<c-u>Reload<cr>')

-- :help :command
vim.api.nvim_create_user_command('Reload', function()
  vim.cmd('source ' .. config_dir .. '/init.lua')
  print('Reloaded')
end, { desc = 'Reload Neovim configuration' })

map('x', '<', '<gv')
map('x', '>', '>gv')

-- :help g:netrw_home
map('ca', '%%', function()
  if vim.fn.getcmdtype() == ':' then
    return vim.fn.expand('%:p:h')
  else
    return '%%'
  end
end, { expr = true })
