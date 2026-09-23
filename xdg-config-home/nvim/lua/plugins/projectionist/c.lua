local function get_projections(read_template)
  local c_source_tmpl = {
    alternate = { "include/{}.h", "{}.h" },
    type = "source",
    template = read_template("c/module.c.tmpl"),
  }
  local cpp_source_tmpl = {
    alternate = { "include/{}.hpp", "{}.hpp", "include/{}.h", "{}.h" },
    type = "source",
    template = read_template("cpp/module.cc.tmpl"),
  }
  local h_header_tmpl = {
    alternate = { "src/{}.c", "{}.c" },
    type = "header",
    template = read_template("c/header.h.tmpl"),
  }
  local hpp_header_tmpl = {
    alternate = { "src/{}.cc", "{}.cc" },
    type = "header",
    template = read_template("cpp/module.cc.tmpl"),
  }
  return {
    ["*"] = {
      -- Pipe-separated keys are not supported in vim-projectionist's inner projection
      -- dicts (s:valid_key only allows one glob star). Split each alternative into a
      -- separate key and use string aliases where both sides share the same star-ness.
      ["main.c"] = { type = "source", template = read_template("c/main.c.tmpl") },
      ["main.cc"] = { type = "source", template = read_template("cpp/main.cc.tmpl") },
      ["main.cpp"] = "main.cc",
      ["src/*.c"] = c_source_tmpl,
      ["*.c"] = "src/*.c",
      ["src/*.cc"] = cpp_source_tmpl,
      ["src/*.cpp"] = "src/*.cc",
      ["*.cc"] = "src/*.cc",
      ["*.cpp"] = "src/*.cc",
      ["include/*.h"] = h_header_tmpl,
      ["*.h"] = "include/*.h",
      ["include/*.hpp"] = hpp_header_tmpl,
      ["*.hpp"] = "include/*.hpp",
      ["Makefile"] = { template = read_template("make/Makefile.tmpl") },
    },
  }
end

return get_projections
