source $VIMRUNTIME/defaults.vim

let mapleader = ","
let maplocalleader = ","

set encoding=utf-8
set fileencoding=utf-8

let $vimfiles=split(&rtp, ",")[0]
call plug#begin($vimfiles . '/bundle')
Plug 'xltan/vim-hybrid'

Plug 'tpope/tpope-vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-markdown'
let g:markdown_fenced_languages = ['cpp', 'go', 'python', 'sh']

let delimitMate_expand_cr = 1
let delimitMate_jump_expansion = 1
Plug 'Raimondi/delimitMate'

Plug 'tpope/vim-endwise'

let g:detectindent_preferred_when_mixed = 1
let g:detectindent_max_lines_to_analyse = 128
Plug 'ciaranm/detectindent'

let g:targets_aiAI = 'ai  '
Plug 'wellle/targets.vim'

if has('mac')
  Plug 'wookayin/vim-typora'
  Plug 'rizzatti/dash.vim'
  nmap <silent> K <Plug>DashSearch

  " fugitive is slow on windows
  Plug 'tpope/vim-fugitive'
  let g:dash_map = {
  \ 'java' : 'android',
  \ 'cpp' : 'gl4',
  \ 'go' : 'gl4',
  \ 'c' : 'gl4',
  \ }
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

Plug 'mbbill/undotree'
nnoremap <silent> <leader>u :UndotreeToggle<CR>

Plug 'kana/vim-niceblock'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/linediff.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:snips_author = "sinon"
let g:snips_email = "lidmuse@email.com"
let g:snips_github = "https://github.com/xltan"
" Plug 'dawikur/algorithm-mnemonics.vim'

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
  " silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d
  nnoremap <silent><buffer> gs :sort ,^.*[\/],<CR>
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
let g:lt_height = 9

Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

Plug 'junegunn/vim-emoji'

if has('mac') || has('win32')
  let g:ycm_min_num_of_chars_for_completion = 3
  let g:ycm_max_num_identifier_candidates = 8
  let g:ycm_enable_diagnostic_highlighting = 0
  let g:ycm_confirm_extra_conf = 0
  let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
  let g:ycm_key_list_select_completion = ['<C-N>', '<DOWN>']
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_complete_in_comments = 1
  let g:ycm_always_populate_location_list = 1
  " let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:ycm_error_symbol = '>>'
  let g:ycm_warning_symbol = '--'
  Plug 'Valloric/YouCompleteMe' " , { 'frozen' : 1 }
  nmap <silent> gd :YcmCompleter GoTo<CR>
  nmap <silent> gz :YcmCompleter FixIt<CR>

  function! YcmOnDeleteChar()
    if pumvisible()
      return "\<C-y>\<Plug>delimitMateBS"
    endif
    return "\<Plug>delimitMateBS"
  endfunction
  imap <expr><BS> YcmOnDeleteChar()

  Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

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
        \ 'mail' : 1
        \}
endif

Plug 'w0rp/ale'
let g:ale_linters = {
\   'python': ['flake8'],
\   'go': ['golint'],
\   'c': [], 'cpp': [], 'objcpp': [], 'objc': [],
\}
" let g:ale_sign_error = '>'
" let g:ale_sign_warning = '-'
" let g:ale_lint_on_text_changed = 'never'

" Plug 'maralla/validator.vim'
" let g:validator_error_symbol = '>'
" let g:validator_warning_symbol = '-'
" let g:validator_go_checkers = ['gometalinter']
" let g:validator_ignore = ['c', 'cpp']

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

Plug 'lilydjwg/colorizer'
let g:colorizer_startup = 0
let g:colorizer_maxlines = 100
let g:colorizer_nomap = 1
nmap <Leader>co <Plug>Colorizer

if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

Plug 'Yggdroot/LeaderF' ", { 'branch': 'dev'}
let g:Lf_WindowPosition = 'bottom'
let g:Lf_ShortcutF = '<C-P>'
let g:Lf_WindowHeight = 0.25
if !exists('g:Lf_CommandMap')
  let g:Lf_CommandMap = {
      \ '<ESC>': ['<C-I>'],
      \ '<C-C>': ['<Esc>', '<C-C>'],
      \ '<C-]>': ['<C-V>'],
      \ '<C-X>': ['<C-S>'],
      \ '<C-V>': ['<C-Q>'],
      \ '<C-P>': ['<C-O>'],
      \}
endif
let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_WildIgnore = {
    \ 'dir': ['.svn','.git','.hg','bin'],
    \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]','tags']
    \}
