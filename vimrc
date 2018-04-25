if !has('nvim')
  source $VIMRUNTIME/defaults.vim
endif

let mapleader = ","
let maplocalleader = ","
let s:username = "Sinon"

set encoding=utf-8
set fileencoding=utf-8

let $VIMFILES=split(&rtp, ",")[0]
call plug#begin($VIMFILES . '/bundle')
Plug 'arcticicestudio/nord-vim', {'branch': 'develop'}

let delimitMate_expand_cr = 1
let delimitMate_jump_expansion = 1
let delimitMate_smart_matchpairs = '^\%(\w\|\"\|''\|\!\|[£$]\|[^[:space:][:punct:]]\)'
Plug 'Raimondi/delimitMate'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
" Plug 'tpope/vim-fugitive'

let g:markdown_fenced_languages = ['make', 'cpp', 'go', 'python', 'sh', 'cpp']

let g:targets_aiAI = 'ai  '
let g:targets_quotes = '"d '' `'
Plug 'wellle/targets.vim'

if has('mac')
  Plug 'rizzatti/dash.vim'
  nmap <silent><buffer> K <Plug>DashSearch
  let g:dash_map = {
  \ 'java' : 'android',
  \ 'cpp' : 'gl4',
  \ 'go' : 'gl4',
  \ 'c' : 'gl4',
  \ }
else
  Plug 'rhysd/devdocs.vim'
  nmap <silent><buffer> K <Plug>(devdocs-under-cursor)
endif

Plug 'mhinz/vim-signify'
let g:signify_vcs_list = ['svn', 'git']

omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-inner-pending)
xmap ac <plug>(signify-motion-inner-visual)
nnoremap [r :SignifyRefresh<CR>
nnoremap ]r :SignifyToggle<CR>

" Plug 'haya14busa/vim-asterisk'
" map *  <Plug>(asterisk-z*)
" map #  <Plug>(asterisk-z#)
" map g* <Plug>(asterisk-gz*)
" map g# <Plug>(asterisk-gz#)

Plug 'mbbill/undotree'
nnoremap <silent> <leader>u :UndotreeToggle<CR>

Plug 'kana/vim-niceblock'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/linediff.vim'

Plug 'SirVer/ultisnips'
Plug 'xltan/algorithm-mnemonics.vim'
Plug 'honza/vim-snippets'
let g:snips_author = s:username
let g:snips_email = "lidmuse@email.com"
let g:snips_github = "https://github.com/xltan"

Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.git', '.svn', '.gutctags', 'tags', '.clang-format', '.ignore', '.ycm_extra_conf.py']
if !has('win32')
  let g:gutentags_cache_dir = $VIMFILES . '/.cache'
  Plug 'vim-utils/vim-man'
  map <leader>v <Plug>(Vman)
endif

let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

Plug 'justinmk/vim-dirvish'
func! s:setup_dirvish()
  " silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d
  silent! unmap <silent><buffer> <C-p>
  nnoremap <silent><buffer> gs :sort ,^.*[\/],<CR>:set conceallevel=3<CR>
  nnoremap <silent><buffer> gr :noau Dirvish %<CR>
  nnoremap <silent><buffer> gh :silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d<CR>:set conceallevel=3<CR>
  nnoremap <buffer> t :call dirvish#open('tabedit', 0)<CR>
  xnoremap <buffer> t :call dirvish#open('tabedit', 0)<CR>
endfun

aug dirvish
  au!
  au FileType dirvish call <SID>setup_dirvish()
aug END

func! DirvishSetup()
  let text = getline('.')
  let xp = []
  for item in split(&wildignore, ',')
    call add(xp, glob2regpat(item).'\=')
  endfor
  exec 'silent keeppatterns g/\(' . join(xp, '\|'). '\|[\/|\\]tags' . '\)/d'
  exec 'sort ,^.*[\/],'
endfunc
let g:dirvish_mode = 'call DirvishSetup()'

Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
map <M-;> <Plug>Sneak_,

