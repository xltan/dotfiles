-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
-- 	pattern = "NvimTree_*",
-- 	callback = function()
-- 		local layout = vim.api.nvim_call_function("winlayout", {})
-- 		if
-- 			layout[1] == "leaf"
-- 			and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
-- 			and layout[3] == nil
-- 		then
-- 			vim.cmd("confirm quit")
-- 		end
-- 	end,
-- })
-- vim.keymap.set("n", "-", ":NvimTreeFindFile!<cr>", { noremap = true, silent = true })
-- vim.keymap.set("n", "_", ":NvimTreeToggle<cr>", { noremap = true, silent = true })

require("nvim-tree").setup({
	hijack_netrw = false,
	update_to_buf_dir = { enable = false },
	view = {
		width = 35,
		hide_root_folder = true,
		side = "right",
		mappings = {
			custom_only = false,
			list = {
				{ key = "-", action = "close_node" },
				{ key = "u", action = "dir_up" },
				{ key = "<", action = "close_node" },
				{ key = ">", action = "edit_no_picker" },
				{ key = "<CR>", action = "edit_no_picker" },
				{ key = "K", action = "prev_sibling" },
				{ key = "J", action = "next_sibling" },
				{ key = "{", action = "first_sibling" },
				{ key = "}", action = "last_sibling" },
			},
		},
	},
	live_filter = {
		prefix = ": ",
		always_show_folders = false,
	},
	sync_root_with_cwd = true,
	open_on_setup = false,
	open_on_setup_file = false,
	ignore_buffer_on_setup = false,
	ignore_ft_on_setup = {
		"gitcommit",
		"zsh",
		"man",
	},
	update_focused_file = {
		enable = true,
		update_root = false,
		ignore_list = {
			-- "help",
			-- "gitcommit",
			-- "man",
		},
	},
})