let g:Lf_PreviewResult = { 'BufTag': 0, 'Function': 0 }
let g:Lf_UseCache = 1
let g:Lf_NeedCacheTime = 0.3
let g:Lf_CursorBlink = 0
let g:Lf_StlPalette = {
    \'stlName': {
    \    'gui': 'NONE',
    \    'guifg': '#c6cace',
    \    'guibg': '#232c31',
    \},
    \'stlCategory': {
    \    'guifg': '#c6cace',
    \    'guibg': '#232c31',
    \},
    \'stlNameOnlyMode': {
    \    'guifg': '#c6cace',
    \    'guibg': '#232c31',
    \},
    \'stlFullPathMode': {
    \    'guifg': '#c6cace',
    \    'guibg': '#232c31',
    \},
    \'stlFuzzyMode': {
    \    'guifg': '#c6cace',
    \    'guibg': '#232c31',
    \},
    \'stlRegexMode': {
    \    'guifg': '#c6cace',
    \    'guibg': '#232c31',
    \},
    \'stlCwd': {
    \    'guifg': '#c6cace',
    \    'guibg': '#232c31',
    \},
    \'stlBlank': {
    \    'guifg': '#c6cace',
    \    'guibg': '#232c31',
    \},
    \'stlLineInfo': {
    \    'guifg': '#c6cace',
    \    'guibg': '#232c31',
    \},
    \'stlTotal': {
    \    'guifg': '#c6cace',
    \    'guibg': '#232c31',
    \}
    \}

nnoremap <leader>h :LeaderfMru<CR>
nnoremap <leader>b :LeaderfBufTag<CR>
nnoremap <leader>tg :LeaderfTag<CR>
nnoremap <leader>: :LeaderfHistoryCmd<CR>
nnoremap <leader>/ :LeaderfHistorySearch<CR>

Plug 'xltan/LeaderF-tjump'

Plug 'mattboehm/vim-unstack'
nnoremap <C-x> :UnstackFromClipboard<CR>

Plug 'junegunn/goyo.vim'
let g:goyo_width = 150
let g:goyo_linenr = 1

" Plug 'editorconfig/editorconfig-vim'

" language related
" Plug 'rust-lang/rust.vim'
" let g:rustfmt_autosave = 0
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

unlet c_comment_strings
let c_no_curly_error = 1

let g:cpp_no_function_highlight = 0
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'fatih/vim-go'
let g:go_def_mode = 'godef'
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"

Plug 'pboettch/vim-cmake-syntax'
Plug 'mattn/emmet-vim'
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key='<C-j>'

Plug 'milinnovations/vim-actionscript'
Plug 'tikhomirov/vim-glsl'

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

nmap <silent> [a <Plug>(ale_previous_wrap)
nmap <silent> ]a <Plug>(ale_next_wrap)

" words:
inoremap <M-t> <esc>diwbPa <esc>ea
if !has("gui_running") " from tpope/vim-rsi
  silent! exe "set <F36>=\<esc>t"
  map! <F36> <M-t>
  map <F36> <M-t>
endif

let g:unstack_populate_quickfix=1
let g:unstack_extractors = [
    \ unstack#extractors#Regex('\v^[^ ]?.* *File "([cC]:\\g4\\trunk)=[\/\\]([^"]+)", line ([0-9]+).*', '\2', '\3'),
    \ unstack#extractors#Regex('\v^ *File "([^"]+)", line ([0-9]+).*', '\1', '\2'),
    \ unstack#extractors#Regex('\v^[^ ]?.* *File "([^"]+)", line ([0-9]+).*', 'client/\1', '\2'),
    \ unstack#extractors#Regex('\v^[^ ]?.* ([^ ]+): ([0-9]+).+', 'client/\1', '\2'),
    \ ] + unstack#extractors#GetDefaults()

set synmaxcol=500

if has("termguicolors")
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

aug colortheme
  autocmd ColorScheme * hi! link pythonFunction Normal
aug END

set background=dark
let g:hybrid_less_color = 0
colorscheme hybrid

set guioptions=
set statusline=%<%f\ %h%m%r%=\ %{'['.(&fenc!=''?&fenc:&enc).','.&ff.']'}\ %-14.(%l,%c%V%)\ %P

" set cursorline
set nu
set hlsearch
set nowrap

set listchars=tab:\|\ ,eol:¬

set autoindent
set expandtab smarttab
set sw=2 ts=2

set laststatus=2

set hidden
set autowrite
set autoread

set nobackup
set backupdir=$HOME/.swap
set directory=$HOME/.swap//
set undodir=$HOME/.undo
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
set wildignore=*.pyc,*.pyo,*.exe,.DS_Store,._*,.svn,.git,.vscode,tags
set cpoptions+=>
set belloff=all
set history=1000

function! s:super()
  if &filetype == 'python'
    let pattern = '^class [^(]*(\zs[^)]*\ze):'
    let lineno = search(pattern, 'n')
    let content = getline(lineno)
    let m = matchstr(content, pattern)
    let sm = split(m, '\.')
    exe 'tag '.sm[len(sm)-1]
    return
  endif
