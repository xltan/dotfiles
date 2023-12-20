local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = "",
	})
end

sign({ name = "DiagnosticSignError", text = "" })
sign({ name = "DiagnosticSignWarn", text = "" })
sign({ name = "DiagnosticSignHint", text = "" })
sign({ name = "DiagnosticSignInfo", text = "" })

vim.diagnostic.config({
	signs = {
		severity = { min = vim.diagnostic.severity.HINT },
	},
	underline = {
		severity = { min = vim.diagnostic.severity.HINT },
	},
	virtual_text = {
		severity = { min = vim.diagnostic.severity.WARN },
	},
})

local special_servers = {
	"rust_analyzer",
	"tsserver",
	"denols",
}

local normal_servers = {
	"bashls",
	"clangd",
	"cmake",
	"cssls",
	"cssmodules_ls",
	"kotlin_language_server",
	"emmet_ls",
	"quick_lint_js",
	"gopls",
	"html",
	"jsonls",
	"pyright",
	"svelte",
	"stylelint_lsp",
	"lua_ls",
	"tailwindcss",
	"taplo",
	"terraformls",
	"vimls",
	"yamlls",
	"denols",
	"zk",
}

local use_other_formating_servers = {
	"tsserver",
	"lua_ls",
	"stylelint_lsp",
	"jsonls",
	"html",
	"terraformls",
}

require("mason").setup({
	ui = {
		icons = {
			server_installed = "",
			server_pending = "",
			server_uninstalled = "",
		},
	},
})

require("mason-lspconfig").setup({
	ensure_installed = vim.fn.extend(special_servers, normal_servers),
})

local lspconfig = require("lspconfig")

local map = function(key, cmd, mod)
	mod = mod or "n"
	vim.keymap.set(mod, key, cmd, { noremap = true, buffer = true, silent = true })
end

local on_attach = function(client)
	map("[d", function()
		vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.HINT } })
	end)
	map("]d", function()
		vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.HINT } })
	end)
	map("gd", vim.lsp.buf.definition)
	map("K", vim.lsp.buf.hover)
	map("gi", vim.lsp.buf.implementation)
	map("gy", vim.lsp.buf.type_definition)
	map("gn", vim.lsp.buf.rename)
	map("gr", vim.lsp.buf.references)
	map("gh", vim.lsp.buf.signature_help)
	map("<leader>ca", vim.lsp.buf.code_action)
	map("v", "<cmd>lua vim.lsp.buf.range_code_action()<CR><Esc>", "v")
	map("gz", function()
		vim.lsp.buf.code_action({ context = { only = { "quickfix" }, apply = true } })
	end)
	map("<leader>wa", vim.lsp.buf.add_workspace_folder)
	map("<leader>wr", vim.lsp.buf.remove_workspace_folder)
	map("<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")

	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({timeout_ms=10000})' | update ]])
	if vim.tbl_contains(use_other_formating_servers, client.name) then
		client.server_capabilities.documentFormattingProvider = false
	end
	if client.server_capabilities.documentFormattingProvider then
		vim.cmd([[
    augroup LspFormatting
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
    augroup END
    ]])
	end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local default_options = {
	on_attach = on_attach,
	capabilities = capabilities,
}

require("flutter-tools").setup({
	lsp = default_options,
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
-- (optional) Customize the options passed to the server
local server_options = {
	lua_ls = {
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Setup your lua path
					path = runtime_path,
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = { enable = false },
			},
		},
	},
	cssmodules_ls = {
		on_attach = function(client)
			-- avoid accepting `definitionProvider` responses from this LSP
			client.server_capabilities.definitionProvider = false
			on_attach(client)
		end,
		-- capabilities = capabilities,
		-- init_options = {
		-- 	camelCase = true,
		-- },
	},
}

for _, server in ipairs(normal_servers) do
	lspconfig[server].setup(server_options[server] or default_options)
end

lspconfig.denols.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
})

lspconfig.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = lspconfig.util.root_pattern("package.json"),
	single_file_support = false,
})
