-- Reference: https://github.com/lewis6991/gitsigns.nvim

local map = vim.keymap.set
local gs = require("gitsigns")

---@return nil
local change_next = function()
  if vim.wo.diff then
    vim.cmd.normal({ "]c", bang = true })
  else
    gs.next_hunk()
  end
end

---@return nil
local change_prev = function()
  if vim.wo.diff then
    vim.cmd.normal({ "[c", bang = true })
  else
    gs.prev_hunk()
  end
end

---@return nil
local diffthis = function()
  gs.diffthis("~")
end

---@return nil
local blame_line = function()
  gs.blame_line({ full = true })
end

---@param bufnr integer
---@return nil
local on_attach = function(bufnr)
  map("n", "]c", change_next, { buffer = bufnr, desc = "Next Hunk" })
  map("n", "[c", change_prev, { buffer = bufnr, desc = "Prev Hunk" })
  map("n", "ghD", diffthis, { buffer = bufnr, desc = "Diff This (~1)" })
  map("n", "ghP", gs.preview_hunk_inline, { buffer = bufnr, desc = "Preview Hunk Inline" })
  map("n", "ghR", gs.reset_buffer, { buffer = bufnr, desc = "Reset Buffer" })
  map("n", "ghS", gs.stage_buffer, { buffer = bufnr, desc = "Stage Buffer" })
  map("n", "ghb", blame_line, { buffer = bufnr, desc = "Blame Line" })
  map("n", "ghd", gs.diffthis, { buffer = bufnr, desc = "Diff This" })
  map("n", "ghp", gs.preview_hunk, { buffer = bufnr, desc = "Preview Hunk" })
  map("n", "ghtb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle Inline Blame" })
  map("n", "ghtd", gs.toggle_deleted, { buffer = bufnr, desc = "Toggle Deleted Lines" })
  map("n", "ghtw", gs.toggle_word_diff, { buffer = bufnr, desc = "Toggle Word Diff" })
  map("n", "ghu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo Stage Hunk" })
  map({ "n", "v" }, "ghr", ":Gitsigns reset_hunk<CR>", { buffer = bufnr, desc = "Reset Hunk" })
  map({ "n", "v" }, "ghs", ":Gitsigns stage_hunk<CR>", { buffer = bufnr, desc = "Stage Hunk" })
end

gs.setup({ word_diff = false, on_attach = on_attach })
