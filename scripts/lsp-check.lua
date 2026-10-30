vim.opt.rtp:prepend(vim.fn.stdpath("config"))

local missing = {}
for name, config in pairs(require("lsp.config")) do
  local cmd = type(config.cmd) == "table" and config.cmd[1] or nil
  if cmd and vim.fn.executable(cmd) == 0 then
    table.insert(missing, ("%s: %s"):format(name, cmd))
  end
end
table.sort(missing)
for _, line in ipairs(missing) do
  io.stderr:write(line, "\n")
end
os.exit(#missing == 0 and 0 or 1)
