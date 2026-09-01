local function get_projections(read_template)
  return {
    ["Makefile|CMakeLists.txt|*.cc|*.cpp|*.c"] = {
      ["*main*.c"] = {
        alternate = { "include/{}.h", "{}.h" },
        type = "source",
        template = read_template("c/main.c.tmpl"),
      },
      ["*main*.cc|*main*.cpp"] = {
        alternate = { "include/{}.h", "{}.h", "include/{}.hpp", "{}.hpp" },
        type = "source",
        template = read_template("cpp/main.cc.tmpl"),
      },
      ["src/*.c|*.c"] = {
        alternate = { "include/{}.h", "{}.h" },
        type = "source",
        template = read_template("c/module.c.tmpl"),
      },
      ["src/*.cc|*.cc|src/*.cpp|*.cpp"] = {
        alternate = { "include/{}.h", "{}.h", "include/{}.hpp", "{}.hpp" },
        type = "source",
        template = read_template("cpp/module.cc.tmpl"),
      },
      ["include/*.h|*.h|include/*.hpp|*.hpp"] = {
        alternate = { "src/{}.cc", "{}.cc", "src/{}.c", "{}.c" },
        type = "header",
        template = read_template("c/header.h.tmpl"),
      },
      ["Makefile"] = {
        template = read_template("make/Makefile.tmpl"),
      },
    },
  }
end

return get_projections
