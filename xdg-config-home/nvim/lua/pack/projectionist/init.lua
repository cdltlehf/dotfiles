local template_dir = (os.getenv("XDG_CONFIG_HOME") or (vim.env.HOME .. "/.config")) .. "/templates/"

---@param rel_path string
---@return string[]?
local function read_template(rel_path)
  ---@param path string
  ---@return string[]?
  local function load(path)
    if vim.fn.filereadable(path) == 1 then
      return vim.fn.readfile(path)
    end
  end
  return load(template_dir .. rel_path) or load(vim.fn.stdpath("config") .. "/../templates/" .. rel_path)
end

vim.g.projectionist_heuristics = vim.tbl_deep_extend(
  "force",
  require("pack.projectionist.python")(read_template),
  require("pack.projectionist.c")(read_template)
)

vim.api.nvim_create_autocmd("User", {
  pattern = "ProjectionistDetect",
  group = vim.api.nvim_create_augroup("projectionist_detect_fix", { clear = true }),
  callback = function()
    if vim.fn.empty(vim.b.projectionist) == 1 then
      local root = vim.fn.fnamemodify(vim.g.projectionist_file, ":h")
      local projections = vim.g.projectionist_heuristics["*"]
      if projections then
        vim.fn["projectionist#append"](root, projections)
      end
    end
  end,
})
