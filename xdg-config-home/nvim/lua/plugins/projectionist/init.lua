local template_dir = (os.getenv("XDG_CONFIG_HOME") or (vim.env.HOME .. "/.config")) .. "/templates/"

local function read_template(rel_path)
  local function load(path)
    if vim.fn.filereadable(path) == 1 then
      return vim.fn.readfile(path)
    end
  end
  return load(template_dir .. rel_path) or load(vim.fn.stdpath("config") .. "/../templates/" .. rel_path)
end

vim.g.projectionist_heuristics = vim.tbl_deep_extend(
  "force",
  require("plugins.projectionist.python")(read_template),
  require("plugins.projectionist.c")(read_template)
)

-- When Projectionist fails to find a root (e.g. empty directory), the "*" heuristic
-- walks up to the nearest non-empty ancestor and anchors projections there, causing
-- file pattern mismatches. User ProjectionistDetect is Projectionist's official
-- extension point: if b:projectionist is still empty here, inject the file's own
-- directory as the root so projections apply correctly even in brand-new directories.
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
