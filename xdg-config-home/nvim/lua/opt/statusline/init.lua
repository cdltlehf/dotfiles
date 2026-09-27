local mode = require("opt.statusline.mode")

local M = {}

local glyphs = vim.env.LC_TERMINAL_GLYPHS or "ascii"
local default_ellipsis = (glyphs == "ascii") and "..." or "…"
local default_separator = ({ ascii = "%#Comment# . ", unicode = "%#Comment# · ", nerdfont = "%#Comment# · " })[glyphs]
local default_branch_icon = ({ ascii = "", unicode = "⎇ ", nerdfont = " " })[glyphs]

---@alias StatuslineConfig { ellipsis: string, separator: string, branch_icon: string }
local config = {
  ellipsis = default_ellipsis,
  separator = default_separator,
  branch_icon = default_branch_icon,
}

local hl = {
  buffer = { name = "StatusLine", readonly = "Comment" },
  git = { branch = "StatusLine" },
  mode = { token = "StatusLine" },
  diagnostics = { error = "DiagnosticError", warn = "DiagnosticWarn" },
  file = { filetype = "Comment", encoding = "DiagnosticWarn" },
  ruler = "Comment",
}

---@param uri string
---@return string? scheme
---@return string path
local function parse_uri(uri)
  local scheme, path = uri:match("^([%w_-]+)://(.*)")
  if scheme then
    return scheme, path
  end

  return nil, uri
end

---@param path string
---@param ellipsis string
---@return string
local function shorten(path, ellipsis)
  path = vim.fn.fnamemodify(path, ":~:.")
  local parts = vim.split(path, "/", { plain = true })

  if #parts > 3 then
    return string.format("%s/%s/%s/%s", parts[1], ellipsis, parts[#parts - 1], parts[#parts])
  end

  return path
end

---@alias BufferInfo { buftype: string, name: string, modified: boolean, readonly: boolean }
---@param ellipsis string
---@return BufferInfo
local function get_buffer_info(ellipsis)
  local name = vim.api.nvim_buf_get_name(0)
  local buftype = vim.bo.buftype
  local scheme, path = parse_uri(name)
  if buftype == "" and scheme then
    buftype = scheme
  end
  path = shorten(path, ellipsis)
  return {
    buftype = buftype,
    name = path,
    modified = vim.bo.modified,
    readonly = vim.bo.readonly,
  }
end

---@param group string
---@param text string
---@return string
local function paint(group, text)
  return string.format("%%#%s#%s", group, text)
end

---@alias GitInfo { branch?: string }
---@return GitInfo
local function get_git_info()
  local git_status = vim.b.gitsigns_status_dict
  local head = git_status and git_status.head
  return {
    branch = (head and head ~= "") and (config.branch_icon .. head) or nil,
  }
end

---@alias ModeInfo { token?: string }
---@return ModeInfo
local function get_mode_info()
  local tokens = mode.get()
  return {
    token = (tokens[1] ~= "normal") and table.concat(tokens, ":") or nil,
  }
end

---@alias DiagnosticInfo { error?: string, warn?: string }
---@return DiagnosticInfo
local function get_diagnostic_info()
  local is_input = vim.api.nvim_get_mode().mode:find("^[iR]")
  if is_input then
    return {}
  end

  local counts = vim.diagnostic.count(0)
  local errors = counts[vim.diagnostic.severity.ERROR] or 0
  local warnings = counts[vim.diagnostic.severity.WARN] or 0

  return {
    error = errors > 0 and string.format("%d error%s", errors, errors == 1 and "" or "s") or nil,
    warn = warnings > 0 and string.format("%d warning%s", warnings, warnings == 1 and "" or "s") or nil,
  }
end

---@alias FileInfo { filetype?: string, encoding?: string }
---@return FileInfo
local function get_file_info()
  local ft = vim.bo.filetype
  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local format = vim.bo.fileformat

  return {
    filetype = (ft ~= "") and ft or nil,
    encoding = (encoding ~= "utf-8" or format ~= "unix") and string.format("%s:%s", encoding, format) or nil,
  }
end

---@param groups table<string, string>
---@param info table<string, string?>
---@param order? string[]
---@return string[]
local function format(groups, info, order)
  local parts = {}
  local keys = order or vim.tbl_keys(groups)
  for _, key in ipairs(keys) do
    local text = info[key]
    local group = groups[key]
    if text and text ~= "" and group then
      table.insert(parts, paint(group, text))
    end
  end
  return parts
end

---@return string
local function left()
  local items = {}
  local buf = get_buffer_info(config.ellipsis)
  table.insert(items, paint(hl.buffer.name, buf.name ~= "" and buf.name or "[No Name]"))
  if buf.modified then
    table.insert(items, paint(hl.buffer.modified, "modified"))
  end
  if buf.readonly then
    table.insert(items, paint(hl.buffer.readonly, "readonly"))
  end
  vim.list_extend(items, format(hl.git, get_git_info()))
  vim.list_extend(items, format(hl.mode, get_mode_info()))
  return table.concat(items, config.separator)
end

---@return string
local function right()
  local items = {}
  vim.list_extend(items, format(hl.diagnostics, get_diagnostic_info(), { "error", "warn" }))
  vim.list_extend(items, format(hl.file, get_file_info(), { "filetype", "encoding" }))
  table.insert(items, paint(hl.ruler, "%l:%c"))
  table.insert(items, paint(hl.ruler, "%p%%"))
  return table.concat(items, config.separator)
end

---@return string
function M.render()
  return left() .. "%=" .. right()
end

---@param opts? StatuslineConfig
function M.setup(opts)
  if opts then
    config = vim.tbl_deep_extend("force", config, opts)
  end
  vim.opt.statusline = "%!v:lua.require('opt.statusline').render()"
end

M.setup()

return M
