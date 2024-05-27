local lazy_file_event = "VeryLazy"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "folke/lazy.nvim", version = false },
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "nvim-lua/plenary.nvim", lazy = true },
	{
		"EdenEast/nightfox.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme nightfox]])
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			vim.g.skip_ts_context_commentstring_module = true
			require("config.treesitter")
			require("ts_context_commentstring").setup({})
		end,
		event = lazy_file_event,
	},
	{
		"tpope/vim-rsi",
		"tpope/vim-abolish",
		"tpope/vim-repeat",
		"tpope/vim-eunuch",
		"tpope/vim-projectionist",
		"tpope/vim-dotenv",
		"kana/vim-niceblock",
		"christoomey/vim-tmux-navigator",
		-- "justinmk/vim-dirvish",
	},
	{
		"tpope/vim-unimpaired",
		event = lazy_file_event,
	},
	{
		"sindrets/diffview.nvim",
		event = lazy_file_event,
	},
	{
		"tpope/vim-fugitive",
		dependencies = {
			"tpope/vim-rhubarb",
			"shumphrey/fugitive-gitlab.vim",
			"junegunn/gv.vim",
			{
				"skanehira/getpr.vim",
				config = function()
					vim.cmd([[
						map <leader>gp <Plug>(getpr-open)
					]])
				end,
			},
		},
		config = function()
			vim.g.fugitive_gitlab_domains = { "https://git.garena.com" }
		end,
		event = lazy_file_event,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = true,
		event = lazy_file_event,
	},
	{
		"kylechui/nvim-surround",
		config = function()
			require("config.surround")
		end,
		event = lazy_file_event,
	},
	{ "AndrewRadev/linediff.vim", cmd = "Linediff" },
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("config.lualine")
		end,
		event = "VeryLazy",
	},
	{
		"stevearc/oil.nvim",
		event = lazy_file_event,
		config = true,
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
		},
	},
	{
		"echasnovski/mini.ai",
		config = true,
		event = lazy_file_event,
	},
	{
		"echasnovski/mini.indentscope",
		config = function()
			require("mini.indentscope").setup({
				-- Draw options
				draw = {
					-- Delay (in ms) between event and start of drawing scope indicator
					delay = 1000,
					-- Symbol priority. Increase to display on top of more symbols.
					priority = 2,
				},
			})
		end,
		event = lazy_file_event,
	},
	{
		"echasnovski/mini.comment",
		config = true,
		event = lazy_file_event,
	},
	{
		"machakann/vim-swap",
		init = function()
			vim.g.swap_no_default_key_mappings = 1
			vim.cmd([[
				map z[ <Plug>(swap-prev)
				map z] <Plug>(swap-next)
			]])
		end,
		event = lazy_file_event,
	},
	{
		"vim-test/vim-test",
		config = function()
			vim.cmd([[
				let test#rust#cargotest#executable = 'cargo test -q --message-format short'
				nnoremap <silent> t<CR> :TestNearest<CR>
				nnoremap <silent> t<C-s> :TestSuite<CR>
				nnoremap <silent> t<C-f> :TestFile<CR>
				nnoremap <silent> t<C-l> :TestLast<CR>
				nnoremap <silent> t<C-g> :TestVisit<CR>
				function! SlimeStrategy(cmd)
					let extra = ""
					if &filetype == "rust"
            if a:cmd =~ " -- "
              let extra = " --nocapture"
            else
              let extra = " -- --nocapture"
            endif
					elseif &filetype == "python"
					  let extra = " -s"
					endif
					exec 'SlimeSend1 ' . a:cmd . extra
				endfunction
				let g:test#custom_strategies = {'slime': function('SlimeStrategy')}
				let g:test#strategy = 'slime'
				let g:test#python#runner = 'pytest'
      ]])
		end,
		cmd = {
			"Test",
			"TestNearest",
			"TestSuite",
			"TestFile",
			"TestLast",
			"TestVisit",
		},
	},
	{
		"windwp/nvim-autopairs",
		dependencies = "hrsh7th/nvim-cmp",
		config = function()
			require("nvim-autopairs").setup()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
		event = "InsertEnter",
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "zackhsi/fzf-tags" },
		config = function()
			vim.cmd([[
				let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.5, 'highlight': 'Comment' } }
				nnoremap <C-]> <Plug>(fzf_tags)
			]])
			require("config.fzf-lua")
		end,
		event = lazy_file_event,
	},
	{
		"keaising/im-select.nvim",
		config = true,
		event = lazy_file_event,
	},
	{
		"mbbill/undotree",
		config = function()
			vim.cmd([[
	    		nnoremap <silent> <leader>u :UndotreeToggle<CR>
	    	]])
		end,
		event = lazy_file_event,
	},
	{
		"ludovicchabant/vim-gutentags",
		config = function()
			vim.g.gutentags_add_default_project_roots = 0
			vim.g.gutentags_project_root = { "tags" } -- '.git', '.svn', '.gutctags', '.clang-format', '.ignore']
			vim.g.gutentags_exclude_project_root = {
				"/usr/local",
				vim.env.HOME,
				vim.env.HOME .. "/Documents",
			}
			vim.g.gutentags_ctags_exclude = {
				"testdata",
				"build",
				"bin",
				"vendor",
				"tags",
				"github.com",
				"auth_cli",
				"*_test.go",
				"*.json",
				"*.pb.go",
				"*_gen.go",
			}
		end,
	},
	{
		"LintaoAmons/easy-commands.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"ggandor/leap.nvim",
		config = function()
			local leap_all_windows = function()
				local target_windows = require("leap.util").get_enterable_windows()
				table.insert(target_windows, vim.fn.win_getid())
				require("leap").leap({ target_windows = target_windows })
			end
			for _, _each in ipairs({
				{ { "n" }, "s", "<Plug>(leap-forward-to)" },
				{ { "n" }, "S", "<Plug>(leap-backward-to)" },
				{ { "x", "o" }, "z", "<Plug>(leap-forward-to)" },
				{ { "x", "o" }, "Z", "<Plug>(leap-backward-to)" },
				-- { { "n", "x", "o" }, "gs", "<Plug>(leap-cross-window)" },
				{ { "n" }, "gs", leap_all_windows },
			}) do
				local modes, lhs, rhs = unpack(_each)
				for _, mode in ipairs(modes) do
					if vim.fn.mapcheck(lhs, mode) == "" then
						vim.keymap.set(mode, lhs, rhs, { silent = true })
					else
					end
				end
			end
		end,
		event = lazy_file_event,
	},
	{
		"justinmk/vim-gtfo",
		config = function()
			vim.cmd([[
				func! g:OPEN_TERM(direction, dir, other) abort "{{{
					if a:dir == 0
					  let dir = expand("%:p:h", 1)
					else
					  let dir = getcwd()
					endif
					if !isdirectory(dir) "this happens if a directory was deleted outside of vim.
					  echo 'invalid/missing directory: '.dir
					  return
					endif
					if !(empty($TMUX))
					  call system("tmux " .  a:direction. " -c '" . dir . "' ". a:other)
					else
					  call gtfo#open#term(dir)
					endif
				endf
				nmap <silent> goS :<c-u>call OPEN_TERM('split-window', 0, '-l 20%')<cr>
				nmap <silent> gos :<c-u>call OPEN_TERM('split-window', 1, '-l 20%')<cr>
				nmap <silent> goV :<c-u>call OPEN_TERM('split-window -hb', 0, '-l 30%')<cr>
				nmap <silent> gov :<c-u>call OPEN_TERM('split-window -hb', 1, '-l 30%')<cr>
				nmap <silent> goC :<c-u>call OPEN_TERM('new-window', 0, '')<cr>
				nmap <silent> goc :<c-u>call OPEN_TERM('new-window', 1, '')<cr>
				if has('win32')
					nmap <silent> gox :SExec start %<CR>
				else
					nmap <silent> gox :SExec open %<CR>
				endif
				cmap %% <C-R>=fnameescape(expand('%:h'))<CR>/
				nmap gon :Duplicate
			]])
		end,
		event = lazy_file_event,
	},
	{
		"tyru/open-browser-github.vim",
		dependencies = {
			"tyru/open-browser.vim",
			config = function()
				vim.cmd([[
	        let g:openbrowser_search_engines = {
	        \ 'wiki': 'http://en.wikipedia.org/wiki/{query}',
	        \ 'cpan': 'http://search.cpan.org/search?query={query}',
	        \ 'devdocs': 'http://devdocs.io/#q={query}',
	        \ 'duckduckgo': 'http://duckduckgo.com/?q={query}',
	        \ 'github': 'http://github.com/search?q={query}',
	        \ 'google': 'http://google.com/search?q={query}',
	        \ 'rsd': 'https://docs.rs/releases/search?query={query}',
	        \ 'rust': 'https://doc.rust-lang.org/nightly/std/index.html?search={query}',
	        \ 'python': 'http://docs.python.org/dev/search.html?q={query}&check_keywords=yes&area=default',
	        \ 'go': 'https://pkg.go.dev/search?q={query}',
	        \ 'cpp': 'https://en.cppreference.com/mwiki/index.php?search={query}',
	        \ 'stackoverflow': 'https://stackoverflow.com/search?q={query}',
	        \ }
	        nmap gx <Plug>(openbrowser-smart-search)
	        vmap gx <Plug>(openbrowser-smart-search)
	      ]])
			end,
		},
		event = lazy_file_event,
	},
	{
		"dyng/ctrlsf.vim",
		config = function()
			vim.cmd([[
	      let g:ctrlsf_winsize = '35%'
	      let g:ctrlsf_backend = 'rg'
	      let g:ctrlsf_context = '-C 1'
	      " let g:ctrlsf_auto_preview = 1
	      " let g:ctrlsf_search_mode = 'sync'
	      let g:ctrlsf_auto_focus = {
	      \ "at" : "done",
	      \ "duration_less_than": 3000
	      \ }
	      let g:ctrlsf_mapping = {
	      \ "open": ["<CR>", "o", "<C-O>"],
	      \ "next": "<C-N>",
	      \ "prev": "<C-P>",
	      \ }
	      " let g:ctrlsf_populate_qflist = 1
	      function! g:CtrlSFAfterMainWindowInit()
	        setlocal wrap
	      endfunction
	      vmap <leader>gs <Plug>CtrlSFVwordExec
	      nmap <leader>gs <Plug>CtrlSFCwordPath<CR>
	      nmap <leader>gz <Plug>CtrlSFCwordPath -W<CR>
	      nmap <leader>gw :silent CtrlSF <c-r><c-w> %%<cr>
	      " nmap <leader>gw mz:silent grep <c-r><c-w> %% <cr>:copen<cr>:wincmd p<cr>`z
	      vmap <leader>gw mz:<c-u>exec ':silent grep ' . g:CtrlSFGetVisualSelection() . ' %%'<CR>:copen<cr>:wincmd p<cr>`z
	      nmap <leader>go :CtrlSFToggle<CR>
	    ]])
		end,
		event = lazy_file_event,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"kosayoda/nvim-lightbulb",
			{
				"mrcjkb/rustaceanvim",
				version = "^3",
				ft = { "rust" },
			},
			"akinsho/flutter-tools.nvim",
			"onsails/lspkind.nvim",
			{
				"nvimtools/none-ls.nvim",
				config = function()
					require("config.null")
				end,
			},
		},
		config = function()
			require("config.lsp")
		end,
		-- event = "VeryLazy",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"petertriho/cmp-git",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"lukas-reineke/cmp-under-comparator",
			{
				"github/copilot.vim",
				config = function()
					vim.g.copilot_no_tab_map = true
					vim.g.copilot_assume_mapped = true
					vim.cmd([[
	          imap <M-cr> <Esc>:Copilot<CR>
	          imap <silent><script><expr> <C-f> copilot#Accept("\<Right>")
	        ]])
				end,
			},
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("luasnip.loaders.from_snipmate").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
				dependencies = {
					"rafamadriz/friendly-snippets",
					"saadparwaiz1/cmp_luasnip",
				},
			},
		},
		config = function()
			require("config.cmp")
		end,
		event = "InsertEnter",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
		event = lazy_file_event,
	},
	{ "xltan/vim-goimpl", cmd = "GoImpl" },
	{ "leafgarland/typescript-vim", ft = { "typescript", "javascript" } },
	{
		"cespare/vim-toml",
		dependencies = {
			"saecki/crates.nvim",
			config = true,
		},
		ft = "toml",
	},
	{
		"bfrg/vim-cpp-modern",
		ft = { "c", "cpp" },
		config = function()
			vim.g.cpp_no_function_highlight = 1
			vim.g.cpp_simple_highlight = 1
		end,
	},

	{ "hashivim/vim-terraform", ft = "terraform" },
	{ "keith/swift.vim", ft = "swift" },
	{ "neoclide/jsonc.vim", ft = { "json", "jsonc" } },
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.g.mkdp_markdown_css = vim.fn.expand("~/.markdown.css")
			vim.g.mkdp_highlight_css = vim.fn.expand("~/.highlight.css")
		end,
		event = lazy_file_event,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
