local templates = require("pack.projectionist.templates")

vim.g.projectionist_heuristics = {
  ["pyproject.toml|requirements.txt|setup.py"] = templates.load_projections("python"),
  ["Makefile|CMakeLists.txt"] = templates.load_projections("c"),
  ["docs/decisions/"] = templates.load_projections("madr"),
}

templates.fallback()
