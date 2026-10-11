---@param read_template fun(rel_path: string): string[]?
---@return table<string, table<string, any>>
local function get_projections(read_template)
  return {
    [".git/"] = {
      ["AGENTS.md"] = { template = read_template("AGENTS.md.tmpl") },
    },
  }
end

return get_projections
