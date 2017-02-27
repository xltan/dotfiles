filetype off                  " required
" set the runtime path to include Vundle and initialize
if(!has("win32"))
  set rtp+=/usr/local/opt/fzf
endif
let $VIMFILES=split(&rtp,",")[0]

call plug#begin($VIMFILES. '/bundle')
Plug 'vim-scripts/matchit.zip'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-markdown'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'altercation/vim-colors-solarized'
" Plug 'vim-airline/vim-airline'
Plug 'rakr/vim-one'

Plug 'mbbill/undotree'

Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
Plug 'rhysd/vim-clang-format'

Plug 'AndrewRadev/splitjoin.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'

Plug 'justinmk/vim-sneak'
Plug 'justinmk/vim-gtfo'

Plug 'junegunn/vim-easy-align'

Plug 'Valloric/YouCompleteMe'
Plug 'maralla/validator.vim'
" Plug 'w0rp/ale'

Plug 'skywind3000/asyncrun.vim'

Plug 'dyng/ctrlsf.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'vim-scripts/actionscript.vim--Leider'

if(has("win32"))
  Plug 'FelikZ/ctrlp-py-matcher'
  Plug 'tacahiroy/ctrlp-funky'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'adonis0147/ctrlp-cIndexer'
  Plug 'ivalkeen/vim-ctrlp-tjump'
  " Plug 'Yggdroot/LeaderF'
else
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-fugitive'
endif

call plug#end()

filetype plugin indent on
syntax on
syntax sync minlines=200
set synmaxcol=200

set t_Co=256

