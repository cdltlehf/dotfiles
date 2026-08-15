local M = {}

local modes = {
	["!"] = "shell",
	["\19"] = "select:block",
	["\22"] = "visual:block",
	["\22s"] = "visual:block",
	["R"] = "replace",
	["Rc"] = "replace",
	["Rv"] = "replace:virtual",
	["Rvc"] = "replace:virtual",
	["Rvx"] = "replace:virtual",
	["Rx"] = "replace",
	["S"] = "select:line",
	["V"] = "visual:line",
	["Vs"] = "visual:line",
	["c"] = "command",
	["ce"] = "ex",
	["cv"] = "ex",
	["i"] = "insert",
	["ic"] = "insert",
	["ix"] = "insert",
	["n"] = nil,
	["niI"] = "insert:pending",
	["niR"] = "replace:pending",
	["niV"] = "replace:pending",
	["no"] = "pending",
	["noV"] = "pending:line",
	["nov"] = "pending:char",
	["no\22"] = "pending:block",
	["nt"] = "terminal:normal",
	["r"] = "prompt",
	["r?"] = "confirm",
	["rm"] = "more",
	["s"] = "select",
	["t"] = "terminal",
	["v"] = "visual",
	["vs"] = "visual",
}

local function setup_highlights()
	local set_hl = vim.api.nvim_set_hl
	set_hl(0, "StatusLine", { bg = "NONE", fg = "NONE" })
	set_hl(0, "StatusLineNC", { bg = "NONE", fg = "NONE" })
	set_hl(0, "StatusLineDim", { fg = "#6272a4", ctermfg = 8 })
	set_hl(0, "StatusLineText", { bg = "NONE", fg = "NONE" })
	set_hl(0, "StatusLineBold", { bg = "NONE", fg = "NONE", bold = true })

	set_hl(0, "StatusLineLspError", { fg = "#ff5555", ctermfg = 9, bold = true })
	set_hl(0, "StatusLineLspWarn", { fg = "#f1fa8c", ctermfg = 11, bold = true })
end

local function format_file_path()
	local full = vim.fn.expand("%:~:.")
	if full == "" then
		return "[No Name]"
	end

	local parts = vim.split(full, "/", { plain = true })
	if #parts <= 2 then
		return full
	end

	return string.format("…/%s/%s", parts[#parts - 1], parts[#parts])
end

function M.render()
	local sep = "%#StatusLineDim# · "
	local ft = vim.bo.filetype
	local git_status = vim.b.gitsigns_status_dict
	local branch = git_status and git_status.head

	if ft == "oil" then
		local oil = package.loaded["oil"]
		local dir = (oil and oil.get_current_dir()) or vim.fn.expand("%")
		dir = vim.fn.fnamemodify(dir, ":~:.")
		if dir == "" then
			dir = "./"
		end

		local left = string.format("%%#StatusLineBold#oil%s%%#StatusLineText#%s", sep, dir)
		if branch and branch ~= "" then
			left = left .. sep .. string.format("%%#StatusLineText#%s", branch)
		end

		local right = "%#StatusLineText#oil"
		return left .. "%=" .. right
	end

	local left_parts = {}

	local formatted_path = format_file_path()
	local target_str = ""
	if branch and branch ~= "" then
		target_str = string.format("%%#StatusLineBold#%s:%%#StatusLineBold#%s", branch, formatted_path)
	else
		target_str = string.format("%%#StatusLineBold#%s", formatted_path)
	end

	if vim.bo.readonly then
		target_str = target_str .. "%#StatusLineDim#:readonly"
	end
	table.insert(left_parts, target_str)

	local mode_code = vim.api.nvim_get_mode().mode
	local mode_str = modes[mode_code]
	if mode_str then
		table.insert(left_parts, string.format("%%#StatusLineDim#%s", mode_str))
	end

	local center_parts = {}
	if vim.bo.modified then
		table.insert(center_parts, "%#StatusLineDim#modified")
	end

	local is_input = mode_code:find("^[iR]") ~= nil
	if not is_input then
		local count_err = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		local count_warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		if count_err > 0 then
			local label = count_err == 1 and "1 error" or string.format("%d errors", count_err)
			table.insert(center_parts, string.format("%%#StatusLineLspError#%s", label))
		end
		if count_warn > 0 then
			local label = count_warn == 1 and "1 warning" or string.format("%d warnings", count_warn)
			table.insert(center_parts, string.format("%%#StatusLineLspWarn#%s", label))
		end
	end

	local right_parts = {}

	if ft ~= "" then
		table.insert(right_parts, string.format("%%#StatusLineText#%s", ft))
	end

	local enc = vim.bo.fileencoding
	if enc == "" then
		enc = vim.o.encoding
	end
	local fmt = vim.bo.fileformat
	if (enc ~= "utf-8" and enc ~= "") or fmt ~= "unix" then
		local non_std = string.format("%s:%s", enc, fmt)
		table.insert(right_parts, string.format("%%#StatusLineLspWarn#%s", non_std))
	end

	table.insert(right_parts, "%#StatusLineText#%l:%c")
	table.insert(right_parts, "%#StatusLineText#%p%%")

	local left_out = table.concat(left_parts, sep)
	local center_out = table.concat(center_parts, sep)
	local right_out = table.concat(right_parts, sep)

	return left_out .. "%=" .. center_out .. "%=" .. right_out
end

function M.setup()
	setup_highlights()
	vim.opt.statusline = "%!v:lua.require('config.statusline').render()"

	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = "*",
		callback = setup_highlights,
	})
end

return M
