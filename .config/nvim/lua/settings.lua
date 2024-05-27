vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

local vim_home = vim.fn.fnamemodify(vim.env.MYVIMRC, ":p:h")

local opts = {
	hlsearch = true,
	wrap = false,
	showmode = false,
	autoindent = true,
	smarttab = true,
	gdefault = true,
	hidden = true,
	exrc = true,
	autowrite = true,
	autoread = true,
	backup = false,
	undofile = true,
	ignorecase = true,
	smartcase = true,
	nu = true,
	rnu = true,
	cursorline = true,
	termguicolors = true,
	backupdir = vim_home .. "/.swap",
	directory = vim_home .. "/.swap//",
	undodir = vim_home .. "/.undo",
	listchars = "tab:| ,eol:¬",
	scrolloff = 3,
	timeoutlen = 500,
	tagcase = "match",
	scl = "number",
	background = "dark",
	encoding = "utf-8",
	fileencoding = "utf-8",
	mouse = "a",
	inccommand = "nosplit",
	cinoptions = ":0,g0,(0,Ws,l1",
	pumheight = 20,
	grepprg = "rg --vimgrep",
}

for k, v in pairs(opts) do
	vim.o[k] = v
end

local opt = vim.opt
opt.shortmess:append("c")
opt.mps:append("<:>")
opt.formatoptions:append("j")
opt.shada:prepend("'500")
opt.diffopt:append("vertical,algorithm:patience,indent-heuristic")

vim.diagnostic.config({ virtual_text = false })

vim.filetype.add({
	extension = {
		sh = "bash",
		json = "jsonc",
		template = "template",
	},
	filename = {
		["go.mod"] = "gomod",
		[".clang-format"] = "yaml",
	},
	pattern = {
		["Dockerfile.*"] = "dockerfile",
	},
})
