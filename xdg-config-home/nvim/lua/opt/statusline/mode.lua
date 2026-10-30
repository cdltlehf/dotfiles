local M = {}

local ctrl_v = vim.keycode("<C-v>")
local ctrl_s = vim.keycode("<C-s>")

local modes = {
  ["n"] = { "normal" },

  ["v"] = { "visual" },
  ["vs"] = { "visual", "select" },
  ["V"] = { "visual", "line" },
  ["Vs"] = { "visual", "line", "select" },
  [ctrl_v] = { "visual", "blockwise" },
  [ctrl_v .. "s"] = { "visual", "blockwise", "select" },

  ["s"] = { "select" },
  ["S"] = { "select", "line" },
  [ctrl_s] = { "select", "blockwise" },

  ["i"] = { "insert" },
  ["ic"] = { "insert", "completion" },
  ["ix"] = { "insert", "completion", "ctrl-x" },

  ["c"] = { "command" },
  ["cr"] = { "command", "overstrike" },

  ["cv"] = { "vim-ex" },
  ["cvr"] = { "vim-ex", "overstrike" },

  ["t"] = { "terminal" },

  ["no"] = { "pending" },
  ["nov"] = { "pending", "charwise" },
  ["noV"] = { "pending", "linewise" },
  ["no" .. ctrl_v] = { "pending", "blockwise" },

  ["R"] = { "replace" },
  ["Rc"] = { "replace", "completion" },
  ["Rx"] = { "replace", "completion", "ctrl-x" },

  ["Rv"] = { "replace", "virtual" },
  ["Rvc"] = { "replace", "virtual", "completion" },
  ["Rvx"] = { "replace", "virtual", "completion", "ctrl-x" },

  ["niI"] = { "normal", "insert" },
  ["niR"] = { "normal", "replace" },
  ["niV"] = { "normal", "virtual-replace" },
  ["nt"] = { "normal", "emulator" },
  ["ntT"] = { "normal", "terminal" },

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
