vim.g.fzf_layout = { down = '8' }

local fzf_group = vim.api.nvim_create_augroup('FzfConfig', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = fzf_group,
  pattern = 'fzf',
  callback = function()
    vim.opt_local.laststatus = 0
    vim.opt_local.showmode = false
    vim.opt_local.ruler = false
  end,
})

vim.api.nvim_create_autocmd('BufLeave', {
  group = fzf_group,
  pattern = '<buffer>',
  callback = function()
    vim.opt_local.laststatus = 3
    vim.opt_local.showmode = true
    vim.opt_local.ruler = true
  end,
})

local map = vim.keymap.set
map('n', '<c-p>', ':Files<cr>', { silent = true })
map('n', '<leader>ff', ':Files<cr>', { silent = true })
map('n', '<leader>b', ':Buffers<cr>', { silent = true })
map('n', '<leader>fb', ':Buffers<cr>', { silent = true })
map('n', '<leader><tab>', '<plug>(fzf-maps-n)')
map('x', '<leader><tab>', '<plug>(fzf-maps-x)')
map('o', '<leader><tab>', '<plug>(fzf-maps-o)')
map('i', '<c-f>', '<plug>(fzf-complete-path)')
