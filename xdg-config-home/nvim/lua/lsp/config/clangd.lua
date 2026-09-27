return {
  cmd = { "clangd", "--fallback-style=google" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { ".clangd", ".clang-format", "compile_commands.json", "compile_flags.txt", ".git" },
}
