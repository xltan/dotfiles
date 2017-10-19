source $VIMRUNTIME/defaults.vim

let mapleader = ","
let maplocalleader = ","

set encoding=utf-8
set fileencoding=utf-8

let $vimfiles=split(&rtp, ",")[0]
call plug#begin($vimfiles . '/bundle')
Plug 'joshdick/onedark.vim'
" Plug 'rhysd/vim-color-spring-night'
Plug 'junegunn/seoul256.vim'

" Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/tpope-vim-abolish'
Plug 'tpope/vim-markdown'
let g:markdown_fenced_languages = ['cpp', 'go', 'python', 'sh']

Plug 'tpope/vim-endwise'

Plug 'wellle/targets.vim'
let g:targets_aiAI = 'ai  '

if has('mac')
  Plug 'wookayin/vim-typora'
  Plug 'rizzatti/dash.vim'
  let g:dash_map = {
  \ 'java' : 'android',
  \ 'cpp' : 'gl4',
  \ 'c' : 'gl4',
  \ }
  nmap <silent> K <Plug>DashSearch
else
  Plug 'rhysd/devdocs.vim'
  nmap <silent> K <Plug>(devdocs-under-cursor)
endif

Plug 'mhinz/vim-signify'
let g:signify_vcs_list = ['svn', 'git']
omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-outer-pending)
xmap ac <plug>(signify-motion-outer-visual)
nnoremap [r :SignifyRefresh<CR>
nnoremap ]r :SignifyToggle<CR>

Plug 'haya14busa/vim-asterisk'
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)
let g:asterisk#keeppos = 1

Plug 'mbbill/undotree', { 'on': ['UndotreeToggle'] }
nnoremap <silent> <leader>u :UndotreeToggle<CR>:UndotreeFocus<CR>

Plug 'kana/vim-niceblock'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/linediff.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:snips_author = "sinon"
let g:snips_email = "lidmuse@email.com"
let g:snips_github = "https://github.com/xltan"
Plug 'dawikur/algorithm-mnemonics.vim'

Plug 'majutsushi/tagbar'
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_hide_nonpublic = 1

if has('win32')
  let g:tagbar_iconchars = ['+', '-']
else
  let g:tagbar_iconchars = ['▸', '▾']
endif

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces:1',
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

