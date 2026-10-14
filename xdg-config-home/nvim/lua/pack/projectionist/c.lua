---@param read_template fun(rel_path: string): string[]?
---@return table<string, table<string, any>>
local function get_projections(read_template)
  return {
    ["Makefile|CMakeLists.txt"] = {
      ["main.c"] = { type = "source", template = read_template("c/main.c.tmpl") },
      ["main.cc"] = { type = "source", template = read_template("cpp/main.cc.tmpl") },
      ["main.cpp"] = "main.cc",
      ["src/*.c"] = {
        alternate = { "include/{}.h", "{}.h" },
        type = "source",
        template = read_template("c/module.c.tmpl"),
      },
      ["*.c"] = "src/*.c",
      ["src/*.cc"] = {
        alternate = { "include/{}.hpp", "{}.hpp", "include/{}.h", "{}.h" },
        type = "source",
        template = read_template("cpp/module.cc.tmpl"),
      },
      ["src/*.cpp"] = "src/*.cc",
      ["*.cc"] = "src/*.cc",
      ["*.cpp"] = "src/*.cc",
      ["include/*.h"] = {
        alternate = { "src/{}.c", "{}.c" },
        type = "header",
        template = read_template("c/header.h.tmpl"),
      },
      ["*.h"] = "include/*.h",
      ["include/*.hpp"] = {
        alternate = { "src/{}.cc", "{}.cc" },
        type = "header",
        template = read_template("cpp/module.cc.tmpl"),
      },
      ["*.hpp"] = "include/*.hpp",
      ["Makefile"] = { type = "config", template = read_template("make/Makefile.tmpl") },
    },
  }
end

return get_projections
