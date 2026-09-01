local xdg_config_home = os.getenv("XDG_CONFIG_HOME") or (vim.env.HOME .. "/.config")
local template_directory = xdg_config_home .. "/templates/"

local function filter_template_lines(lines)
  local filtered = {}
  local in_header = true
  for _, line in ipairs(lines) do
    -- Strip template-level metadata comments (;; prefix or Reference comment headers)
    if
      line:match("^%s*;;")
      or (
        in_header
        and (
          line:match("^%s*//%s*Reference:")
          or line:match("^%s*#%s*Reference:")
          or line:match("^%s*//%s*%-%s*http")
          or line:match("^%s*#%s*%-%s*http")
        )
      )
    then
      -- skip template metadata line
    else
      if in_header and line:match("^%s*$") and #filtered == 0 then
        -- skip leading empty lines left after metadata stripping
      else
        in_header = false
        table.insert(filtered, line)
      end
    end
  end
  return filtered
end

local function read_template(relative_path)
  local path = template_directory .. relative_path
  if vim.fn.filereadable(path) == 1 then
    return filter_template_lines(vim.fn.readfile(path))
  end
  local fallback_path = vim.fn.stdpath("config") .. "/../templates/" .. relative_path
  if vim.fn.filereadable(fallback_path) == 1 then
    return filter_template_lines(vim.fn.readfile(fallback_path))
  end
  return nil
end

vim.g.projectionist_heuristics = vim.tbl_extend(
  "force",
  require("plugins.projectionist.python")(read_template),
  require("plugins.projectionist.c")(read_template)
)
