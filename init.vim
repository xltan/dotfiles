set nocompatible
filetype off                  " required
" set the runtime path to include Vundle and initialize
if(!has("win32"))
  set rtp+=/usr/local/opt/fzf
endif

call plug#begin('~/vimfiles/bundle')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'

" Plug 'altercation/vim-colors-solarized'
" Plug 'rakr/vim-one'
" Plug 'joshdick/onedark.vim'
Plug 'rakr/vim-one'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'justinmk/vim-sneak'
Plug 'justinmk/vim-gtfo'

Plug 'junegunn/vim-easy-align'
Plug 'Valloric/ListToggle'

Plug 'maralla/completor.vim'
Plug 'maralla/validator.vim'
Plug 'vim-scripts/matchit.zip'

if(has("win32"))
  Plug 'FelikZ/ctrlp-py-matcher'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'adonis0147/ctrlp-cIndexer'
else
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-fugitive'
endif

Plug 'dyng/ctrlsf.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'vim-scripts/actionscript.vim--Leider'

Plug 'ludovicchabant/vim-gutentags'
call plug#end()

filetype plugin indent on
syntax enable
set t_Co=256

set background=dark

if has("termguicolors")
  set termguicolors
endif

" let g:solarized_italic = 0
" let g:solarized_bold = 0 
" let g:solarized_termcolors = 256 
" colors solarized

colors one
hi SignColumn guibg=#282c34
hi StatusLineNC guibg=#5c6370 guifg=#282c34

set cursorline
set guioptions=
set backspace=indent,eol,start

set autoindent
set noexpandtab
set tabstop=4
set smarttab

" set laststatus=2
set wildmenu
set hidden
set autowrite
set autoread

set backupdir=$HOME/.swap
set directory=$HOME/.swap//
set undodir=$HOME/.swap
set undofile

set nobackup

set hlsearch
set incsearch

set ruler
set nu

if !empty(&viminfo)
  set viminfo='100,<50,s10,h,%1024
endif

set formatoptions+=j " Delete comment character when joining commented lines

set ignorecase
set smartcase

set tags=tags,../tags,../../tags,../../../tags

set encoding=utf-8
set fileencoding=utf-8
set foldmethod=syntax
set nofoldenable

let mapleader = ","

nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>
if !&scrolloff
  set scrolloff=3
endif
if !&sidescrolloff
  set sidescrolloff=5
endif

if(has("win32"))
  " set renderoptions=type:directx,
  " 	\gamma:1.8,contrast:1,geom:1,
  " 	\renmode:5,taamode:1,level:1

  set guifont=Monaco:h9
  nmap <silent> <leader>w :e ~\iCloudDrive\notes\<CR>
  
  " ctrlp
  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_cmd = 'CtrlP'
  " Setup some default ignores
  " let g:ctrlp_custom_ignore = {
  " \ 'dir': '\v[\/](\.(git|hg|svn)|\_site|packedIpa|extension|lib|Lib|multi_target_plists|Lib|intern|bt2code|(server\\com)|(\v\.(egg|app)))$',
  " \ 'file': '\v\.(fxl|cache|ktx|pvr|tga|sfx|fx|pyc|exe|so|dll|class|png|jpg|jpeg)$',
  " \}
  " let g:ctrlp_user_command = 'rg . --files --color=never --glob ""'
  " let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
  let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
  let g:ctrlp_working_path_mode = 'w'
  let g:ctrlp_lazy_udpate = 100
  let g:ctrlp_max_files = 0
  let g:ctrlp_max_depth = 40
  let g:ctrlp_use_caching = 1
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_mruf_default_order = 1
  let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:30'
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  let g:cIndexer_custom_ignore_extensions = ['sfx', 'gim', 'gis', 'ags', 'mesh', 'mtg', 'ter', 'cache', 'scn'] 
  let g:cIndexer_custom_ignore_dirs = ['_site', 'extension', '_editer', 'packedIpa', 'extension', 'multi_target_plist', 'intern', 'ai', '_backup', 'server\/com']
  nmap <leader>r :CtrlPMRUFiles<CR>
  nmap <leader>b :CtrlPBufTag<CR>

  " nnoremap <c-]> :CtrlPtjump<cr>
  " vnoremap <c-]> :CtrlPtjumpVisual<cr>
  let g:ctrlp_tjump_only_silent = 1
  let g:ctrlp_tjump_skip_tag_name = 1
