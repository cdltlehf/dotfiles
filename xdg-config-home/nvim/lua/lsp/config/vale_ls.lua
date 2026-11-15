local function has_vale_styles()
  local data_home = vim.env.XDG_DATA_HOME or (vim.env.HOME .. "/.local/share")
  local styles_dir = data_home .. "/vale/styles"
  if vim.fn.isdirectory(styles_dir) == 0 then
    return false
  end
  return vim.fs.dir(styles_dir)() ~= nil
end

return {
  cmd = { "vale-ls" },
  filetypes = { "markdown", "markdown.mdx" },
  root_dir = function(bufnr, on_dir)
    if not has_vale_styles() then
      return
    end
    local root = vim.fs.root(bufnr, { "vale.ini", ".vale.ini" })
    if root then
      on_dir(root)
    end
  end,
}
