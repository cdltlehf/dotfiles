-- https://github.com/lewis6991/gitsigns.nvim
require('gitsigns').setup({
  signs = {
    add = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '' },
    topdelete = { text = '' },
    changedelete = { text = '▎' },
    untracked = { text = '┆' },
  },
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Hunk Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Next Git Hunk' })

    map('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Prev Git Hunk' })

    -- Actions (gitgutter 단축키 완벽 유지)
    map('n', 'ghs', gs.stage_hunk, { desc = 'Stage Hunk' })
    map('n', 'ghu', gs.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
    map('n', 'ghp', gs.preview_hunk, { desc = 'Preview Hunk' })
    map('n', 'ghr', gs.reset_hunk, { desc = 'Reset Hunk' })
  end,
})

-- https://github.com/tpope/vim-fugitive
local map = vim.keymap.set
map('n', '<leader>gs', ':Git<cr>', { silent = true, desc = 'Git Status (Fugitive)' })
map('n', '<leader>gd', ':Gdiffsplit<cr>', { silent = true, desc = 'Git Diff Split' })
map('n', '<leader>gb', ':Git blame<cr>', { silent = true, desc = 'Git Blame' })