Plug 'justinmk/vim-gtfo'
let g:gtfo#terminals = { 'win': 'cmd.exe /k' }

Plug 'Valloric/ListToggle'
let g:lt_quickfix_list_toggle_map = '<leader>z'
let g:lt_height = 9

" Plug 'natebosch/vim-lsc'
" let g:lsc_server_commands = {'python': 'pyls'}

if has('win32')
  let s:error_symbol = '🔸'
  let s:warning_symbol = '🔹'
else
  let s:error_symbol = '>>'
  let s:warning_symbol = '--'
endif

Plug 'Valloric/YouCompleteMe' " , { 'frozen' : 1 }
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_min_num_of_chars_for_completion = 3
let g:ycm_max_num_candidates = 18
let g:ycm_max_num_identifier_candidates = 6
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_key_list_select_completion = ['<C-N>', '<DOWN>']
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments = 1
let g:ycm_always_populate_location_list = 1
let g:ycm_error_symbol = s:error_symbol
let g:ycm_warning_symbol = s:warning_symbol
" let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'qf' : 1,
    \ 'notes' : 1,
    \ 'markdown' : 1,
    \ 'unite' : 1,
    \ 'text' : 1,
    \ 'vimwiki' : 1,
    \ 'pandoc' : 1,
    \ 'infolog' : 1,
    \ 'ctrlsf' : 1,
    \ 'mail' : 1,
    \ 'project' : 1,
    \}
nmap <silent> gd :YcmCompleter GoTo<CR>
nmap <silent> gz :YcmCompleter FixIt<CR>
func! YcmOnDeleteChar()
  if pumvisible()
    return "\<C-y>\<Plug>delimitMateBS"
  endif
  return "\<Plug>delimitMateBS"
endfunc
imap <expr><BS> YcmOnDeleteChar()

if has('win32')
  Plug 'xltan/YcmGen'
else
  Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
  command! -nargs=? -complete=file_in_path -bang YcmGen YcmGenerateConfig -f
endif

Plug 'Shougo/echodoc.vim'
set noshowmode
let g:echodoc_enable_at_startup = 1

Plug 'w0rp/ale'
let g:ale_linters = {
\   'python': ['flake8'],
\   'go': ['golint'],
\   'c': [], 'cpp': [], 'objcpp': [], 'objc': [],
\}
let g:ale_sign_error = s:error_symbol
let g:ale_sign_warning = s:warning_symbol
let g:ale_lint_on_text_changed = 'never'

Plug 'skywind3000/asyncrun.vim'
command! -bang -nargs=* -complete=file Make AsyncRun! -program=make @ <args>
command! -bang -nargs=* -complete=file Grep AsyncRun! -program=grep @ <args>

Plug 'dyng/ctrlsf.vim'
let g:ctrlsf_ackprg="rg"
let g:ctrlsf_context = '-C 2'
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

" Plug 'lilydjwg/colorizer'
" let g:colorizer_startup = 0
" let g:colorizer_maxlines = 100
" let g:colorizer_nomap = 1

Plug 'Yggdroot/LeaderF' ", { 'branch': 'dev'}
let g:Lf_ShortcutF = '<C-P>'
let g:Lf_WindowHeight = 0.35
let g:Lf_CacheDiretory = $VIMFILES
if !exists('g:Lf_CommandMap')
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
      \ 'dir': ['.svn','.git','.hg','bin'],
      \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]','tags']
      \}
  let g:Lf_PreviewResult = { 'BufTag': 0, 'Function': 0 }
  let g:Lf_UseCache = 1
  let g:Lf_NeedCacheTime = 0.3
  let g:Lf_CursorBlink = 0
endif

nnoremap <leader>h :LeaderfMru<CR>
nnoremap <leader>b :LeaderfFunction<CR>
nnoremap <leader>j :LeaderfBufTag<CR>
nnoremap <leader>tg :LeaderfTag<CR>
nnoremap <leader>: :LeaderfHistoryCmd<CR>
nnoremap <leader>/ :LeaderfHistorySearch<CR>

