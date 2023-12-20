local fzf_lua = require("fzf-lua")

fzf_lua.setup({
	winopts = {
		height = 0.5,
		preview = {
			delay = 50,
		},
	},
	lsp = {
		jump_to_single_result = true,
	},
	tags = {
		actions = {
			["ctrl-g"] = false,
			["ctrl-y"] = { require("fzf-lua.actions").grep_lgrep },
		},
	},
})

vim.lsp.handlers["textDocument/codeAction"] = fzf_lua.lsp_code_actions
vim.lsp.handlers["textDocument/references"] = fzf_lua.lsp_references
vim.lsp.handlers["textDocument/definition"] = fzf_lua.lsp_definitions
vim.lsp.handlers["textDocument/declaration"] = fzf_lua.lsp_declarations
vim.lsp.handlers["textDocument/typeDefinition"] = fzf_lua.lsp_typedefs
vim.lsp.handlers["textDocument/implementation"] = fzf_lua.lsp_implementations
vim.lsp.handlers["textDocument/documentSymbol"] = fzf_lua.lsp_document_symbols
vim.lsp.handlers["workspace/symbol"] = fzf_lua.lsp_workspace_symbols

local nmap = function(key, func)
	vim.keymap.set("n", key, func)
end

nmap("<leader>f", fzf_lua.files)
nmap("<leader>lo", function()
	fzf_lua.oldfiles({ cwd_only = true, include_current_session = true, cwd = vim.loop.cwd() })
end)
nmap("<leader>r", function()
	fzf_lua.oldfiles({ include_current_session = true, cwd = vim.loop.cwd() })
end)
nmap("<leader>F", function()
	fzf_lua.files({ cwd = vim.fn.expand("%:p:h") })
end)
nmap("<leader>ll", fzf_lua.lines)
nmap("<leader>s", fzf_lua.lsp_document_symbols)
nmap("<leader>S", fzf_lua.lsp_workspace_symbols)
nmap("<leader>lp", function()
	fzf_lua.files({ cwd = "~/.config/nvim" })
end)
nmap("<leader>:", fzf_lua.commands)
nmap("<leader>b", fzf_lua.buffers)

nmap("<leader>;", fzf_lua.command_history)
nmap("<leader>/", fzf_lua.search_history)
nmap("<leader>lg", fzf_lua.git_files)
nmap("<leader>lj", fzf_lua.btags)

nmap("<leader>gp", fzf_lua.grep)
nmap("<leader>gt", fzf_lua.tags_live_grep)

-- fzf_lua.register_ui_select()
