set nocompatible
filetype off                  " required
" set the runtime path to include Vundle and initialize
if(!has("win32"))
  set rtp+=/usr/local/opt/fzf
endif

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-rsi'

Plugin 'altercation/vim-colors-solarized'

Plugin 'google/vim-searchindex'

Plugin 'junegunn/vim-easy-align'
if(has("win32"))
  Plugin 'FelikZ/ctrlp-py-matcher'
  Plugin 'ctrlpvim/ctrlp.vim'
  Plugin 'adonis0147/ctrlp-cIndexer'
else
  Plugin 'junegunn/fzf.vim'
  Plugin 'tpope/vim-fugitive'
endif

Plugin 'dyng/ctrlsf.vim'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'xltan/pyflakes-vim'
Plugin 'vim-scripts/actionscript.vim--Leider'

Plugin 'ludovicchabant/vim-gutentags'
call vundle#end()

filetype plugin indent on

set t_Co=256

syntax enable

set background=dark

set cursorline

let g:solarized_italic = 0
let g:solarized_bold = 0 
let g:solarized_termcolors = 256 

colors solarized

set guioptions=
set backspace=indent,eol,start

set autoindent
set noexpandtab
set tabstop=4
set smarttab
" set smarttab

set laststatus=2
set wildmenu
set hidden
set autowrite
set autoread

set backupdir=$HOME/.swap
set directory=$HOME/.swap//
set undodir=$HOME/.swap
set undofile

set nobackup

set noimd
set imi=2
set ims=2

set hlsearch
set incsearch

set ruler
set nu

if !empty(&viminfo)
  set viminfo^=!,%1024
endif

set formatoptions+=j " Delete comment character when joining commented lines

set ignorecase
set smartcase

set tags=tags,../tags,../../tags,../../../tags

if !&scrolloff
  set scrolloff=3
endif
if !&sidescrolloff
  set sidescrolloff=5
endif

set encoding=utf-8
set fileencoding=utf-8
set foldmethod=syntax
set nofoldenable

let mapleader = ","

nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>

if(has("win32"))
  set guifont=Monaco:h9
  nmap <C-e> :silent !start explorer %:p:h:gs?\/?\\\\\\?<CR>
  
  " ctrlp
  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_cmd = 'CtrlP'
  " Setup some default ignores
  let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](\.(git|hg|svn)|\_site|packedIpa|extension|lib|Lib|multi_target_plists|Lib|intern|bt2code|(server\\com)|(\v\.(egg|app)))$',
  \ 'file': '\v\.(fxl|cache|ktx|pvr|tga|sfx|fx|pyc|exe|so|dll|class|png|jpg|jpeg)$',
  \}
  let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
  let g:ctrlp_working_path_mode = 'w'
  let g:ctrlp_lazy_udpate = 50
  let g:ctrlp_max_files = 0
  let g:ctrlp_max_depth = 40
  let g:ctrlp_use_caching = 1
  let g:ctrlp_clear_cache_on_exit = 0
  " let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:20'
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  " let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
  let g:cIndexer_custom_ignore_extensions = ['sfx', 'gim', 'gis', 'ags', 'mesh', 'mtg', 'ter', 'cache']
  let g:cIndexer_custom_ignore_dirs = ['_site', 'engine', 'packedIpa', 'extension', 'lib', 'Lib', 'multi_target_plist', 'intern', '.app', '.egg', 'ai', 'example.*', '_backup']
  nmap <leader>r :CtrlPMRUFiles<CR>
else
  set guifont=Monaco\ for\ Powerline:h12
  nmap <C-e> :sh<CR>
  
  " fzf
  nmap <leader>b :BTags<cr>
  nmap <leader>v :Buffers<cr>
  nmap <leader>r :History<cr>
  nmap <leader>t :Tags<cr>
  nmap <leader>a :Ag 
  nmap <c-p> :Files<cr>
  
  python from powerline.vim import setup as powerline_setup
  python powerline_setup()
  python del powerline_setup
endif

let g:ctrlsf_ackprg="ag"
vmap     <leader>f <Plug>CtrlSFVwordPath
nmap     <leader>f <Plug>CtrlSFCwordPath
nnoremap <leader>q :CtrlSFToggle<CR>
inoremap <leader>q <Esc>:CtrlSFToggle<CR>

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

nnoremap <S-L> <C-W>w
nnoremap <S-H> <C-W>W

"make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

nnoremap <C-L> :nohlsearch<CR>
nnoremap <C-n> :sav <C-R>=fnameescape(expand('%:h')).'\'<cr>

augroup vimrc_autocmd
  au GUIEnter * simalt ~x
  au BufRead,BufNewFile *.as set filetype=actionscript
  au filetype python setlocal noexpandtab tabstop=4 shiftwidth=4
  au filetype actionscript setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END

cabbrev ics client/script
cabbrev ict client/tools
cabbrev icr client/res
cabbrev is server
cabbrev ccn c:\g4\trunk\

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
nmap <leader>e :Ex<CR>

noremap <C-W>		:q<CR>
vnoremap <C-W>		<C-C>:q<CR>
inoremap <C-W>		<ESC>:q<CR>
nnoremap Y y$

" markdown
nnoremap <leader>1 m`yypVr=``
nnoremap <leader>2 m`yypVr-``
nnoremap <leader>3 m`^i### <esc>``4l
nnoremap <leader>4 m`^i#### <esc>``5l
nnoremap <leader>5 m`^i##### <esc>``6l