Plug 'xltan/LeaderF-tjump'
aug vimrc_tjump
  au!
  au FileType c,cpp,objc,objcpp,actionscript,python nmap <silent><buffer> <C-]> :LeaderfTjump <C-r><C-w><CR>
aug END

Plug 'xltan/vim-project', { 'branch': 'jpmv27_master' }

" Plug 'editorconfig/editorconfig-vim'

" language related
Plug 'vim-python/python-syntax'
let g:python_version_2 = 1
let g:python_highlight_class_vars = 0
let g:python_highlight_indent_errors = 0
let g:python_highlight_space_errors = 0
let g:python_highlight_operators = 0
let g:python_highlight_all = 1
let g:python_slow_sync = 0
" a little bit slow
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'fisadev/vim-isort'

" let c_no_curly_error = 1
" let g:cpp_no_func_highlight = 0
" let g:cpp_class_scope_highlight = 0
" let g:cpp_member_variable_highlight = 0
" let g:cpp_class_decl_highlight = 1
" Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'pboettch/vim-cmake-syntax'

Plug 'milinnovations/vim-actionscript'
Plug 'tikhomirov/vim-glsl'

" Plug 'rust-lang/rust.vim'
" let g:rustfmt_autosave = 0

" Plug 'fatih/vim-go'
" let g:go_def_mode = 'godef'
" let g:go_fmt_command = "goimports"
" let g:go_list_type = "quickfix"

" Plug 'mattn/emmet-vim'
" let g:user_emmet_install_global = 0
" let g:user_emmet_leader_key='<C-y>'
" aug vimrc_emmet
"   au!
"   au FileType html,css EmmetInstall
" aug END

" Plug 'leafgarland/typescript-vim'
" Plug 'Quramy/tsuquyomi'

call plug#end()

call project#rc()
" Eager-load these plugins so we can override their settings. {{{
runtime! plugin/unimpaired.vim
runtime! plugin/rsi.vim
inoremap <expr> <C-E> col('.')>strlen(getline('.'))?"\<Lt>C-E>":"\<Lt>End>"
inoremap <M-t> <esc>diwbPa <esc>ea
if !has("gui_running") " from tpope/vim-rsi
  silent! exe "set <F36>=\<esc>t"
  map! <F36> <M-t>
  map <F36> <M-t>

  set mouse=
endif
 
if !has('nvim')
  packadd! matchit
  unlet c_comment_strings
endif

nmap <silent> [a <Plug>(ale_previous_wrap)
nmap <silent> ]a <Plug>(ale_next_wrap)
nmap <silent> [x :cpf<CR>
nmap <silent> ]x :cnf<CR>
nmap <silent> [X :lpf<CR>
nmap <silent> ]X :lnf<CR>
nmap <silent> [w gT
nmap <silent> ]w gt
nmap <silent> [W :tabfirst<CR>
nmap <silent> ]W :tablast<CR>
nmap <silent> [<space> :put! =repeat(nr2char(10), v:count1)<cr>'[
nmap <silent> ]<space> :put =repeat(nr2char(10), v:count1)<cr>

nnoremap <silent> cos :if exists("g:syntax_on") <Bar>
  \   syntax off <Bar>
  \ else <Bar>
  \   syntax on <Bar>
  \ endif <CR>
func! s:option_map(...)
  let [key, opt] = a:000[0:1]
  let op = get(a:, 3, 'set '.opt.'!')
  execute printf("nnoremap co%s :%s<bar>set %s?<CR>", key, op, opt)
endfunc
call s:option_map('p', 'paste')
call s:option_map('e', 'expandtab', 'setlocal expandtab!<bar>retab')
call s:option_map('t', 'ts',
    \ 'let &ts = input("tabstop (". &ts ."): ")<bar>let &sw=&ts<bar>redraw')

if has("termguicolors")
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