else
  nmap <silent> <leader>w :e ~\iCloudDrive\notes\<CR>
  set guifont=Monaco\ for\ Powerline:h12
  
  " fzf
  nmap <leader>r :History<cr>
  nmap <leader>b :BTags<cr>
  nmap <c-p> :Files<cr>
  
  python from powerline.vim import setup as powerline_setup
  python powerline_setup()
  python del powerline_setup

endif

let g:ctrlsf_ackprg="rg"

vmap     <leader>f <Plug>CtrlSFVwordPath
nmap     <leader>f <Plug>CtrlSFCwordPath
nnoremap <leader>s :CtrlSFToggle<CR>
inoremap <leader>s <Esc>:CtrlSFToggle<CR>

" similiar workaround for windows
" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-Q> "+gP
map <S-Insert> "+gP

cmap <C-Q> <C-R>+
cmap <S-Insert> <C-R>+

exe 'inoremap <script> <C-Q> <C-G>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <C-Q> ' . paste#paste_cmd['v']

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<ESC>:update<CR>

"make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

nnoremap <silent> <S-L> :nohl<CR>
nnoremap <C-n> :sav <C-R>=fnameescape(expand('%:h')).'\'<cr>

augroup vimrc_autocmd
  au BufRead,BufNewFile *.as set filetype=actionscript
  au filetype python setlocal noexpandtab tabstop=4 shiftwidth=4
  au filetype actionscript setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END

" easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

inoremap <C-^> <ESC><C-^><CR>
inoremap <C-K> <C-O>D

nnoremap Y y$

" ultisnips
let g:UltiSnipsSnippetDirectories=["UltiSnips", "mysnippets"]
let g:UltiSnipsDoHash=0

" markdown
nnoremap <leader>1 m`yypVr=``
nnoremap <leader>2 m`yypVr-``
nnoremap <leader>3 m`^i### <esc>``4l
nnoremap <leader>4 m`^i#### <esc>``5l
nnoremap <leader>5 m`^i##### <esc>``6l

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

if(has("win32"))
  map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
  let g:tortoise_svn_path = '"C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe"'
  function! SvnCommand(cmd, path)
  	execute 'silent! !start '.g:tortoise_svn_path. ' /command:'. a:cmd. ' /path:"'. a:path. '"'
  endfunction
  
  nnoremap <leader>tu :call SvnCommand('update /closeonend:3', expand('%:p'))<CR>
  nnoremap <leader>tw :call SvnCommand('commit /closeonend:3', expand('%:p'))<CR>
  nnoremap <leader>tc :call SvnCommand('commit /closeonend:3', g:g4_project_root)<CR>
  nnoremap <leader>tr :call SvnCommand('revert', expand('%:p'))<CR>
  nnoremap <leader>tl :call SvnCommand('log', expand('%:p'))<CR>
  nnoremap <leader>ta :call SvnCommand('add', expand('%:p'))<CR>
  nnoremap <leader>td :call SvnCommand('diff', expand('%:p'))<CR>
  nnoremap <leader>tb :call SvnCommand('blame /line:'. line('.'), expand('%:p'))<CR>
endif

let g:completor_min_chars = 3
let g:validator_permament_sign = 1

nmap r <Plug>Sneak_s
nmap R <Plug>Sneak_S
xmap r <Plug>Sneak_s
xmap R <Plug>Sneak_S
omap r <Plug>Sneak_s
omap R <Plug>Sneak_S