set t_8b=[48;2;%lu;%lu;%lum
set t_8f=[38;2;%lu;%lu;%lum

if has("termguicolors")
  set termguicolors
endif

set background=dark

" let g:solarized_italic = 0
" let g:solarized_bold = 0 
" let g:solarized_termcolors = 256 
" colors solarized

colors one
hi SignColumn guibg=bg
hi StatusLineNC guibg=#5c6370 guifg=bg
hi VertSplit guifg=bg
hi SpecialKey guifg=#8c93a0
hi User1 guifg=#61afef
hi Pmenu guibg=#2c323c
hi title guifg=#cccccc gui=NONE cterm=NONE

set cursorline
set guioptions=
set backspace=indent,eol,start
set showtabline=0
set showmode

set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smarttab

set laststatus=2
set wildmenu
set hidden
set autowrite
set autoread

set nobackup
set backupdir=$HOME/.swap
set directory=$HOME/.swap//
set undodir=$HOME/.swap
set undofile

set completeopt-=preview

set hlsearch
set incsearch

set ruler
set nu
set nofixeol

if !empty(&viminfo)
  set viminfo='100,<50,s10,h,%20
endif

set formatoptions+=j " Delete comment character when joining commented lines

set ignorecase
set smartcase

set tags=tags
set path=.

set encoding=utf-8
set fileencoding=utf-8

set scrolloff=8
set scrolljump=5
set lazyredraw

set wildignore=*.pyc,*.exe,.DS_Store,._*

let mapleader = ","

nnoremap <silent> <leader>u :UndotreeToggle<CR>:UndotreeFocus<CR>

nnoremap <silent> <leader>xp :Shell python %<CR>
nnoremap <silent> <leader>xm :Shell make<CR>

nnoremap <silent> <leader>e :e ~/Dropbox/notes<CR>
nnoremap <silent> <leader>w :w<CR>
nnoremap <silent> <leader>q :q<CR>
nnoremap <silent> <leader>j :call LocationNext()<CR>
nnoremap <silent> <leader>k :call LocationPrevious()<CR>
nnoremap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nnoremap <silent> <leader>z :call ToggleList("Quickfix List", 'c')<CR>

nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" custom map
vmap     <leader>f <Plug>CtrlSFVwordPath
nmap     <leader>f <Plug>CtrlSFCwordPath
nnoremap <leader>s :CtrlSFToggle<CR>
inoremap <leader>s <Esc>:CtrlSFToggle<CR>

set statusline =%1*\%{CurTabColor()}%*\ %f%h%m%r
" set statusline +=\ %{ALEGetStatusLine()}
set statusline +=%=%y\ [%{strlen(&fenc)?&fenc:'none'},%{&ff}]\ %c,%l/%L\ %P
function! CurTabColor() 
  let currentTab = tabpagenr() 
  let s_line= '[' . currentTab . ']' 
  return s_line 
endfunction

" markdown
nnoremap <leader>1 m`yypVr=``
nnoremap <leader>2 m`yypVr-``
nnoremap <leader>3 m`^i### <esc>``4l
nnoremap <leader>4 m`^i#### <esc>``5l
nnoremap <leader>5 m`^i##### <esc>``6l

"make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

nnoremap <silent> <S-L> :nohl<CR>
nnoremap <C-n> :sav <C-R>=fnameescape(expand('%:h')).'\'<cr>

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

nmap r <Plug>Sneak_s
nmap R <Plug>Sneak_S
xmap r <Plug>Sneak_s
xmap R <Plug>Sneak_S
omap r <Plug>Sneak_s
omap R <Plug>Sneak_S

" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)

nnoremap <silent> <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
	\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
	\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

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

augroup vimrc_autocmd
  au BufRead,BufNewFile *.as set filetype=actionscript
  au filetype python setlocal noexpandtab tabstop=4 shiftwidth=4
  au filetype actionscript setlocal noexpandtab tabstop=4 shiftwidth=4
  au FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
  au FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
  au FileType make set noexpandtab
augroup END

set cinoptions=:0,g0,(0,Ws,l1

" custom global var
let g:ctrlsf_ackprg="rg"

let g:completor_min_chars = 3
let g:validator_permament_sign = 1
let g:validator_go_checkers = ['gofmt']
" let g:ale_sign_column_always = 1
" let g:ale_sign_error = '>'
" let g:ale_sign_warning = '-'
" let g:ale_lint_on_enter = 0
" let g:ale_lint_delay = 1000

" let g:airline_theme='one'
" let g:airline_powerline_fonts = 1

" ultisnips
let g:UltiSnipsSnippetDirectories=["UltiSnips", "mysnippets"]
let g:UltiSnipsDoHash=0

let g:markdown_fenced_languages = ['python', 'go', 'cpp', 'sh']

set concealcursor=inv
set conceallevel=2

if(has("win32"))
  set guifont=Monaco\ for\ Powerline:h9
  " set renderoptions=type:directx,
  " 	\gamma:1.7,contrast:1,geom:1,
  " 	\renmode:5,taamode:1,level:1

  " ctrlp
  let g:ctrlp_map = '<c-p>'
  let g:ctrlp_cmd = 'CtrlP'
  let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
  let g:ctrlp_working_path_mode = 'w'
  let g:ctrlp_lazy_udpate = 100
  let g:ctrlp_max_files = 0
  let g:ctrlp_max_depth = 40
  let g:ctrlp_use_caching = 1
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_mruf_default_order = 1
  let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:12,results:30'
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  let g:cIndexer_custom_ignore_extensions = ['sfx', 'gim', 'gis', 'ags', 'mesh', 'mtg', 'ter', 'cache', 'scn'] 
  let g:cIndexer_custom_ignore_directories = ['_site', 'extension', '_editer', 'packedIpa',
    \'extension', 'multi_target_plist', 'intern', 'ai', '_backup', 'server\/com', '.vscode', '_lib']
  nnoremap <leader>r :CtrlPMRUFiles<CR>
  nnoremap <Leader>b :CtrlPFunky<Cr>
  " nnoremap <leader>b :CtrlPBufTag<CR>

  let g:ctrlp_funky_use_cache = 1

  nnoremap <silent> <c-]> :CtrlPtjump<cr>
  vnoremap <silent> <c-]> :CtrlPtjumpVisual<cr>
  let g:ctrlp_tjump_only_silent = 1
  let g:ctrlp_tjump_skip_tag_name = 1
  " Setup some default ignores
  " let g:ctrlp_custom_ignore = {
  " \ 'dir': '\v[\/](\.(git|hg|svn)|\_site|packedIpa|extension|lib|Lib|multi_target_plists|Lib|intern|bt2code|(server\\com)|(\v\.(egg|app)))$',
  " \ 'file': '\v\.(fxl|cache|ktx|pvr|tga|sfx|fx|pyc|exe|so|dll|class|png|jpg|jpeg)$',
  " \}
  " let g:ctrlp_user_command = 'rg . --files --color=never --glob ""'
  "
  " LeaderF
  " let g:Lf_ShortcutF = '<C-P>'
  " let g:Lf_WindowHeight = 0.3
  " let g:Lf_CacheDirectory = $HOME.'/.cache/leaderf'
  " let g:Lf_WildIgnore = {
	" \ 'dir': ['.svn','.git', '*._site$', 'extension', '*._editor$', 'packedIpa', 'multi_target_plist', 'intern', 'ai', '*_backup$', '*.server\/com$'],
	" \ 'file': ['*.sw?', '*.gi?', '*.ags', '*.mgt', '*.ter', '*.scn', '~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
	" \}
  " let g:Lf_CommandMap = {'<C-F>': ['<C-D>'], '<ESC>': ['<C-C>']}
  " nmap <leader>r :LeaderfMru<CR>
else
  set guifont=Monaco\ for\ Powerline:h12
  set clipboard=unnamed
  " fzf
  nmap <leader>r :History<cr>
  nmap <leader>b :BTags<cr>
  nmap <c-p> :Files<cr>
endif

function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  echo command
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'vert new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap
  echo 'Execute: ' . command . '...'
  silent! execute 'silent %!'. command
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Command: ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

" Allow :lprev to work with empty location list, or at first location
function! LocationPrevious()
  try
    lprev
  catch /:E553:/
    lfirst
  catch /:E\%(42\|776\):/
    echo "Location list empty"
  catch /.*/
    echo v:exception
  endtry
endfunction

" Allow :lnext to work with empty location list, or at last location
function! LocationNext()
  try
    lnext
  catch /:E553:/
    lfirst
  catch /:E\%(42\|776\):/
    echo "Location list empty"
  catch /.*/
    echo v:exception
  endtry
endfunction
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

let g:completor_racer_binary = $HOME . '/.cargo/bin/racer'
let g:completor_gocode_binary = $HOME . '/goext/bin/gocode'
let g:rustfmt_autosave = 0

nnoremap <leader>go :lcd $HOME/gospace<CR>

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

let objc = {
    \ 'ctagstype' : 'ObjectiveC',
    \ 'kinds'     : [
        \ 'i:interface',
        \ 'I:implementation',
        \ 'm:Object_method',
        \ 'c:Class_method',
        \ 'v:Global_variable',
        \ 'F:Object field',
        \ 'f:function',
        \ 'p:property',
        \ 't:type_alias',
        \ 's:type_structure',
        \ 'e:enumeration',
        \ 'M:preprocessor_macro',
    \ ],
    \ 'sro'        : ' ',
    \ 'kind2scope' : {
        \ 'i' : 'interface',
        \ 'I' : 'implementation',
        \ 's' : 'type_structure',
        \ 'e' : 'enumeration'
    \ },
    \ 'scope2kind' : {
        \ 'interface'      : 'i',
        \ 'implementation' : 'I',
        \ 'type_structure' : 's',
        \ 'enumeration'    : 'e'
    \ }
\ }
let g:tagbar_type_objcpp = objc
let g:tagbar_type_objc = objc

" ycm
let g:ycm_error_symbol = '>'
let g:ycm_warning_symbol = '.'
let g:ycm_confirm_extra_conf = 0

let g:ycm_key_list_select_completion = ['<C-N>', '<DOWN>']

nmap <leader>tt :TagbarToggle<CR>
nmap <leader>gc :AsyncRun gentags.bat<CR>

