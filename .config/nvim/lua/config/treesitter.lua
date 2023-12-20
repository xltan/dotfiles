require("nvim-treesitter.configs").setup({
	sync_install = false,
	auto_install = true,

	highlight = {
		enable = true, -- false will disable the whole extension
		disable = function(_, buf)
			local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
			if line and #line > 1000 then
				return true
			end
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
	incremental_selection = {
		enable = false,
		-- keymaps = {
		-- 	init_selection = "gnn",
		-- 	node_incremental = "grn",
		-- 	scope_incremental = "grc",
		-- 	node_decremental = "grm",
		-- },
	},
	indent = { enable = true, disable = { "yaml" } },
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
			goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
		},
	},
})
