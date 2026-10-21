local M = {}

local template_dir = os.getenv("XDG_TEMPLATES_DIR")
if not template_dir or template_dir == "" then
  template_dir = vim.fs.joinpath(vim.env.HOME, "Templates")
end
template_dir = vim.fs.normalize(template_dir)

---@param file string
---@return string[]?
local function read_template(file)
  if vim.fn.filereadable(file) == 0 then
    return nil
  end
  local lines = vim.fn.readfile(file)
  if not file:match("%.tmpl$") then
    lines = vim.tbl_map(function(line)
      return (line:gsub("[{}]", { ["{"] = "{open}", ["}"] = "{close}" }))
    end, lines)
  end
  return lines
end

---@param name string
---@param opts? { root?: string, depth?: integer }
---@return table<string, any>
function M.load_projections(name, opts)
  opts = opts or {}
  local dir = vim.fs.joinpath(opts.root or template_dir, name)
  local depth = opts.depth or -1
  local projections = {}
  for path, kind in vim.fs.dir(dir, { depth = depth < 0 and math.huge or depth }) do
    if kind ~= "directory" then
      local pattern = (path:gsub("%.tmpl$", ""):gsub("{}", "*"):gsub("^dot_", "."):gsub("/dot_", "/."))
      local parent = pattern:match("([^/]+)/[^/]*%*[^/]*$")
      projections[pattern] = {
        type = parent and parent:match("^(.+)s$"),
        template = read_template(vim.fs.joinpath(dir, path)),
      }
    end
  end
  return projections
end

---@param opts? { root?: string }
function M.fallback(opts)
  opts = opts or {}
  local dir = opts.root or template_dir
  vim.api.nvim_create_autocmd("BufNewFile", {
    group = vim.api.nvim_create_augroup("projectionist_fallback", { clear = true }),
    callback = function(args)
      if not vim.tbl_isempty(vim.fn["projectionist#query"]("template")) then
        return
      end
      local file = vim.fs.joinpath(dir, vim.fs.basename(args.file))
      if vim.fn.filereadable(file) == 1 then
        vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, vim.fn.readfile(file))
      end
    end,
  })
end

return M
