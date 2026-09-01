vim.g.fzf_layout = { down = "8" }

local fzf_group = vim.api.nvim_create_augroup("FzfStatusLine", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = fzf_group,
	pattern = "fzf",
	callback = function()
		vim.opt.laststatus = 0
		vim.opt_local.showmode = false
		vim.opt_local.ruler = false

		vim.api.nvim_create_autocmd("BufLeave", {
			group = fzf_group,
			buffer = 0,
			once = true,
			callback = function()
				vim.opt.laststatus = 2
				vim.opt_local.showmode = true
				vim.opt_local.ruler = true
			end,
		})
	end,
})

local map = vim.keymap.set
map("n", "<c-p>", ":Files<cr>", { silent = true })
map("n", "<leader>b", ":Buffers<cr>", { silent = true })
map("n", "<leader><tab>", "<plug>(fzf-maps-n)")
map("x", "<leader><tab>", "<plug>(fzf-maps-x)")
map("o", "<leader><tab>", "<plug>(fzf-maps-o)")
map("i", "<c-f>", "<plug>(fzf-complete-path)")
