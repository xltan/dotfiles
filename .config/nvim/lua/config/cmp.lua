local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
vim.opt.complete = ""

local check_backspace = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	completion = { completeopt = "menu,menuone,noinsert" },
	sorting = {
		comparators = {
			-- The built-in comparators:
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			require("cmp-under-comparator").under,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	formatting = {
		format = function(entry, vim_item)
			if vim.tbl_contains({ "path" }, entry.source.name) then
				local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
				if icon then
					vim_item.kind = icon
					vim_item.kind_hl_group = hl_group
					return vim_item
				end
			end
			return lspkind.cmp_format({ with_text = false })(entry, vim_item)
		end,
	},

	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = function()
			if cmp.visible() then
				cmp.select_prev_item()
			else
				cmp.complete()
			end
		end,
		["<C-n>"] = function()
			if cmp.visible() then
				cmp.select_next_item()
			else
				cmp.complete()
			end
		end,
		["<C-e>"] = function(fallback)
			fallback()
		end,
		["<C-j>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				luasnip.expand()
			end
		end, { "i", "s" }),
		["<C-k>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<tab>"] = function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
			elseif luasnip.expandable() then
				luasnip.expand()
			else
				-- if check_backspace() then
				-- 	cmp.complete()
				-- else
				fallback()
				-- end
			end
		end,
	}),
	sources = {
		{ name = "luasnip", keyword_length = 2 },
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lsp" },
		{ name = "path", keyword_length = 1 },
		{ name = "buffer", keyword_length = 3 },
		{ name = "crates" },
	},
})

cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, { { name = "buffer" } }),
})
