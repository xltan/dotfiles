local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.ruff_format,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.terraform_fmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.shfmt.with({
			filetypes = { "sh", "bash", "zsh" },
			extra_args = {
				"-bn",
				"-ci",
				"-i",
				"2",
				"-s",
				"-sr",
			},
		}),
	},
	on_attach = function(client)
		if client.server_capabilities.documentFormattingProvider then
			vim.cmd([[
      augroup LspFormatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
      augroup END
      ]])
		end
	end,
})
