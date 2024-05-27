-- vim.api.nvim_set_hl(0, "VertSplit", { fg = "#334455" })
vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { link = "Comment" })

require("lualine").setup({
	options = {
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = false,
	},
	sections = {
		lualine_a = {},
		lualine_b = { {
			"mode",
			fmt = function(str)
				return str:sub(1, 1)
			end,
		} },
		lualine_c = {
			{
				"filename",
				file_status = true, -- Displays file status (readonly status, modified status)
				path = 1, -- 0: Just the filename
				shorting_target = 40, -- Shortens path to leave 40 spaces in the window
				symbols = {
					modified = "[+]", -- Text to show when the file is modified.
					readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
					unnamed = "[NN]", -- Text to show for unnamed buffers.
				},
			},
			"diff",
			"diagnostics",
			"aerial",
		},
		lualine_x = {
			"branch",
		},

		lualine_y = { { "location", padding = 0 } },
		lualine_z = {},
	},
	inactive_sections = {
		lualine_c = {
			{
				"filename",
				file_status = true, -- Displays file status (readonly status, modified status)
				path = 1, -- 0: Just the filename
				shorting_target = 40, -- Shortens path to leave 40 spaces in the window
				symbols = {
					modified = "[+]", -- Text to show when the file is modified.
					readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
					unnamed = "[NN]", -- Text to show for unnamed buffers.
				},
			},
			"diff",
			"diagnostics",
		},
	},
	refresh = { -- sets how often lualine should refreash it's contents (in ms)
		statusline = 100,
	},
})