set background=dark
" let g:hybrid_less_color = 0
" colorscheme hybrid
let g:nord_comment_brightness = 15
colorscheme nord

hi! link pythonFunction Normal
hi! link Error ALEErrorSign
hi! link WarningMsg SpecialChar
hi! link Constant Number
hi! link Special SpecialChar
hi! link pythonBytesEscape SpecialChar
hi! link DirvishSuffix Normal
hi Statement gui=none

set guioptions=
set statusline=%<%f\ %h%m%r%=\ %{'['.(&fenc!=''?&fenc:&enc).','.&ff.']'}\ %-14.(%l,%c%V%)\ %P

" set cursorline
" set nu
" set foldcolumn=1
set hlsearch
set nowrap

set listchars=tab:\|\ ,eol:¬

set autoindent
set smarttab
set sw=4 ts=4
set timeoutlen=500 ttimeoutlen=0

set laststatus=2

set hidden
set autowrite
set autoread

set nobackup
set backupdir=$VIMFILES/.swap
set directory=$VIMFILES/.swap//
set undodir=$VIMFILES/.undo
set undofile

set winwidth=100
set winminwidth=10
set completeopt=menuone

set ignorecase smartcase
set lazyredraw

set nofixeol
set formatoptions+=j " Delete comment character when joining commented lines
set cinoptions=:0,g0,(0,Ws,l1
set viminfo^=!
set wildignore=*.pyc,*.pyo,*.exe,*.DS_Store,._*,*.svn,*.git,*.o,
    \*.vscode,tags,*.vs,*compile_commands.json,
    \*.pyproj,*.idea
set cpoptions+=>
set belloff=all
set history=1000

" for c-family files
func! s:a(cmd)
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
endfunc

func! s:super()
  if &filetype == 'python'
    let pattern = '^class [^(]*(\zs[^)]*\ze):'
    let lineno = search(pattern, 'n')
    let content = getline(lineno)
    let m = matchstr(content, pattern)
    let sm = split(m, '\.')
    exe 'tag '.sm[len(sm)-1]
    return
  endif
endfunc

aug vimrc_go
  au!
  au FileType go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  au FileType go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  au FileType go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
aug END

aug vimrc_python
  au!
  au FileType python let b:delimitMate_nesting_quotes = ['"']
  au FileType python nmap <silent> <buffer> <leader>i :update<CR>:Isort<CR>:ImportRemove<CR>
  au FileType python nmap <silent> <buffer> ]s :call <SID>super()<CR>
  au FileType python nmap <silent> <buffer> [s <C-^>
  " au FileType python syn sync match pythonSync grouphere NONE '):$'
  " au FileType python setlocal equalprg=yapf
aug END

aug vimrc_cpp
  au!
  au FileType c,cpp,objc,objcpp command! A call s:a('e')
  au FileType c,cpp,objc,objcpp command! AV call s:a('botright vertical split')
  au FileType c,cpp,objc,objcpp setlocal equalprg=clang-format formatprg=clang-format
  au FileType c,cpp,objc,objcpp nmap <buffer> <silent> [a :lprevious<CR>
        \ | nmap <buffer> <silent> ]a :lnext<CR>
        \ | nmap <buffer> <silent> [A :lfirst<CR>
        \ | nmap <buffer> <silent> ]A :llast<CR>
  au FileType c,cpp,objc,objcpp,go nmap <buffer> <silent> <leader>a :A<CR>
  au FileType c,cpp,objc,objcpp,cs,java,actionscript,glsl,dot setlocal commentstring=//\ %s
  au FileType cmake setlocal commentstring=#\ %s
  au FileType c,vim silent! nunmap <buffer> K
  au FileType c setlocal keywordprg=:Vman
  " au BufWrite *.cc,*.cpp,*.c call <SID>preserve("normal! gg=G")
aug END

aug vimrc_tab
  au!
  au FileType python setlocal noexpandtab ts=4 sw=4
  au FileType tex setlocal ts=2 sw=2
  au FileType vim setlocal expandtab ts=2 sw=2
  au FileType lua setlocal expandtab ts=2 sw=2
  au FileType make setlocal noexpandtab
aug END

aug vimrc_misc
  au!
  au FileType help wincmd L | nnoremap <buffer><silent> q :q
  au FileType git,gitcommit setlocal foldmethod=syntax
  au FileType leaderf setlocal nonumber
  au BufRead *gl.vs,*gl.ps setlocal ft=glsl iskeyword=@,48-57,_,128-167,224-235
  au BufRead .clang-format setlocal ft=yaml
  au BufRead *.jsfl setlocal ft=actionscript
  au QuickFixCmdPost * botright cwindow 9
  au BufWritePost *vimrc,*.vim so % | setlocal expandtab ts=2 sw=2
  au InsertLeave * set imi=0
        " \ | set cursorline
  " au InsertEnter * set nocursorline
  " au WinEnter * setlocal cursorline
  " au WinLeave * setlocal nocursorline
  " au BufWinEnter * if &buftype == 'terminal' | nnoremap <buffer> <leader>q a<C-W><C-c> | endif
aug END

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

if has('gui_running')
  func! s:get_buffer_list()
    redir =>buflist
    silent! ls
    redir END
    return buflist
  endfunc

  func! s:toggle_term()
    let buflist = <SID>get_buffer_list()
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
  endfunc

  nnoremap <silent> <C-z> :call <SID>toggle_term()<CR>
  tnoremap <C-z> <C-w>N<C-^>

  if has('win32')
    let g:prog_name = '!start gvim'
  elseif has('mac')
    let g:prog_name = 'silent !mvim'
  endif

  command! -nargs=0 -complete=command New execute g:prog_name
  command! -nargs=0 -complete=command Restart execute g:prog_name . " %" | quitall
endif

inoremap <C-^> <Esc><C-^>
inoremap <M-o> <C-o>o
inoremap <M-O> <C-o>O
inoremap <C-l> <C-o>zz
inoremap <C-k> <C-o>k
inoremap <C-j> <C-o>j

tnoremap <Esc> <C-W>N
tnoremap <C-^> <C-W>N<C-^>
tnoremap <C-h> <C-w>h
tnoremap <C-l> <C-w>l
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k

nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

nnoremap <M-q> qq
nnoremap Q @q
xnoremap Q :normal @q<CR>
xnoremap . :normal .<CR>

vnoremap < <gv
vnoremap > >gv
nnoremap gV `[v`]
nnoremap Y y$

