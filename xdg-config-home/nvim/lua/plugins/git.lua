require("gitsigns").setup({
	numhl = true,
	on_attach = function(bufnr)
		local gs = require("gitsigns")
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("]c", gs.next_hunk, "Next Hunk")
		map("[c", gs.prev_hunk, "Prev Hunk")
		map("ghp", gs.preview_hunk, "Preview Hunk")
		map("ghs", gs.stage_hunk, "Stage Hunk")
		map("ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
		map("ghr", gs.reset_hunk, "Reset Hunk")
	end,
})

local map = vim.keymap.set
map("n", "<leader>gs", ":Git<cr>", { silent = true })
map("n", "<leader>gd", ":Gdiffsplit<cr>", { silent = true })
map("n", "<leader>gb", ":Git blame<cr>", { silent = true })