endfunction
noremap <silent> ]s :call <SID>super()<CR>
noremap <silent> [s <C-^>

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

aug go
  autocmd!
  autocmd FileType go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd FileType go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd FileType go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
aug END

aug python
  autocmd!
  autocmd FileType python let b:delimitMate_nesting_quotes = ['"']
  autocmd FileType python nmap <silent><leader>a :call ToggleAlternateFile(expand('%:p'))<CR>
  " autocmd FileType python setlocal equalprg=yapf
aug END


aug cpp
  autocmd!
  autocmd FileType c,cpp,objc,objcpp DetectIndent
  autocmd FileType c,cpp,objc,objcpp setlocal equalprg=clang-format formatprg=clang-format
  autocmd FileType c,cpp,objc,objcpp,go nmap <buffer> <silent> <leader>a :A<CR>
  autocmd FileType c,cpp,objc,objcpp,cs,java,actionscript,glsl setlocal commentstring=//\ %s
  autocmd FileType cmake setlocal commentstring=#\ %s
  autocmd FileType c,cpp,objc,objcpp,actionscript,go,python nmap <buffer> <C-]> :LeaderfTjump <C-r><C-w><CR>
  " autocmd BufWrite *.cc,*.cpp,*.c call <SID>preserve("normal! gg=G")
aug END

aug vimrc_tab
  autocmd!
  autocmd FileType python,go,actionscript setlocal noexpandtab ts=4 sw=4
  autocmd FileType tex setlocal ts=2 sw=2
  autocmd FileType make setlocal noexpandtab
aug END

aug vimrc_misc
  autocmd!
  autocmd FileType html,css EmmetInstall
  autocmd FileType help wincmd L
  autocmd FileType git setlocal nonumber
  autocmd BufRead *gl.vs,*gl.ps setlocal ft=glsl iskeyword=a-z,A-Z,48-57,_,.,-,>
  autocmd BufRead .clang-format setlocal ft=yaml
  autocmd QuickFixCmdPost * botright cwindow 9
  autocmd BufWritePost *.vim,*vimrc so %
  autocmd InsertLeave * set iminsert=0
  " autocmd WinLeave,InsertEnter * setlocal nocursorline
  " autocmd WinEnter * setlocal cursorline
  " autocmd BufWinEnter * if &buftype == 'terminal' | nnoremap <buffer> <leader>q a<C-W><C-c> | endif
aug END

nnoremap <silent> cos :if exists("g:syntax_on") <Bar>
	\   syntax off <Bar>
	\ else <Bar>
	\   syntax enable <Bar>
	\ endif <CR>

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

set termkey=<C-B>

tnoremap <Esc> <C-B>N
tnoremap <C-^> <C-B>N<C-^>
tnoremap <C-h> <C-B>h
tnoremap <C-l> <C-B>l
tnoremap <C-j> <C-B>j
tnoremap <C-k> <C-B>k
tnoremap <C-\> <C-B>N:%y\|tabnew\|setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified\|normal P<CR>
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
  tnoremap <C-z> <C-B>N<C-^>
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

inoremap <C-l> <C-o>zz

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
  set linespace=1
  set guifont=SF\ Mono:h12
  " set guifont=Fira\ Code:h12
  " set macligatures
  set macthinstrokes
  set macmeta
elseif has("win32")
  set linespace=3
  set guifont=Monaco:h9
  set gfw=Microsoft\ Yahei\ Mono:h9
  set rop=type:directx,gamma:1.6,scrlines:30
  " nnoremap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
	nnoremap <M-f> :simalt ~x<CR>
  aug windows
    autocmd!
    autocmd GUIEnter * simalt ~x
  aug END

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

nnoremap <silent> <leader>q :bd<CR>
nnoremap <silent> <leader>w :tabclose<CR>

function! s:make_args(args)
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
endfunction

function! s:run(args)
  exe '!'.<SID>make_args(a:args)
endfunction

function! s:async_run(args)
  exe 'AsyncRun '.<SID>make_args(a:args)
endfunction

command! -nargs=* -complete=command Run call s:run(<q-args>)
command! -nargs=0 -complete=command Clean :silent !rm %<
nnoremap <silent> <leader>xm :call <SID>async_run('')<CR>
nnoremap <silent> <leader>xc :execute 'AsyncRun ctags '.<SID>GenTagArgument()<CR>
nnoremap <silent> <leader>xx :AsyncStop<CR>
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
nnoremap <leader>pj :%!python -m json.tool<CR>

function! s:preserve(command)
  let _s=@/
  let l:winview = winsaveview()
  execute 'silent '.a:command
  call winrestview(l:winview)
  let @/=_s
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
command! -nargs=+ -complete=command TabMessage call s:tab_message(<q-args>)