nnoremap <C-e> 10j
nnoremap <C-y> 10k
nnoremap <silent> <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

if has("mac")
  set linespace=4
  if !has('nvim')
    set guifont=SF\ Mono:h12
    " set macligatures
    " set guifont=Fira\ Code:h12
    set macthinstrokes
    set macmeta
  endif
elseif has("win32")
  set path=,,.
  set guifont=Monaco:h9
  set linespace=4
  set gfw=Microsoft\ Yahei\ Mono:h9
  if !has('nvim')
    set rop=type:directx,gamma:1.1
  else
    let g:Guifont="Monaco:h9"
  endif

  let s:tortoise_svn_path = '"C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe"'
  func! s:svn_command(cmd, path)
    execute 'silent! !start '. s:tortoise_svn_path. ' /command:'. a:cmd. ' /path:"'. a:path. '"'
  endfunc
  nnoremap <silent> <leader>tu :call <SID>svn_command('update /closeonend:3', expand('%:p'))<CR>
  nnoremap <silent> <leader>tw :call <SID>svn_command('commit /closeonend:3', expand('%:p'))<CR>
  nnoremap <silent> <leader>tc :call <SID>svn_command('commit /closeonend:3', getcwd())<CR>
  nnoremap <silent> <leader>tx :call <SID>svn_command('cleanup /closeonend:3', expand('%:p:h'))<CR>
  nnoremap <silent> <leader>tm :call <SID>svn_command('update /closeonend:3', getcwd())<CR>
  nnoremap <silent> <leader>tb :call <SID>svn_command('blame /line:'. line('.'), expand('%:p'))<CR>
  nnoremap <silent> <leader>tl :call <SID>svn_command('log', expand('%:p'))<CR>
  nnoremap <silent> <leader>ta :call <SID>svn_command('add', expand('%:p'))<CR>
  nnoremap <silent> <leader>td :call <SID>svn_command('diff', expand('%:p'))<CR>
  nnoremap <silent> <leader>tr :call <SID>svn_command('revert', expand('%:p'))<CR>
