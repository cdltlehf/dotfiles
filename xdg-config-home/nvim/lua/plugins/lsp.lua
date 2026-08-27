-- https://neovim.io/doc/user/lsp.html#lsp-defaults
-- :help vim.lsp.config()
-- :help vim.diagnostic.config
-- :help g:lsp_diagnostics_signs_enabled

local glyphs = vim.env.LC_TERMINAL_GLYPHS or "ascii"
local diagnostic_signs = {
	[vim.diagnostic.severity.ERROR] = "E",
	[vim.diagnostic.severity.WARN] = "W",
	[vim.diagnostic.severity.INFO] = "I",
	[vim.diagnostic.severity.HINT] = "H",
}

if glyphs == "nerdfont" then
	diagnostic_signs = {
		[vim.diagnostic.severity.ERROR] = "",
		[vim.diagnostic.severity.WARN] = "",
		[vim.diagnostic.severity.INFO] = "",
		[vim.diagnostic.severity.HINT] = "",
	}
elseif glyphs == "unicode" then
	diagnostic_signs = {
		[vim.diagnostic.severity.ERROR] = "●",
		[vim.diagnostic.severity.WARN] = "▲",
		[vim.diagnostic.severity.INFO] = "◆",
		[vim.diagnostic.severity.HINT] = "○",
	}
end

vim.diagnostic.config({
	virtual_text = {
		source = "if_many",
	},
	signs = {
		text = diagnostic_signs,
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
		vim.keymap.set("n", "<c-k>", function()
			vim.lsp.buf.format({ async = true })
		end, { buffer = args.buf })
	end,
})

-- Refer: https://microsoft.github.io/language-server-protocol/implementors/servers/
vim.lsp.config["ruff"] = {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
}

vim.lsp.config["ty"] = {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
}

vim.lsp.config["rust_analyzer"] = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git" },
	settings = {
		["rust-analyzer"] = {
			checkOnSave = { command = "clippy" },
		},
	},
}

vim.lsp.config["clangd"] = {
	cmd = { "clangd", "--fallback-style=google" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	root_markers = { ".clangd", ".clang-format", "compile_commands.json", "compile_flags.txt", ".git" },
}

vim.lsp.config["denols"] = {
	cmd = { "deno", "lsp" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "deno.json", "deno.jsonc" },
}

vim.lsp.config["taplo"] = {
	cmd = { "taplo", "lsp", "stdio" },
	filetypes = { "toml" },
	root_markers = { ".taplo.toml", "taplo.toml", "Cargo.toml", ".git" },
}

vim.lsp.config["marksman"] = {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	root_markers = { ".marksman.toml", ".git" },
}

vim.lsp.config["html"] = {
	cmd = { "html-languageserver", "--stdio" },
	filetypes = { "html" },
	root_markers = { "package.json", ".git" },
}

vim.lsp.config["bashls"] = {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash", "zsh" },
	root_markers = { ".git" },
}

vim.lsp.config["lua_ls"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
			telemetry = { enable = false },
		},
	},
}

vim.lsp.config["yamlls"] = {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	root_markers = { ".git" },
}

vim.lsp.config["vimls"] = {
	cmd = { "vim-language-server", "--stdio" },
	filetypes = { "vim" },
	root_markers = { ".git" },
}

local servers = {
	"ruff",
	"ty",
	"rust_analyzer",
	"clangd",
	"denols",
	"taplo",
	"marksman",
	"html",
	"bashls",
	"lua_ls",
	"yamlls",
	"vimls",
}

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end