let s:objc = {
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
let g:tagbar_type_objcpp = s:objc
let g:tagbar_type_objc = s:objc
nnoremap <silent> <leader>tt :TagbarToggle<CR>
nnoremap <silent> <leader>ts :TagbarCurrentTag f<CR>

Plug 'justinmk/vim-dirvish'
fun! SetupDirvish()
  silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d
  nnoremap <silent><buffer> gr :noautocmd Dirvish %<CR>
  nnoremap <silent><buffer> gh :silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d<CR>
  nnoremap <buffer> t :call dirvish#open('tabedit', 0)<CR>
  xnoremap <buffer> t :call dirvish#open('tabedit', 0)<CR>
endfun

aug dirvish
  au!
  autocmd FileType dirvish call SetupDirvish()
aug END

Plug 'justinmk/vim-sneak'
let g:sneak#use_ic_scs = 1
let g:sneak#label = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
map <M-;> <Plug>Sneak_,

Plug 'justinmk/vim-gtfo'

Plug 'Valloric/ListToggle'
let g:lt_quickfix_list_toggle_map = '<leader>z'

" Plug 'romainl/vim-qf'
" nmap <leader>z <Plug>qf_qf_toggle
" let g:qf_auto_open_quickfix = 1
" let g:qf_auto_open_loclist = 1
" let g:qf_auto_resize = 0
" let g:qf_bufname_or_text = 0
" let g:qf_mapping_ack_style = 1

Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

Plug 'jiangmiao/auto-pairs'
let g:AutoPairs = {'[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
" inoremap <buffer><silent> ) <C-R>=AutoPairsInsert(')')<CR>

if has('mac') || has('win32')
  Plug 'Valloric/YouCompleteMe' " , { 'frozen' : 1 }
  let g:ycm_enable_diagnostic_highlighting = 0
  let g:ycm_confirm_extra_conf = 0
  let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
  let g:ycm_key_list_select_completion = ['<C-N>', '<DOWN>']
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_complete_in_comments = 1
  let g:ycm_always_populate_location_list = 1
  " let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1
endif

Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

" Plug 'w0rp/ale'
" let g:ale_linters = {
" \   'python': ['flake8', 'pylint'],
" \   'c': [], 'cpp': [], 'objcpp': [], 'objc': [],
" \}
" let g:ale_lint_on_text_changed = 'never'

" Plug 'vim-python/python-syntax'
" let g:python_highlight_all = 1
Plug 'maralla/validator.vim'
let g:validator_error_symbol = '>>'
let g:validator_warning_symbol = '--'

Plug 'skywind3000/asyncrun.vim'
command! -bang -nargs=* -complete=file Make AsyncRun! -program=make @ <args>
command! -bang -nargs=* -complete=file Grep AsyncRun! -program=grep @ <args>

Plug 'dyng/ctrlsf.vim'
let g:ctrlsf_ackprg="rg"
let g:ctrlsf_context = '-C 2'
let g:ctrlsf_populate_qflist = 1
vmap <leader>f <Plug>CtrlSFVwordPath
nmap <leader>ff <Plug>CtrlSFCwordPath
nmap <leader>fw <Plug>CtrlSFCwordPath<CR>
nmap <leader>fs <Plug>CtrlSFCwordPath server<CR>
nmap <leader>fc <Plug>CtrlSFCwordPath client/script<CR>
nmap <leader>fo :CtrlSFToggle<CR>
nmap <leader>fr :CtrlSF -R 

if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

Plug 'Yggdroot/LeaderF' ", { 'branch': 'dev'}
let g:Lf_WindowPosition = 'bottom'
let g:Lf_ShortcutF = '<C-P>'
let g:Lf_WindowHeight = 0.25
let g:Lf_CommandMap = {
    \ '<ESC>': ['<C-I>'],
    \ '<C-C>': ['<Esc>', '<C-C>'],
    \ '<C-]>': ['<C-V>'],
    \ '<C-X>': ['<C-S>'],
    \ '<C-V>': ['<C-Q>'],
    \ '<C-P>': ['<C-O>'],
    \}
let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_WildIgnore = {
    \ 'dir': ['.svn','.git','.hg'],
    \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
    \}
let g:Lf_PreviewResult = { 'BufTag': 0, 'Function': 0 }
let g:Lf_UseCache = 1
let g:Lf_NeedCacheTime = 0.3
let g:Lf_CursorBlink = 0

nnoremap <leader>h :LeaderfMru<CR>
nnoremap <leader>b :LeaderfBufTag<CR>
nnoremap <leader>tg :LeaderfTag<CR>
nnoremap <leader>: :LeaderfHistoryCmd<CR>
nnoremap <leader>/ :LeaderfHistorySearch<CR>

Plug 'xltan/LeaderF-tjump'
nmap <C-]> :LeaderfTjump <C-r><C-w><CR>

Plug 'junegunn/goyo.vim'

" language related
" Plug 'rust-lang/rust.vim'
" let g:rustfmt_autosave = 0
Plug 'fatih/vim-go'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'pboettch/vim-cmake-syntax'
Plug 'fingerblaster/vim-fish'
Plug 'Vimjas/vim-python-pep8-indent'

Plug 'mattboehm/vim-unstack'
nnoremap <C-x> :UnstackFromClipboard<CR>

if has('win32')
  Plug 'milinnovations/vim-actionscript'
endif

" Plug 'lervag/vimtex'
" let g:tex_flavor = 'latex'
" let g:vimtex_compiler_latexmk = {
"     \ 'callback' : 0,
"     \ 'build_dir' : 'texbuild',
"     \ }
" let g:vimtex_view_general_viewer = '/usr/local/bin/displayline'
" let g:vimtex_view_general_options = '-r @line @pdf @tex'
" let g:vimtex_compiler_callback_hooks = ['UpdateSkim']
" function! UpdateSkim(status)
"   if !a:status | return | endif

"   let l:out = b:vimtex.out()
"   let l:tex = expand('%:p')
"   let l:cmd = [g:vimtex_view_general_viewer, '-r']
"   if !empty(system('pgrep Skim'))
"   call extend(l:cmd, ['-g'])
"   endif
"   if has('nvim')
"   call jobstart(l:cmd + [line('.'), l:out, l:tex])
"   elseif has('job')
"   call job_start(l:cmd + [line('.'), l:out, l:tex])
"   else
"   call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
"   endif
" endfunction
" nnoremap <leader>xt :call UpdateSkim(1)<CR>

call plug#end()

" Eager-load these plugins so we can override their settings. {{{
runtime! plugin/unimpaired.vim
runtime! plugin/rsi.vim
packadd! matchit
" }}}
inoremap <expr> <C-E> col('.')>strlen(getline('.'))?"\<Lt>C-E>":"\<Lt>End>"

let g:unstack_populate_quickfix=1
let g:unstack_extractors = [
    \ unstack#extractors#Regex('\v^ *File "([^"]+)", line ([0-9]+).*', '\1', '\2'),
    \ unstack#extractors#Regex('\v^[^ ]?.* *File "([^"]+)", line ([0-9]+).*', 'client/\1', '\2'),
    \ unstack#extractors#Regex('\v^[^ ]?.* ([^ ]+): ([0-9]+).+', 'client/\1', '\2'),
    \ ] + unstack#extractors#GetDefaults()

nmap <silent> [a <Plug>(ale_previous_wrap)
nmap <silent> ]a <Plug>(ale_next_wrap)

set synmaxcol=400

if has("termguicolors")
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
" let g:spring_night_kill_italic=1
" let g:spring_night_kill_bold=1
colors onedark
hi SpecialKey guifg=#7C8390
hi! link Comment SpecialKey
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link QuickFixLine SpellCap

" hi SignColumn guibg=bg
" hi VertSplit guifg=bg
hi! link ValidatorErrorSign ErrorMsg
hi! link ValidatorWarningSign ErrorMsg
hi Lf_hl_match gui=NONE guifg=SpringGreen
hi Lf_hl_matchRefine gui=NONE guifg=Magenta

set guioptions=a
set statusline=%<%f\ %h%m%r%=\ %{'['.(&fenc!=''?&fenc:&enc).','.&ff.']'}\ %-14.(%l,%c%V%)\ %P

set nu
set hlsearch
set cursorline
set nowrap

set imi=1

set listchars=tab:\|\ ,eol:¬

set autoindent
set expandtab smarttab
set shiftwidth=2 tabstop=2 softtabstop=2

set laststatus=2

set hidden
set autowrite
set autoread

set nobackup
set backupdir=$HOME/.swap
set directory=$HOME/.swap//
set undodir=$HOME/.swap
set undofile

set winwidth=100
set winminwidth=10
set completeopt=menuone,preview

set ignorecase smartcase
set lazyredraw

set nofixeol
set formatoptions+=j " Delete comment character when joining commented lines
set cinoptions=:0,g0,(0,Ws,l1
set viminfo^=!
set wildignore=*.pyc,*.exe,.DS_Store,._*,.svn,.git,.vscode
set cpoptions+=>
set belloff=all
set history=1000

function! s:a(cmd)
  let name = expand('%:r')
  let ext = tolower(expand('%:e'))
  let sources = ['c', 'cc', 'cpp', 'm', 'mm']
  let headers = ['h', 'hh', 'hpp']
  for pair in [[sources, headers], [headers, sources]]
    let [set1, set2] = pair
    if index(set1, ext) >= 0
      for h in set2
        let aname = name.'.'.h
        for a in [aname, toupper(aname)]
          if filereadable(a)
            execute a:cmd a
            return
          end
        endfor
      endfor
    endif
  endfor
endfunction
command! A call s:a('e')
command! AV call s:a('botright vertical split')

function! s:helptab()
  wincmd T
  nnoremap <buffer> q :q<cr>
endfunction
aug vimrc_autocmd
  autocmd!
  autocmd filetype help call s:helptab()
  autocmd filetype vim setlocal tabstop=2 shiftwidth=2
  autocmd filetype python setlocal noexpandtab tabstop=4 shiftwidth=4
  " autocmd filetype python setlocal equalprg=yapf
  autocmd filetype python nmap <silent><leader>a :call ToggleAlternateFile(expand('%:p'))<CR>
  autocmd filetype actionscript setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd filetype make set noexpandtab
  autocmd filetype tex setlocal tabstop=2 shiftwidth=2
  autocmd filetype c,cpp,objc,objcpp setlocal equalprg=clang-format
  autocmd filetype c,cpp,objc nmap <silent><leader>a :A<CR>
  autocmd filetype c,cpp,objc,objcpp,cs,java,actionscript setlocal commentstring=//\ %s
  autocmd filetype git setlocal nonumber
  autocmd WinLeave,InsertEnter * setlocal nocursorline
  autocmd WinEnter,InsertLeave * setlocal cursorline
  autocmd QuickFixCmdPost * botright cwindow
  " autocmd BufWinEnter * if &buftype == 'terminal' | nnoremap <buffer> <leader>q a<C-W><C-c> | endif
aug END

function! s:map_change_option(...)
  let [key, opt] = a:000[0:1]
  let op = get(a:, 3, 'set '.opt.'!')
  execute printf("nnoremap co%s :%s<bar>set %s?<CR>", key, op, opt)
endfunction

call s:map_change_option('p', 'paste')
call s:map_change_option('n', 'number')
call s:map_change_option('w', 'wrap')
call s:map_change_option('h', 'hlsearch')
call s:map_change_option('e', 'expandtab', 'set expandtab!<bar>retab')
call s:map_change_option('l', 'list')
call s:map_change_option('m', 'mouse', 'let &mouse = &mouse == "" ? "a" : ""')
call s:map_change_option('t', 'textwidth',
    \ 'let &textwidth = input("textwidth (". &textwidth ."): ")<bar>redraw')
call s:map_change_option('b', 'background',
    \ 'let &background = &background == "dark" ? "light" : "dark"<bar>redraw')

" windows key bind
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y
map <C-Q> "+gP
map <S-Insert> "+gP
cmap <C-Q> <C-R>+
cmap <S-Insert> <C-R>+
exe 'inoremap <script> <C-Q> <C-G>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <C-Q> ' . paste#paste_cmd['v']

nnoremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <Esc>:update<CR>

cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
nmap <C-n> :sav %%

nnoremap <silent> <S-L> :nohl<CR>

tnoremap <Esc> <C-W>N
tnoremap <C-^> <C-W>N<C-^>
tnoremap <C-h> <C-w>h
tnoremap <C-l> <C-w>l
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-\> <C-W>N:%y\|tabnew\|setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified\|normal P<CR>
nnoremap <C-\> :%y\|tabnew\|setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified\|normal P<CR>
inoremap <C-\> <Esc>:%y\|tabnew\|setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified\|normal P<CR>

inoremap <C-^> <Esc><C-^>

function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! ToggleTerm()
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~# "Terminal"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) == -1
      exec 'b '.bufnum
      normal! a
    else
      silent! e#
    endif
    return
  endfor
  term ++curwin ++close
endfunction

if has('gui_running')
  nnoremap <silent> <C-z> :call ToggleTerm()<CR>
  tnoremap <C-z> <C-W>N<C-^>
endif

nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

nnoremap [<space> :put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space> :put =repeat(nr2char(10), v:count1)<cr>

nnoremap [w gT
nnoremap ]w gt
nnoremap [W :tabfirst<CR>
nnoremap ]W :tablast<CR>

inoremap <M-o> <C-o>o
inoremap <M-O> <C-o>O
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>l
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k

nnoremap Q @q
xnoremap Q :normal @q<CR>
" repeat last command for each line of a visual selection
xnoremap . :normal .<CR>
nnoremap <M-q> qq

vnoremap < <gv
vnoremap > >gv
nnoremap gV `[v`]
nnoremap Y y$

nnoremap <silent> <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

if has("mac")
  set guifont=SF\ Mono:h12
  set macthinstrokes
  set macmeta
  set linespace=1
elseif has("win32")
  set guifont=Monaco\ for\ Powerline:h9
  set gfw=Microsoft\ Yahei\ Mono:h9
  set linespace=2
  " set renderoptions=type:directx,
  "                   \gamma:1.4,contrast:1,geom:1,
  "                   \renmode:5,taamode:1,level:1
  nnoremap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>

  let s:tortoise_svn_path = '"C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe"'
  function! SvnCommand(cmd, path)
    execute 'silent! !start '. s:tortoise_svn_path. ' /command:'. a:cmd. ' /path:"'. a:path. '"'
  endfunction
  nnoremap <silent> <leader>tu :call SvnCommand('update /closeonend:3', expand('%:p'))<CR>
  nnoremap <silent> <leader>tw :call SvnCommand('commit /closeonend:3', expand('%:p'))<CR>
  nnoremap <silent> <leader>tc :call SvnCommand('commit /closeonend:3', getcwd())<CR>
  nnoremap <silent> <leader>tx :call SvnCommand('cleanup /closeonend:3', expand('%:p:h'))<CR>
  nnoremap <silent> <leader>tm :call SvnCommand('update /closeonend:3', getcwd())<CR>
  nnoremap <silent> <leader>tb :call SvnCommand('blame /line:'. line('.'), expand('%:p'))<CR>
  nnoremap <silent> <leader>tl :call SvnCommand('log', expand('%:p'))<CR>
  nnoremap <silent> <leader>ta :call SvnCommand('add', expand('%:p'))<CR>
  nnoremap <silent> <leader>td :call SvnCommand('diff', expand('%:p'))<CR>
  nnoremap <silent> <leader>tr :call SvnCommand('revert', expand('%:p'))<CR>
endif

function! s:GenTagArgument()
  if match(getcwd(), 'g4\\trunk') >= 0
    return '--links=no --pattern-length-limit=0
          \ --exclude=unittest --exclude=tools
          \ --exclude=extension --exclude=_runtime --exclude=doc
          \ --exclude=ai --exclude=server\\com
          \ --exclude=tools_no_upload --exclude=engine\\src
          \ --languages=python,actionscript --recurse .'
  else
    return '-R .'
  endif
endfunction

nnoremap <silent> <leader>xc :execute 'AsyncRun ctags '.<SID>GenTagArgument()<CR>

nnoremap <leader>q :bd<CR>
nnoremap <leader>w :tabclose<CR>

function! s:make_info()
  if &filetype == 'python'
    return 'python %'
  else
    return 'make'
  endif
endfunction

nnoremap <silent> <leader>xm :update<CR>:execute 'AsyncRun '.<SID>make_info()<CR>
nnoremap <silent> <leader>sa :AsyncRun -post=e autoflake --in-place --remove-all-unused-imports %<CR>

nnoremap <M-p> "0p

cnoremap <C-p> <UP>
cnoremap <C-n> <DOWN>
command! Only :%bd|e#

nnoremap <leader>en :e ~/Dropbox/notes<CR>
nnoremap <leader>es :e $vimfiles/UltiSnips<CR>

cab ar AsyncRun

let alternatePathDict = {
    \ 'client/script/com/data' : 'server/g4server/avatarattrs',
    \ 'client/script/avatarmembers' : 'server/g4server/avatarmembers',
    \ 'client/script/com/utils/helpers' : 'server/g4server/shelpers',
    \ 'client/script/com/const' : 'server/g4server/sconst',
    \ 'client/script/Globals' : 'server/g4server/sGlobals',
    \ 'client/script/network/rpcentity/ClientEntities' : 'server/ServerLauncher/ServerEntities',
    \ 'ClientMember' : 'ServerMember',
    \ 'client/script/entities/components/awskill/AwSkill' : 'client/script/entities/components/skill/SkillComp',
\}

function! ToggleAlternateFile(filepath)
  let filepath = substitute(a:filepath, "\\", "/", "g")
  let item = ""
  for path in items(g:alternatePathDict)
    let k = path[0]
    let v = path[1]
    if (filepath =~ k)
      let item = substitute(filepath, k, v, "")
      break
    endif
    if (filepath =~ v)
      let item = substitute(filepath, v, k, "")
      break
    endif
  endfor
  if (item != "" && filereadable(item))
    execute ":e " . item
  endif
endfunc

nnoremap <leader>cd :lcd %:h<CR>:pwd<CR>

function! s:preserve(command)
  let _s=@/
  let l = line('.')
  let c = col('.')
  execute a:command
  let @/=_s
  call cursor(l,c)
endfunc

nmap _$ :call <SID>preserve("%s/\\s\\+$//e")<CR>
nmap _= :call <SID>preserve("normal! gg=G")<CR>

function! s:indent_len(str)
  return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
endfunction

function! s:indent_object(op, skip_blank, b, e, bd, ed)
  let i = min([s:indent_len(getline(a:b)), s:indent_len(getline(a:e))])
  let x = line('$')
  let d = [a:b, a:e]

  if i == 0 && empty(getline(a:b)) && empty(getline(a:e))
    let [b, e] = [a:b, a:e]
    while b > 0 && e <= line('$')
      let b -= 1
      let e += 1
      let i = min(filter(map([b, e], 's:indent_len(getline(v:val))'), 'v:val != 0'))
      if i > 0
        break
      endif
    endwhile
  endif

  for triple in [[0, 'd[o] > 1', -1], [1, 'd[o] < x', +1]]
    let [o, ev, df] = triple

    while eval(ev)
      let line = getline(d[o] + df)
      let idt = s:indent_len(line)

      if eval('idt '.a:op.' i') && (a:skip_blank || !empty(line)) || (a:skip_blank && empty(line))
        let d[o] += df
      else | break | end
    endwhile
  endfor
  execute printf('normal! %dGV%dG', max([1, d[0] + a:bd]), min([x, d[1] + a:ed]))
endfunction
xnoremap <silent> ii :<C-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), 0, 0)<CR>
onoremap <silent> ii :<C-u>call <SID>indent_object('>=', 1, line('.'), line('.'), 0, 0)<CR>
xnoremap <silent> ai :<C-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), -1, 0)<CR>
onoremap <silent> ai :<C-u>call <SID>indent_object('>=', 1, line('.'), line('.'), -1, 0)<CR>
xnoremap <silent> io :<C-u>call <SID>indent_object('==', 0, line("'<"), line("'>"), 0, 0)<CR>
onoremap <silent> io :<C-u>call <SID>indent_object('==', 0, line('.'), line('.'), 0, 0)<CR>
xnoremap <silent> ao :<C-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), -1, 1)<CR>
onoremap <silent> ao :<C-u>call <SID>indent_object('>=', 1, line('.'), line('.'), -1, 1)<CR>

function! s:tab_message(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call <SID>tab_message(<q-args>)

function! s:tab_message(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call <SID>tab_message(<q-args>)

