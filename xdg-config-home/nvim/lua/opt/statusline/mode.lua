local M = {}

local ctrl_v = vim.keycode("<C-v>")
local ctrl_s = vim.keycode("<C-s>")

local modes = {
  -- BASIC modes
  -- Normal mode
  ["n"] = { "normal" },

  -- Visual mode
  ["v"] = { "visual" },
  ["vs"] = { "visual", "select" },
  ["V"] = { "visual", "line" },
  ["Vs"] = { "visual", "line", "select" },
  [ctrl_v] = { "visual", "blockwise" },
  [ctrl_v .. "s"] = { "visual", "blockwise", "select" },

  -- Select mode
  ["s"] = { "select" },
  ["S"] = { "select", "line" },
  [ctrl_s] = { "select", "blockwise" },

  -- Insert mode
  ["i"] = { "insert" },
  ["ic"] = { "insert", "completion" },
  ["ix"] = { "insert", "completion", "ctrl-x" },

  -- Cmdline mode
  ["c"] = { "command" },
  ["cr"] = { "command", "overstrike" },

  -- Ex mode
  ["cv"] = { "vim-ex" },
  ["cvr"] = { "vim-ex", "overstrike" },

  -- Terminal mode
  ["t"] = { "terminal" },

  -- ADDITIONAL modes
  -- Operator-pending mode
  ["no"] = { "pending" },
  ["nov"] = { "pending", "charwise" },
  ["noV"] = { "pending", "linewise" },
  ["no" .. ctrl_v] = { "pending", "blockwise" },

  -- Replace mode
  ["R"] = { "replace" },
  ["Rc"] = { "replace", "completion" },
  ["Rx"] = { "replace", "completion", "ctrl-x" },

  -- Virtual Replace mode
  ["Rv"] = { "replace", "virtual" },
  ["Rvc"] = { "replace", "virtual", "completion" },
  ["Rvx"] = { "replace", "virtual", "completion", "ctrl-x" },

  -- Insert Normal mode
  ["niI"] = { "normal", "insert" },
  ["niR"] = { "normal", "replace" },
  ["niV"] = { "normal", "virtual-replace" },
  ["nt"] = { "normal", "emulator" },
  ["ntT"] = { "normal", "terminal" },

  -- Insert Visual mode
  -- Insert Select mode

  -- Extra
  ["r"] = { "hit-enter" },
  ["rm"] = { "more" },
  ["r?"] = { "confirm" },
  ["!"] = { "shell" },
}

---@param mode? string
---@return string[]
function M.get(mode)
  mode = mode or vim.api.nvim_get_mode().mode
  return modes[mode] or { mode }
end

return M
