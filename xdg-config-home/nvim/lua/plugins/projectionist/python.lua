local function get_projections(read_template)
  local pre_commit_tmpl = { template = read_template("python/pre-commit-config.yaml.tmpl") }
  local test_tmpl = {
    alternate = "src/{}.py",
    type = "test",
    template = read_template("python/test.py.tmpl"),
  }
  local source_tmpl = {
    alternate = "tests/test_{}.py",
    type = "source",
    template = read_template("python/main.py.tmpl"),
  }
  return {
    ["*"] = {
      -- Pipe-separated keys are not supported in vim-projectionist's inner projection
      -- dicts (s:valid_key only allows one glob star). Split each alternative into a
      -- separate key and use string aliases where both sides share the same star-ness.
      [".pre-commit-config.yaml"] = pre_commit_tmpl,
      ["*.pre-commit-config.yaml"] = pre_commit_tmpl,
      ["__main__.py"] = { template = read_template("python/__main__.py.tmpl") },
      ["__init__.py"] = { template = read_template("python/init.py.tmpl") },
      ["tests/test_*.py"] = test_tmpl,
      ["test_*.py"] = "tests/test_*.py",
      ["src/*.py"] = source_tmpl,
      ["*.py"] = "src/*.py",
    },
  }
end

return get_projections