endif

nmap <silent> <leader>q :bd<CR>
nmap <silent> <leader>w :tabclose<CR>

func! s:make_args(args)
  let cmd = ''
  let bin = expand('%:p:r')
  if &filetype == 'python'
    let cmd = "python %"
  elseif &filetype == 'cpp'
    let cmd = 'make CC="g++" CXXFLAGS="-std=c++14" '. bin . ' && ' . bin
  elseif &filetype == 'c'
    let cmd = 'make '. bin .' && '. bin
  else
    let cmd = "make %<"
  endif
  return cmd.' '.a:args
endfunc

func! s:run(args)
  exe '!'.<SID>make_args(a:args)
endfunc

func! s:async_run(args)
  exe 'AsyncRun '.<SID>make_args(a:args)
endfunc

nnoremap <silent> <leader>xm :update<CR>:call <SID>async_run('')<CR>
nnoremap <silent> <leader>xx :AsyncStop<CR>

command! -nargs=* -complete=command Run call s:run(<q-args>)
command! -nargs=0 -complete=command ImportRemove update | AsyncRun -post=e autoflake --in-place --remove-all-unused-imports %<CR>

command! Only %bd|e#
command! JsonPrettier %!python -m json.tool
command! Todo exec "Grep 'TODO: " . s:username . "'"

nnoremap <M-p> "0p

cnoremap <C-p> <UP>
cnoremap <C-n> <DOWN>

nnoremap <leader>en :tabe ~/Dropbox/notes<CR>:lcd %:h<CR>:pwd<CR>
nnoremap <leader>es :tabe $VIMFILES/UltiSnips<CR>:lcd %:h<CR>:pwd<CR>

cab ar AsyncRun
cab GP GoProject
cab Gp GoProject

nnoremap <leader>cd :lcd %:h<CR>:pwd<CR>

func! s:preserve(command)
  let _s=@/
  let l:winview = winsaveview()
  execute 'silent '.a:command
  call winrestview(l:winview)
  let @/=_s
endfunc

nmap _$ :call <SID>preserve("%s/\\s\\+$//e")<CR>
nmap _= :call <SID>preserve("normal! gg=G")<CR>

func! s:indent_len(str)
  return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
endfunc

func! s:indent_object(op, skip_blank, b, e, bd, ed)
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
endfunc
xnoremap <silent> ii :<C-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), 0, 0)<CR>
onoremap <silent> ii :<C-u>call <SID>indent_object('>=', 1, line('.'), line('.'), 0, 0)<CR>
xnoremap <silent> ai :<C-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), -1, 0)<CR>
onoremap <silent> ai :<C-u>call <SID>indent_object('>=', 1, line('.'), line('.'), -1, 0)<CR>
xnoremap <silent> io :<C-u>call <SID>indent_object('==', 0, line("'<"), line("'>"), 0, 0)<CR>
onoremap <silent> io :<C-u>call <SID>indent_object('==', 0, line('.'), line('.'), 0, 0)<CR>
xnoremap <silent> ao :<C-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), -1, 1)<CR>
onoremap <silent> ao :<C-u>call <SID>indent_object('>=', 1, line('.'), line('.'), -1, 1)<CR>

func! s:tab_message(cmd)
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
endfunc
command! -nargs=+ -complete=command TabMessage call s:tab_message(<q-args>)

func! s:source_if_exists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunc

call s:source_if_exists($VIMFILES.'/.localrc')

