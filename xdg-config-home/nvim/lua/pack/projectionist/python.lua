---@param read_template fun(rel_path: string): string[]?
---@return table<string, table<string, any>>
local function get_projections(read_template)
  return {
    ["pyproject.toml|requirements.txt|setup.py"] = {
      ["pyproject.toml"] = { type = "config", template = read_template("python/pyproject.toml.tmpl") },
      [".pre-commit-config.yaml"] = { type = "config", template = read_template("python/pre-commit-config.yaml.tmpl") },
      ["__main__.py"] = { type = "source", template = read_template("python/__main__.py.tmpl") },
      ["__init__.py"] = { type = "source", template = read_template("python/init.py.tmpl") },
      ["tests/test_*.py"] = {
        alternate = { "src/{}.py", "{}.py" },
        type = "test",
        template = read_template("python/test.py.tmpl"),
      },
      ["test_*.py"] = "tests/test_*.py",
      ["src/*.py"] = {
        alternate = { "tests/test_{}.py", "tests/{}_test.py", "test_{}.py" },
        type = "source",
        template = read_template("python/main.py.tmpl"),
      },
      ["*.py"] = "src/*.py",
    },
  }
end

return get_projections
