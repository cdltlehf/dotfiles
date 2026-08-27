local statusline = {}

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
	local set_highlight = vim.api.nvim_set_hl
	set_highlight(0, "StatusLine", { bg = "NONE", fg = "NONE" })
	set_highlight(0, "StatusLineNC", { bg = "NONE", fg = "NONE" })
	set_highlight(0, "StatusLineDim", { fg = "DarkGray", ctermfg = 8 })
	set_highlight(0, "StatusLineText", { bg = "NONE", fg = "NONE" })
	set_highlight(0, "StatusLineBold", { bg = "NONE", fg = "NONE" })
	set_highlight(0, "StatusLineLspError", { fg = "Red", ctermfg = 9 })
	set_highlight(0, "StatusLineLspWarn", { fg = "Yellow", ctermfg = 11 })
end

local function format_file_path()
	local full_path = vim.fn.expand("%:~:.")
	if full_path == "" then
		return "[No Name]"
	end

	local charset = vim.env.CHARSET or "ascii"
	local ellipsis = (charset == "ascii") and "..." or "…"

	local git_status = vim.b.gitsigns_status_dict
	local git_root = git_status and git_status.root or vim.fs.root(0, ".git")

	if git_root then
		local repo_name = vim.fs.basename(git_root)
		local file_abs_path = vim.fn.expand("%:p")
		local subpath = file_abs_path:sub(#git_root + 2)

		if subpath == "" then
			return repo_name
		end

		local parts = vim.split(subpath, "/", { plain = true })
		if #parts > 2 then
			return string.format("%s/%s/%s/%s", repo_name, ellipsis, parts[#parts - 1], parts[#parts])
		else
			return string.format("%s/%s", repo_name, subpath)
		end
	else
		local parts = vim.split(full_path, "/", { plain = true })
		if #parts > 3 then
			return string.format("%s/%s/%s", ellipsis, parts[#parts - 1], parts[#parts])
		else
			return full_path
		end
	end
end

function statusline.render()
	local charset = vim.env.CHARSET or "ascii"
	local separator = (charset == "ascii") and "%#StatusLineDim# . " or "%#StatusLineDim# · "
	local filetype = vim.bo.filetype
	local git_status = vim.b.gitsigns_status_dict
	local branch_name = git_status and git_status.head

	if filetype == "oil" then
		local oil = package.loaded["oil"]
		local directory = (oil and oil.get_current_dir()) or vim.fn.expand("%")
		directory = vim.fn.fnamemodify(directory, ":~:.")
		if directory == "" then
			directory = "./"
		end

		local left = string.format("%%#StatusLineBold#oil%s%%#StatusLineText#%s", separator, directory)
		if branch_name and branch_name ~= "" then
			left = left .. separator .. string.format("%%#StatusLineBold#%s", branch_name)
		end

		local right = "%#StatusLineText#oil"
		return left .. "%=" .. right
	end

	local left_parts = {}

	local formatted_path = format_file_path()
	local target_string = string.format("%%#StatusLineBold#%s", formatted_path)
	if branch_name and branch_name ~= "" then
		target_string = target_string .. separator .. string.format("%%#StatusLineBold#%s", branch_name)
	end

	if vim.bo.readonly then
		target_string = target_string .. "%#StatusLineDim#:readonly"
	end
	table.insert(left_parts, target_string)

	local mode_code = vim.api.nvim_get_mode().mode
	local mode_string = modes[mode_code]
	if mode_string then
		table.insert(left_parts, string.format("%%#StatusLineDim#%s", mode_string))
	end

	local center_parts = {}
	if vim.bo.modified then
		table.insert(center_parts, "%#StatusLineDim#modified")
	end

	local is_input_mode = mode_code:find("^[iR]") ~= nil
	if not is_input_mode then
		local error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		local warning_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		if error_count > 0 then
			local label = error_count == 1 and "1 error" or string.format("%d errors", error_count)
			table.insert(center_parts, string.format("%%#StatusLineLspError#%s", label))
		end
		if warning_count > 0 then
			local label = warning_count == 1 and "1 warning" or string.format("%d warnings", warning_count)
			table.insert(center_parts, string.format("%%#StatusLineLspWarn#%s", label))
		end
	end

	local right_parts = {}

	if filetype ~= "" then
		table.insert(right_parts, string.format("%%#StatusLineText#%s", filetype))
	end

	local file_encoding = vim.bo.fileencoding
	if file_encoding == "" then
		file_encoding = vim.o.encoding
	end
	local file_format = vim.bo.fileformat
	if (file_encoding ~= "utf-8" and file_encoding ~= "") or file_format ~= "unix" then
		local non_standard_encoding = string.format("%s:%s", file_encoding, file_format)
		table.insert(right_parts, string.format("%%#StatusLineLspWarn#%s", non_standard_encoding))
	end

	table.insert(right_parts, "%#StatusLineText#%l:%c")
	table.insert(right_parts, "%#StatusLineText#%p%%")

	local left_output = table.concat(left_parts, separator)
	local center_output = table.concat(center_parts, separator)
	local right_output = table.concat(right_parts, separator)

	if center_output == "" then
		return left_output .. "%=" .. right_output
	end

	local left_width = vim.api.nvim_eval_statusline(left_output, { winid = 0 }).width
	local center_width = vim.api.nvim_eval_statusline(center_output, { winid = 0 }).width
	local total_width = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)

	local padding_length = math.floor((total_width - center_width) / 2) - left_width
	local padding = padding_length > 0 and string.rep(" ", padding_length) or " "

	return left_output .. padding .. center_output .. "%=" .. right_output
end

function statusline.setup()
	setup_highlights()
	vim.opt.statusline = "%!v:lua.require('config.statusline').render()"

	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = "*",
		callback = setup_highlights,
	})
end

return statusline
