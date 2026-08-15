vim.pack.add({
  'https://github.com/junegunn/fzf',
  'https://github.com/junegunn/fzf.vim',
  'https://github.com/airblade/vim-gitgutter',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-obsession',
  'https://github.com/tpope/vim-surround',
  'https://github.com/tpope/vim-repeat',
  'https://github.com/tpope/vim-abolish',
  'https://github.com/tpope/vim-vinegar',
  'https://github.com/github/copilot.vim',
  'https://github.com/lervag/vimtex',
})

require('plugins.lsp')

-- https://github.com/github/copilot.vim
-- :help copilot.txt
vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<c-j>', 'copilot#Accept()', { expr = true, silent = true, script = true })
vim.keymap.set('i', '<c-l>', '<plug>(copilot-accept-word)')

-- https://github.com/junegunn/fzf.vim
-- :help fzf.txt
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
    vim.opt_local.laststatus = 2
    vim.opt_local.showmode = true
    vim.opt_local.ruler = true
  end,
})
vim.keymap.set('n', '<c-p>', ':Files<cr>', { silent = true })
vim.keymap.set('n', '<leader>ff', ':Files<cr>', { silent = true })
vim.keymap.set('n', '<leader>b', ':Buffers<cr>', { silent = true })
vim.keymap.set('n', '<leader>fb', ':Buffers<cr>', { silent = true })
vim.keymap.set('n', '<leader><tab>', '<plug>(fzf-maps-n)')
vim.keymap.set('x', '<leader><tab>', '<plug>(fzf-maps-x)')
vim.keymap.set('o', '<leader><tab>', '<plug>(fzf-maps-o)')
vim.keymap.set('i', '<c-f>', '<plug>(fzf-complete-path)')

-- https://github.com/airblade/vim-gitgutter
-- :help gitgutter.txt
vim.keymap.set('n', 'ghp', '<Plug>(GitGutterPreviewHunk)')
vim.keymap.set('n', 'ghs', '<Plug>(GitGutterStageHunk)')
vim.keymap.set('n', 'ghu', '<Plug>(GitGutterUndoHunk)')

-- https://github.com/tpope/vim-obsession
-- :help obsession.txt
local session_dir = vim.fn.stdpath('state') .. '/session'
if vim.fn.isdirectory(session_dir) == 0 then
  vim.fn.mkdir(session_dir, 'p')
end
vim.keymap.set('n', '<leader>ss', ':Obsession ' .. session_dir .. '/')
vim.keymap.set('n', '<leader>sl', ':source ' .. session_dir .. '/')
vim.keymap.set('n', '<leader>sD', ':Obsession!<cr>')

-- https://github.com/lervag/vimtex
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_view_method = 'skim'
vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_view_skim_sync = 1

-- https://github.com/tpope/vim-vinegar
vim.g.netrw_fastbrowse = 0
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    vim.opt_local.bufhidden = 'wipe'
  end,
})
