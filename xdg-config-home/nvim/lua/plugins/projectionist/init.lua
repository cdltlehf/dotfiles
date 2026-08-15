local xdg_config_home = os.getenv('XDG_CONFIG_HOME') or (vim.env.HOME .. '/.config')
local template_directory = xdg_config_home .. '/templates/'

local function read_template(relative_path)
  local path = template_directory .. relative_path
  if vim.fn.filereadable(path) == 1 then
    return vim.fn.readfile(path)
  end
  local fallback_path = vim.fn.stdpath('config') .. '/../templates/' .. relative_path
  if vim.fn.filereadable(fallback_path) == 1 then
    return vim.fn.readfile(fallback_path)
  end
  return nil
end

vim.g.projectionist_heuristics = vim.tbl_extend(
  'force',
  require('plugins.projectionist.python')(read_template),
  require('plugins.projectionist.c')(read_template)
)
