-- Reference: https://neovim.io/doc/user/filetype.html

vim.filetype.add({
  extension = {
    tmpl = function(path)
      return (vim.filetype.match({ filename = path:gsub("%.tmpl$", "") }) or "template") .. ".projectionist"
    end,
  },
})
