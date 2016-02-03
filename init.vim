set nocompatible
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'adonis0147/ctrlp-cIndexer'
Plugin 'FelikZ/ctrlp-py-matcher'
Plugin 'xltan/pyflakes-vim'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'itchyny/lightline.vim'
Plugin 'dyng/ctrlsf.vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'junegunn/vim-easy-align'
Plugin 'altercation/vim-colors-solarized'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'Valloric/YouCompleteMe'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'henrik/vim-indexed-search'
Plugin 'milkypostman/vim-togglelist'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'beyondmarc/glsl.vim'
Plugin 'beyondmarc/hlsl.vim'
Plugin 'jeroenbourgois/vim-actionscript'
call vundle#end()

filetype plugin indent on

set t_Co=256

syntax enable

set background=dark

let g:solarized_italic = 0
let g:solarized_bold = 0 
let g:solarized_termcolors = 256 

colors solarized

set guifont=Monaco\ for\ Powerline:h9
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


set backupdir=$HOME/.swap
set directory=$HOME/.swap//
set undodir=$HOME/.swap
set undofile

set hlsearch
set incsearch

set ruler
set nu

set autoread

if !empty(&viminfo)
  set viminfo^=!,%1024
endif

set formatoptions+=j " Delete comment character when joining commented lines

set ignorecase
set smartcase

set tags=./tags,tags,../tags,../../tags

if !&scrolloff
  set scrolloff=3
endif
if !&sidescrolloff
  set sidescrolloff=5
endif

set encoding=utf-8
set fileencoding=utf-8

let mapleader = ","

nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>

" lightline
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
	  \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

function! LightLineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightLineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

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

nmap <leader>e :Ex<cr>

" Easy bindings for its various modes
nmap <leader>b :CtrlPBufTag<cr>
nmap <leader>v :CtrlPBuffer<cr>
nmap <leader>r :CtrlPMRU<cr>
nmap <leader>m :CtrlPMixed<cr>
imap <C-P> <ESC>:CtrlPMRU<cr>

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 1

" my personal map
nmap <leader>tb :TagbarToggle<CR>

inoremap <C-^> <ESC><C-^><CR>

imap <C-a> <Home>
imap <C-e> <End>
nmap <C-e> :silent !start explorer %:p:h:gs?\/?\\\\\\?<CR>

set cursorline

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

" gist-vim
let g:gist_clip_command = 'putclip'
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1
let g:gist_post_private = 1

let g:ctrlsf_ackprg = 'ag'
let g:ctrlsf_default_root = 'project'

nmap     <leader>f :CtrlSF <C-R><C-W><space>
vmap     <leader>f <Plug>CtrlSFVwordPath
nmap     <leader>p :CtrlSF -filetype python <C-R><C-W><space>
nmap     <leader>a :CtrlSF -filetype actionscript <C-R><C-W><space>
nnoremap <leader>t :CtrlSFToggle<CR>

vnoremap // y/<C-R>"<CR>

"make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

set nobackup

let g:glsl_file_extensions = '*gl.vs,*gl.ps'
let g:glsl_default_version = 'glsl450'

let g:hlsl_file_extensions = '*.nfx,*.hlsl,*.vs,*.ps,*.fx'

cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabContextDefaultCompletionType = "<c-n>"

nnoremap <C-L> :nohlsearch<CR>
nnoremap <C-n> :sav <C-R>=fnameescape(expand('%:h')).'\'<cr>

augroup vimrc_autocmd
  au GUIEnter * simalt ~x
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  au! BufNewFile,BufRead *.as  setf actionscript
  au filetype python setlocal noexpandtab tabstop=4
  au filetype actionscript setlocal noexpandtab tabstop=4
augroup END

cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'close' : 'q')<CR>

cabbrev spy -filetype python
cabbrev sas -filetype actionscript
cabbrev ics client/script
cabbrev ict client/tools
cabbrev icr client/res
cabbrev is server

cabbrev ccn C:\g4\trunk
cabbrev ctw C:\g4\branches\international_g4tw_release\tw_trunk
cabbrev ckr C:\g4\branches\international_g4kr_release\kr_trunk
cabbrev ceg C:\g4\NeoX\src\3d-engine\branches\mobile\engine

" easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


