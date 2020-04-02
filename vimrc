if !has('nvim')
  source $VIMRUNTIME/defaults.vim
else
  let g:loaded_python_provider = 1
  " let g:python3_host_prog = "/usr/local/bin/python3"
  aug nvim
    au!
    au BufRead *
      \ if search('\M-*- C++ -*-', 'n', 1) | setlocal ft=cpp | endif
      \ | if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
  aug END
endif

set exrc

command! -nargs=+ SilentExt execute 'silent !'. <q-args> | redraw!
command! -nargs=+ Silent execute 'silent <args>' | redraw!

func! s:code(args)
  let args = a:args
  if len(args) == 0
    let args = '.'
  endif
  exec 'silent !code -r ' . args
endfunc

command! -nargs=? Code call s:code(<q-args>)

let mapleader = ","
let maplocalleader = ","
let s:username = "Sinon"

set encoding=utf-8
set fileencoding=utf-8

let $VIMFILES=split(&rtp, ",")[0]
set rtp+=$HOME/.fzf
call plug#begin($VIMFILES . '/bundle')
Plug 'arcticicestudio/nord-vim'
Plug 'chriskempson/base16-vim'
Plug 'arzg/vim-colors-xcode'

" Plug 'Raimondi/delimitMate'
" let delimitMate_expand_cr = 1
" let delimitMate_matchpairs = "(:),[:],{:}"

Plug 'tpope/vim-characterize'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-obsession'
" Plug 'tpope/vim-endwise'
inoremap (<CR> (<CR>)<Esc>O
inoremap {<CR> {<CR>}<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap {; {<CR>};<Esc>O
inoremap {, {<CR>},<Esc>O
inoremap [; [<CR>];<Esc>O
inoremap [, [<CR>],<Esc>O

Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
let g:fugitive_gitlab_domains = ['https://git.garena.com']

Plug 'junegunn/gv.vim'
Plug 'junegunn/fzf.vim'
let $FZF_DEFAULT_COMMAND="fd --type f --color never --exclude /vendor"
let g:fzf_preview_window = 'right:60%'
nnoremap <leader>f :Files<CR>
nnoremap <leader>r :Files %:h<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>v :Lines<CR>

nnoremap <leader>j :BTags<CR>
nnoremap <leader>gt :Tags<CR>
nnoremap <leader>: :History:<CR>
nnoremap <leader>/ :History/<CR>

" nnoremap <leader>gh :LeaderfMru<CR>
"
let fzf_use_floating_window = 1

let s:fzf_floating_window_height = min([20, &lines])
if has('nvim')
  function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    " call setbufvar(buf, '&syntax', 'off')

    let height = s:fzf_floating_window_height
    let width = min([160, float2nr(&columns - (&columns * 2 / 12))])
    let col = float2nr((&columns - width) / 2)
    let row = float2nr((&lines - height) / 2)
    let opts = {
          \ 'relative': 'editor',
          \ 'row': row,
          \ 'col': col,
          \ 'width': width,
          \ 'height': height,
          \ 'style': 'minimal'
          \ }
    let win = nvim_open_win(buf, v:true, opts)
    call setwinvar(win, '&diff', 0)
  endfunction
  Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
  let g:nvimgdb_config_override = {
  \ 'key_next': 'n',
  \ 'key_step': 's',
  \ 'key_finish': 'f',
  \ 'key_continue': 'c',
  \ 'key_until': '<space>',
  \ 'key_breakpoint': 'b',
  \ 'set_tkeymaps': "NvimGdbNoTKeymaps",
  \ }
else
  " function! FloatingFZF()
  "   let height = s:fzf_floating_window_height
  "   let width = min([120, float2nr(&columns - (&columns * 2 / 10))])
  "   " let col = float2nr((&columns - width) / 2)
  "   " let row = float2nr((&lines - height) / 2)
  "   let opts = {
  "         \ 'maxwidth': width,
  "         \ 'maxheight': height
  "         \ }
  "   call popup_dialog("fzf", opts)
  " endfunction
endif

let $FZF_DEFAULT_OPTS='--inline-info --layout=reverse'
"\ --preview "head -' . string(s:fzf_floating_window_height - 2) . ' {}"'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

aug fzf
  au!
  au FileType fzf tnoremap <silent><buffer> <Esc> <C-c>
        \| tnoremap <silent><buffer> <C-j> <C-n>
        \| tnoremap <silent><buffer> <C-k> <C-p>
        \| tnoremap <silent><buffer> <C-h> <BS>
        \| tnoremap <silent><buffer> <C-l> <C-c>
  if !fzf_use_floating_window
    au FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  endif
aug END

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function! s:open_file(lines)
  exec 'silent !open ' . a:lines[0]
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-x': function('s:open_file'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'CursorLine'],
  \ 'hl':      ['fg', 'ALEErrorSign'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'Normal', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'ALEErrorSign'],
  \ 'info':    ['fg', 'Comment'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Comment'],
  \ 'pointer': ['fg', 'ALEErrorSign'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

Plug 'junegunn/vim-easy-align'
vmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)

Plug 'xltan/lightline-colors.vim'
Plug 'itchyny/lightline.vim'
function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  let coc_status = get(g:, 'coc_status', '')
  if empty(msgs) | return coc_status | endif
  return join(msgs, ' ') . ' ' . coc_status
endfunction
let g:lightline = {
      \ 'colorscheme': 'tomorrow2',
      \ 'active': {
		  \   'left': [ [ 'paste' ],
		  \           [ 'readonly', 'relativepath', 'modified', 'cocstatus', 'method' ] ],
      \  'right': [ [ 'percentwin' ],
      \            [ 'lineinfo' ],
      \            [ 'mode' ]]
      \ },
      \ 'inactive': {
		  \   'left': [ [ 'relativepath' ] ],
      \ },
      \ 'mode_map': {
		  \    'n':      'N',
		  \    'i':      'I',
		  \    'R':      'R',
		  \    'v':      'V',
		  \    'V':      'L',
		  \    "\<C-v>": 'B',
		  \    'c':      'C',
		  \    's':      'S',
		  \    'S':      'S',
		  \    "\<C-s>": 'S',
		  \    't':      'T',
		  \ },
      \ 'component_function': {
      \   'cocstatus': 'StatusDiagnostic',
      \ },
      \ }
      

Plug 'christoomey/vim-tmux-navigator'
Plug 'jpalardy/vim-slime'
if has('win32')
  let g:slime_target = "vimterminal"
else
	let g:slime_target = "tmux"
  let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}
  let g:slime_dont_ask_default = 1
endif

Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_math = 1
let g:tex_conceal = 0

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
Plug 'dhruvasagar/vim-table-mode'
let g:table_mode_map_prefix = '<Leader>y'
let g:table_mode_corner='|'
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'

function! s:get_current_word(pattern)
  let line = getline('.')
  let npos = col('.') - 1
  let ppos = npos
  let pattern = printf('[0-9A-Za-z_%s]', a:pattern)
  while ppos >= 0
    if match(line[ppos], pattern) == -1
      break
    endif
    let ppos -= 1
  endwhile
  while npos < len(line)
    if match(line[npos], pattern) == -1
      break
    endif
    let npos += 1
  endwhile
  return line[ppos+1:npos-1]
endfunction

function! s:std_get_commands(args)
  if len(a:args) > 0
    let word = a:args
  else
    let word = s:get_current_word(':')
  endif
  if word =~ "^std"
    return 'silent !rustup doc '. word
  endif

  return 'OpenBrowserSearch -rs '. word
endfunction

command! -bang -nargs=* -complete=command Doc execute <SID>std_get_commands(<q-args>)
command! -bang -nargs=* -complete=command Rs execute 'OpenBrowserSearch -rsd ' . <SID>get_current_word(':')

let g:targets_aiAI = 'ai  '
let g:targets_quotes = '"d '' `'
Plug 'wellle/targets.vim'

Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_fold_enabled = 0
let g:vimtex_view_general_callback = 'ViewerCallback'
Plug 'vim/killersheep'

function! ViewerCallback(status) dict
  if a:status
    VimtexView
  endif
endfunction
if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
endif
aug vimtex_config
  au!
  au User VimtexEventQuit call vimtex#compiler#clean(0)
  " au User VimtexEventInitPost call vimtex#compiler#compile()
aug END

Plug 'editorconfig/editorconfig-vim'

let g:scratch_horizontal = 0
let g:scratch_height = 100
let g:scratch_no_mappings = 1
let g:scratch_filetype = 'markdown'
let g:scratch_persistence_file = $VIMFILES . '/.scratch.md'
Plug 'mtth/scratch.vim'

nmap gs :Scratch<CR>
xmap gs <plug>(scratch-selection-reuse)

Plug 'mhinz/vim-signify'
let g:signify_vcs_list = ['git', 'svn']

omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-inner-pending)
xmap ac <plug>(signify-motion-inner-visual)

nnoremap [r :SignifyRefresh<CR>
nnoremap ]r :SignifyToggle<CR>

Plug 'mbbill/undotree'
nnoremap <silent> <leader>u :UndotreeToggle<CR>

Plug 'kana/vim-niceblock'

Plug 'haya14busa/vim-asterisk'
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map z#  <Plug>(asterisk-z#)
" map gz* <Plug>(asterisk-gz*)
" map gz# <Plug>(asterisk-gz#)
" Plug 'haya14busa/vim-edgemotion'
" map <C-j> <Plug>(edgemotion-j)
" map <C-k> <Plug>(edgemotion-k)

Plug 'AndrewRadev/linediff.vim'

Plug 'SirVer/ultisnips'
" let g:UltiSnipsUsePythonVersion = 3
" let g:UltiSnipsExpandTrigger = '<C-j>'
Plug 'xltan/algorithm-mnemonics.vim'
let g:algorithm_mnemonics_lambda_parameter = ""

Plug 'honza/vim-snippets'
let g:snips_author = s:username
let g:snips_email = "lidmuse@email.com"
let g:snips_github = "https://github.com/xltan"

Plug 'xltan/vim-extra-snippets'

Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = [ 'tags' ]
" '.git', '.svn', '.gutctags', '.clang-format', '.ignore']
let g:gutentags_exclude_project_root = ['/usr/local', $HOME, $HOME.'/Documents']

if !has('win32')
  " let g:gutentags_cache_dir = $VIMFILES . '/.cache'
  if !has('nvim')
    Plug 'vim-utils/vim-man'
  endif
endif

" Plug 'tpope/vim-vinegar'
Plug 'justinmk/vim-dirvish'
" func! s:setup_dirvish()
  " silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d
  " silent! unmap <silent><buffer> <C-p>
  " nnoremap <silent><buffer> q :bd<CR>
  " nnoremap <silent><buffer> o :call dirvish#open("p", 1)<CR><C-w>p
  " nnoremap <silent><buffer> gs :sort ,^.*[\/],<CR>:set conceallevel=3<CR>
  " nnoremap <silent><buffer> gr :noau Dirvish %<CR>
  " nnoremap <silent><buffer> gh :Silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d<CR>:set conceallevel=3<CR>
  " if has('win32')
  "   nnoremap <silent><buffer> gx :SilentExt start <C-R><C-L><CR>
  " else
  "   nnoremap <silent><buffer> gx :SilentExt open <C-R><C-L><CR>
  " endif
  " nnoremap <buffer> t :call dirvish#open('tabedit', 0)<CR>
  " xnoremap <buffer> t :call dirvish#open('tabedit', 0)<CR>
" endfun

" aug dirvish
"   au!
"   au FileType dirvish call <SID>setup_dirvish()
" aug END

" func! DirvishSetup()
"   let text = getline('.')
"   let xp = []
"   for item in split(&wildignore, ',')
"     call add(xp, glob2regpat(item).'\=')
"   endfor
"   exec 'silent keeppatterns g/\(' . join(xp, '\|'). '\|[\/|\\]tags' . '\)/d _'
"   exec 'sort ,^.*[\/],'
" endfunc
" let g:dirvish_mode = 'call DirvishSetup()'

nnoremap <silent><C-e> :<C-U>exe 'vsplit +Dirvish\ %:p'.repeat(':h',v:count1)<CR>

Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
map <M-;> <Plug>Sneak_,

Plug 'justinmk/vim-gtfo'
let g:gtfo#terminals = { 'win': 'cmd.exe /k' }
if has('win32')
  nmap gox :SilentExt start %<CR>
else
  nmap gox :SilentExt open %<CR>
endif
cnoremap %% <C-R>=fnameescape(expand('%:h'))<CR>
nmap gon :sav %%/

Plug 'Valloric/ListToggle'
let g:lt_quickfix_list_toggle_map = '<leader>z'
let g:lt_height = 9

let s:error_symbol = '>'
let s:warning_symbol = '-'

" Plug 'Valloric/YouCompleteMe', { 'frozen' : 1 }
" let g:ycm_enable_diagnostic_highlighting = 0
" let g:ycm_min_num_of_chars_for_completion = 3
" " let g:ycm_max_num_candidates = 25
" let g:ycm_max_num_identifier_candidates = 6
" let g:ycm_confirm_extra_conf = 0
" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
" let g:ycm_key_list_select_completion = ['<C-N>', '<DOWN>']
" let g:ycm_collect_identifiers_from_comments_and_strings = 1
" let g:ycm_complete_in_comments = 1
" let g:ycm_always_populate_location_list = 1
" let g:ycm_error_symbol = s:error_symbol
" let g:ycm_warning_symbol = s:warning_symbol
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_use_ultisnips_completer = 0
" let g:ycm_filetype_whitelist = { 'cpp' : 1, 'c' : 1 }
" let g:ycm_filetype_blacklist = {
"     \ 'tagbar' : 1,
"     \ 'qf' : 1,
"     \ 'notes' : 1,
"     \ 'markdown' : 1,
"     \ 'unite' : 1,
"     \ 'text' : 1,
"     \ 'vimwiki' : 1,
"     \ 'pandoc' : 1,
"     \ 'infolog' : 1,
"     \ 'ctrlsf' : 1,
"     \ 'mail' : 1,
"     \ 'project' : 1,
"     \ 'scratch' : 1,
"     \}
" nmap <silent> gd :YcmCompleter GoTo<CR>
" nmap <silent> gz :YcmCompleter FixIt<CR>
"
" func! YcmOnDeleteChar()
"   if pumvisible()
"     return "\<C-y>\<Plug>delimitMateBS"
"   endif
"   return "\<Plug>delimitMateBS"
" endfunc
" imap <expr><BS> YcmOnDeleteChar()

" if has('win32')
"   Plug 'xltan/YcmGen'
" else
"   Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
"   command! -nargs=? -complete=file_in_path -bang YcmGen YcmGenerateConfig -f
" endif

" Plug 'w0rp/ale'
" let g:ale_linters = {
" \   'python': ['flake8'],
" \   'go': ['golint'],
" \   'javascript': ['standard'],
" \   'c': [], 'cpp': [], 'objcpp': [], 'objc': [], 'markdown': [], 'java': []
" \}
" let g:ale_fixers = {'javascript': ['standard']}
" let g:ale_sign_error = s:error_symbol
" let g:ale_sign_warning = s:warning_symbol
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_save = 1
" let g:ale_fix_on_save = 1

" Plug 'liuchengxu/vista.vim'
" let g:vista_icon_indent = ["▸ ", ""]
" let g:vista_default_executive = 'ctags'
" let g:vista_executive_for = {
"     \ 'markdown': 'toc',
"     \ 'go': 'coc',
"     \ }

" " let g:vista_echo_cursor_strategy = 'floating_win'
" nnoremap <leader>j :Vista finder<CR>
" nnoremap <leader>tt :Vista!!<CR>

" function! NearestMethodOrFunction() abort
"   return get(b:, 'vista_nearest_method_or_function', '')
" endfunction

Plug 'neoclide/coc.nvim', {'branch': 'release'}
nmap <silent> ]v :CocNext<CR>
nmap <silent> [v :CocPrev<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-rename)
nmap <silent> gz <Plug>(coc-fix-current)
nmap <silent> gh :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
inoremap <silent><expr> <C-n>
      \ pumvisible() ? "\<C-n>" :
      \ coc#refresh()
inoremap <silent><expr> <cr>
      \ pumvisible() ? "\<C-y>\<cr>" :
      \ "\<cr>"
vmap <silent>= <Plug>(coc-format-selected)
map <silent>_= <Plug>(coc-format)
command! -nargs=0 Format :call CocAction('format')
omap if <Plug>(coc-funcobj-i)
xmap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
xmap af <Plug>(coc-funcobj-a)

Plug 'tyru/open-browser.vim'
let g:openbrowser_search_engines = {
\   'rs': 'https://doc.rust-lang.org/std/index.html?search={query}',
\   'rsd': 'https://docs.rs/releases/search?query={query}',
\   'baidu': 'http://www.baidu.com/s?wd={query}&rsv_bp=0&rsv_spt=3&inputT=2478',
\   'cpan': 'http://search.cpan.org/search?query={query}',
\   'devdocs': 'http://devdocs.io/#q={query}',
\   'duckduckgo': 'http://duckduckgo.com/?q={query}',
\   'github': 'http://github.com/search?q={query}',
\   'google': 'http://google.com/search?q={query}',
\   'php': 'http://php.net/{query}',
\   'python': 'http://docs.python.org/dev/search.html?q={query}&check_keywords=yes&area=default',
\   'twitter-search': 'http://twitter.com/search/{query}',
\   'twitter-user': 'http://twitter.com/{query}',
\   'wiki': 'http://en.wikipedia.org/wiki/{query}',
\   'go': 'https://pkg.go.dev/search?q={query}',
\}
" let g:openbrowser_default_search = "duckduckgo"

Plug 'skywind3000/asyncrun.vim'
let g:asyncrun_open = 9
command! -bang -nargs=* -complete=file AsyncMake AsyncRun! -program=make @ <args>
command! -bang -nargs=* -complete=file Grep AsyncRun! -program=grep @ <args>

Plug 'dyng/ctrlsf.vim'
let g:ctrlsf_ackprg="rg"
let g:ctrlsf_context = '-C 2'
let g:ctrlsf_search_mode = 'sync'
" let g:ctrlsf_auto_focus = {
"     \ "at" : "done",
"     \ "duration_less_than": 1000
"     \ }
let g:ctrlsf_mapping = {
    \ "open": ["<CR>", "o", "<C-O>"],
    \ "next": "<C-N>",
    \ "prev": "<C-P>",
    \ }
let g:ctrlsf_populate_qflist = 1

vmap <leader>g <Plug>CtrlSFVwordPath<CR>
nmap <leader>gs <Plug>CtrlSFCwordPath<CR>
nmap <leader>gw :silent grep <c-r><c-w> %% <cr>:copen<cr>:wincmd p<cr>
nmap <leader>go :CtrlSFToggle<CR>

if executable("rg")
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Plug 'Yggdroot/LeaderF'
" let g:Lf_WindowHeight = 0.4
" let g:Lf_CacheDiretory = $VIMFILES
" let g:Lf_HideHelp = 1
" let g:Lf_DefaultMode = 'NameOnly'
" 
" if !exists('g:Lf_CommandMap')
"   let g:Lf_CommandMap = {
"       \ '<Tab>': ['<C-I>'],
"       \ '<C-C>': ['<Esc>', '<C-C>'],
"       \ '<C-]>': ['<C-V>'],
"       \ '<C-X>': ['<C-S>'],
"       \ '<C-V>': ['<C-Q>'],
"       \ '<CR>': ['<C-O>', '<CR>'],
"       \ '<C-J>': ['<C-N>'],
"       \ '<C-K>': ['<C-P>'],
"       \ '<C-U>': ['<C-W>'],
"       \}
"   let g:Lf_PreviewResult = {
"       \ 'BufTag': 0,
"       \ 'Function': 0,
"       \}
"   let g:Lf_StlSeparator = { 'left': '', 'right': '' }
"   let g:Lf_WildIgnore = {
"       \ 'dir': ['.svn','.git','.hg','bin'],
"       \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]','tags']
"       \}
"   let g:Lf_MruWildIgnore = {
"       \ 'dir': [],
"       \ 'file': ['*.fugitiveblame', '*.so'],
"       \}
"   let g:Lf_UseCache = 1
"   let g:Lf_NeedCacheTime = 0.3
"   let g:Lf_CursorBlink = 0
" endif
" 
" nnoremap <leader>h :LeaderfMruCwd<CR>
" nnoremap <leader>gh :LeaderfMru<CR>
" nnoremap <leader>gj :LeaderfBufTag<CR>
" nnoremap <leader>gt :LeaderfTag<CR>
" nnoremap <leader>tt :LeaderfFunction!<CR>
" nnoremap <leader>: :LeaderfHistoryCmd<CR>
" nnoremap <leader>/ :LeaderfHistorySearch<CR>

nnoremap <silent> <C-]> :tjump <C-r><C-w><CR>
nnoremap <space> za

" Plug 'xltan/LeaderF-tjump'
" aug vimrc_tjump
"   au!
"   au FileType c,cpp,objc,objcpp,actionscript,python nmap <silent><buffer> <C-]> :LeaderfTjump <C-r><C-w><CR>
" aug END

Plug 'editorconfig/editorconfig-vim'

" language related
Plug 'vim-python/python-syntax'
let g:python_version_3 = 1
let g:python_highlight_class_vars = 0
let g:python_highlight_indent_errors = 0
let g:python_highlight_space_errors = 0
let g:python_highlight_operators = 0
let g:python_highlight_all = 1
let g:python_slow_sync = 0
" a little bit slow
Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'xltan/pythonhelper.vim'
" Plug 'fisadev/vim-isort'
command! -nargs=0 -complete=command ImportRemove update | AsyncRun -post=e autoflake --in-place --remove-all-unused-imports %<CR>

Plug 'xltan/vim-cppman'

let c_no_curly_error = 1
let g:cpp_no_function_highlight = 1
let g:cpp_simple_highlight = 1
Plug 'bfrg/vim-cpp-modern'

Plug 'pboettch/vim-cmake-syntax'

Plug 'dart-lang/dart-vim-plugin'
let g:dart_style_guide = 1
Plug 'dag/vim-fish'
Plug 'rust-lang/rust.vim'

Plug 'fatih/vim-go'
let g:go_def_mapping_enabled = 0
let g:go_def_mode = 'gopls'
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_doc_url = 'https://pkg.go.dev'
map gb :GoDocBrowser<CR>

Plug 'leafgarland/typescript-vim'
" Plug 'Quramy/tsuquyomi'
"
Plug 'cespare/vim-toml'

Plug 'delphinus/vim-auto-cursorline'
let g:auto_cursorline_wait_ms = 1500

Plug 'xltan/vim-project'

call plug#end()

" call project#rc("~/work")
" Project  'seatalk-server'

if has("termguicolors")
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Eager-load these plugins so we can override their settings. {{{
runtime! plugin/unimpaired.vim
runtime! plugin/rsi.vim
" inoremap <expr> <C-E> col('.')>strlen(getline('.'))?"\<Lt>C-E>":"\<Lt>End>"
inoremap <C-E> <End>
inoremap <M-t> <esc>diwbPa <esc>ea
if !has("gui_running") " from tpope/vim-rsi
  silent! exe "set <F36>=\<esc>t"
  map! <F36> <M-t>
  map <F36> <M-t>

  set mouse=
endif

set mps+=<:>
if !has('nvim')
  packadd! matchit
endif

nnoremap cos :if exists("g:syntax_on") <Bar>
  \   syntax off <Bar>
  \ else <Bar>
  \   syntax on <Bar>
  \ endif <CR>
func! s:option_map(...)
  let [key, opt] = a:000[0:1]
  let op = get(a:, 3, 'set '.opt.'!')
  execute printf("nnoremap co%s :%s<bar>set %s?<CR>", key, op, opt)
endfunc
call s:option_map('w', 'wrap')
call s:option_map('p', 'paste')
call s:option_map('e', 'expandtab', 'setlocal expandtab!<bar>retab')
call s:option_map('t', 'ts',
    \ 'let &ts = input("tabstop (". &ts ."): ")<bar>let &sw=&ts<bar>redraw')

" http://www.shallowsky.com/linux/noaltscreen.html
" set t_ti= t_te=
" let &t_SI = "\e[6 q"
" let &t_EI = "\e[2 q"
"
function! s:reset_color() abort
  hi! link Folded GitGutterChange
  hi! link CocWarningSign Todo
  hi! link CocErrorSign GitGutterDelete
  hi! link MatchParen GitGutterDelete 
  hi! link QuickFixLine StatusLine

  hi! link fugitiveHunk Comment 
  hi! link gitDiff Comment 
  hi! link DiffNewFile Normal
  hi! link DiffFile Normal
  hi! link diffIndexLine Comment
  hi DiffAdded guibg=None
  hi DiffRemoved guibg=None
  hi ErrorMsg guibg=None
  hi Statement gui=None
  exe "hi DiffAdd gui=bold guibg=#" . g:base16_gui02
  exe "hi DiffDelete gui=None guibg=#" . g:base16_gui02
  exe "hi DiffText gui=bold guifg=#" .g:base16_gui0A . " guibg=#" . g:base16_gui02
  exe "hi DiffChange guibg=#" . g:base16_gui02
endfunction

set background=dark
aug color_tomorrow
  au!
  au ColorScheme * call <SID>reset_color()
aug END

color base16-tomorrow-night

call <SID>reset_color()

set guioptions=
set mouse=a
set diffopt+=vertical,algorithm:patience

" set statusline=%<%f\ %h%m%r\ %=\ %{'['.(&fenc!=''?&fenc:&enc).','.&ff.']'}\ %-14.(%l,%c%V%)\ %P

" set cursorline
" set nu
" set foldcolumn=1
set hlsearch
set nowrap
" set nofoldenable
set noshowmode

set listchars=tab:\|\ ,eol:¬

set autoindent
set smarttab
set sw=4 ts=4
set timeoutlen=500 ttimeoutlen=0

set laststatus=2
set scrolloff=4

set hidden
set autowrite
set autoread

set nobackup
set backupdir=$VIMFILES/.swap
set directory=$VIMFILES/.swap//
set undodir=$VIMFILES/.undo
set undofile

set winheight=2
set winminheight=2
set winwidth=100
set winminwidth=10
set completeopt=menuone

set ignorecase smartcase
set lazyredraw

set nofixeol
set formatoptions+=j " Delete comment character when joining commented lines
set cinoptions=:0,g0,(0,Ws,l1
set viminfo^=!
" set wildignore=*.pyc,*.pyo,*.exe,*.DS_Store,._*,*.svn,*.git,*.o,*.dSYM,*.ccls-cache,
"     \*.vscode,tags,*.vs,*.pyproj,*.idea,*.clangd,*__pycache__,
"     \*.bin,*.rlib,*.rmeta
set cpoptions+=>
set belloff=all
set history=1000
set updatetime=300

" for c-family files
func! s:a(cmd)
  let name = expand('%:r')
  let ext = expand('%:e')
  let sources = ['c', 'cc', 'cpp', 'm', 'mm']
  let headers = ['h', 'hh', 'hpp']
  for pair in [[sources, headers], [headers, sources]]
    let [set1, set2] = pair
    if index(set1, ext) >= 0
      for h in set2
        let a = name.'.'.h
        if filereadable(a)
          execute a:cmd a
          return
        end
      endfor
    endif
  endfor
endfunc

func! s:super()
  if &filetype == 'python'
    let pattern = '^class [^(]*(\zs[^)]*\ze):'
    let lineno = search(pattern, 'bn')
    let content = getline(lineno)
    let m = matchstr(content, pattern)
    let sm = split(m, '\.')
    exe 'tag '.sm[len(sm)-1]
    return
  endif
endfunc

aug vimrc_go
  au!
  au FileType go command! -bang GA call go#alternate#Switch(<bang>0, 'edit')
  au FileType go command! -bang GAV call go#alternate#Switch(<bang>0, 'vsplit')
  au FileType go command! -bang GAS call go#alternate#Switch(<bang>0, 'split')
aug END

aug vimrc_python
  au!
  " au FileType python let b:delimitMate_nesting_quotes = ['"']
  au FileType python nmap <silent> <buffer> ]s :call <SID>super()<CR>
  au FileType python nmap <silent> <buffer> [s <C-^>
  " au FileType python syn sync match pythonSync grouphere NONE '):$'
  " au FileType python setlocal equalprg=yapf
aug END

" aug vimrc_rust
"   au!
"   au FileType rust nmap <silent> <buffer> _= :RustFmt<CR>
"   au FileType rust nmap gd <Plug>(rust-def)
"   au FileType rust nmap gs <Plug>(rust-def-split)
"   au FileType rust nmap gv <Plug>(rust-def-vertical)
"   au FileType rust nmap <leader>gd <Plug>(rust-doc)
" aug END

aug vimrc_cpp
  au!
  " au CursorHold * silent call CocAction('doHover')
  " au CursorHold * silent call CocActionAsync('highlight')
  " au BufRead * if search('\M-*- C++ -*-', 'n', 1) | setlocal ft=cpp | endif
  au FileType c,cpp,objc,objcpp command! GA call s:a('e')
  au FileType c,cpp,objc,objcpp command! GAV call s:a('botright vertical split')
  " au FileType c,cpp,objc,objcpp setlocal equalprg=clang-format formatprg=clang-format
  " au FileType c,cpp,objc,objcpp nmap <buffer> <silent> [a :lprevious<CR>
  "       \ | nmap <buffer> <silent> ]a :lnext<CR>
  "       \ | nmap <buffer> <silent> [A :lfirst<CR>
  "       \ | nmap <buffer> <silent> ]A :llast<CR>
  au FileType c,cpp,objc,objcpp,go,python nmap <buffer> <silent> <leader>a :GA<CR>
  " au FileType c,cpp nmap <buffer> <silent> gd :YcmCompleter GoTo<CR>
  " au FileType c,cpp nmap <buffer> <silent> gz :YcmCompleter FixIt<CR>
  au FileType c,cpp,objc,objcpp,cs,json,java,actionscript,glsl,dot setlocal commentstring=//\ %s
  " au FileType c setlocal keywordprg=:Vman
  " au FileType cpp setlocal keywordprg=cppman
  au FileType cmake,tmux,cfg setlocal commentstring=#\ %s
aug END

aug vimrc_markdown
  au!
  " au FileType markdown let b:delimitMate_nesting_quotes = ['`']
  au filetype markdown setlocal conceallevel=2
  au filetype markdown nnoremap <silent><buffer> gN O<Esc>C- [ ] 
  au filetype markdown nnoremap <silent><buffer> gn o<Esc>C- [ ] 
  " au filetype markdown inoremap <silent><buffer> $ $<C-o>:set ft=tex<CR>
  au InsertLeave *.md if &filetype == 'tex' | set filetype=markdown | endif
  au filetype markdown noremap <silent><buffer> gd :<HOME>silent! <END>S/- [{ ,x}]/- [{x, }]/<CR>:nohl<CR>
aug END

aug vimrc_tab
  au!
  au FileType python,javascript setlocal expandtab ts=4 sw=4
  au FileType tex setlocal ts=2 sw=2
  au FileType vim,lua,c,cpp,yaml setlocal expandtab ts=2 sw=2
  au FileType make setlocal noexpandtab
aug END

func! s:goto_index(dir)
  let winnr = bufwinnr('^.git/index$')
  if winnr > 0
    exec winnr 'wincmd w'
  endif
  if a:dir == "n"
    exec "normal \<c-n>"
  else
    exec "normal \<c-p>"
  end
  " set ei+=WinEnter
  normal dv
  " set ei-=WinEnter
endfunc

func! s:stupid_diff()
  if winheight(0) < (&lines - 15)
    exe "resize " . (&lines - 15)
  endif
  nmap <buffer><silent> ]d :call <SID>goto_index("n")<CR>
  nmap <buffer><silent> [d :call <SID>goto_index("p")<CR>
endfunc

aug vimrc_misc
  au!
  au BufEnter,BufNew * if &buftype == 'terminal' | startinsert | endif
  au VimEnter * call s:init()
  au FileType json syntax match Comment +\/\/.\+$+
  au FileType help wincmd L | nnoremap <buffer><silent> q :bd<CR>
  au FileType man  wincmd L | nnoremap <buffer><silent> q :lclose<CR>:bd<CR>
  au FileType git setlocal foldmethod=syntax
  au FileType gitcommit setlocal foldmethod=syntax nofoldenable
  au WinEnter * if &diff | call<SID>stupid_diff() | endif
  au FileType leaderf setlocal nonumber | setlocal foldcolumn=1
  au BufRead *gl.vs,*gl.ps setlocal ft=glsl iskeyword=@,48-57,_,128-167,224-235
  au BufRead .clang-format setlocal ft=yaml
  au BufRead .localrc setlocal ft=vim
  au BufRead *.mangle setlocal equalprg=c++filt
  au BufWritePost *vimrc,*.vim so % | setlocal expandtab ts=2 sw=2
  au BufWritePost *.rs,*.cc,*.c call CocActionAsync("format")
  au FocusGained,CursorHold ?* if getcmdwintype() == '' | checktime | endif
  " au InsertLeave * set imi=0 | set cursorline
  " au InsertEnter * set nocursorline
  " au WinEnter * set cursorline
  " au BufEnter * set cursorline
  " au BufLeave * set nocursorline
  " au BufWinEnter * if &buftype == 'terminal' | nnoremap <buffer> <leader>q a<C-W><C-c> | endif
  " this is for scratch
  au filetype markdown nnoremap <buffer> <leader>q :q<CR>
  au DirChanged * call s:change_dir()
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

nnoremap <silent> L :nohl<CR>

func! s:get_buffer_list()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunc

if has('gui_running')
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

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-N><C-w>h
  tnoremap <C-j> <C-\><C-N><C-w>j
  tnoremap <C-k> <C-\><C-N><C-w>k
  tnoremap <C-l> <C-\><C-N><C-w>l
else
  tnoremap <Esc> <C-w>N
  tnoremap <C-^> <C-w>N<C-^>
  tnoremap <C-h> <C-w>h
  tnoremap <C-l> <C-w>l
  tnoremap <C-j> <C-w>j
  tnoremap <C-k> <C-w>k
endif

nnoremap Q @q
xnoremap Q :normal @q<CR>
xnoremap . :normal .<CR>

vnoremap < <gv
vnoremap > >gv
nnoremap gV `[v`]
nnoremap Y y$
vnoremap P yP`<O<Esc>j

nnoremap <silent> <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

if has("mac") && has("gui_running") && !has('nvim')
  set linespace=4
  set guifont=Fira\ Code:h12
  set macligatures
  set macmeta
  set macthinstrokes
elseif has("win32")
  set path=,,.
  set linespace=4
  set guifont=Monaco:h9
  set gfw=Microsoft\ Yahei\ Mono:h9

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
    let cmd = 'make CC="g++" CXXFLAGS="-std=c++17" '. bin . ' && ' . bin
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
nnoremap <silent> <leader>xx :AsyncStop!<CR>

command! -nargs=* -complete=command Run call s:run(<q-args>)

command! Only %bd|e#
command! JsonPrettier %!python -m json.tool
command! Todo exec "Grep 'XFIXME'"

nnoremap <M-p> "0p

cnoremap <C-p> <UP>
cnoremap <C-n> <DOWN>

nnoremap <leader>et :tabe ~/Documents/notes/todo.md<CR>
nnoremap <leader>en :tabe ~/Documents/notes<CR>:lcd %:h<CR>:pwd<CR>
nnoremap <leader>es :tabe $VIMFILES/bundle/vim-extra-snippets/UltiSnips<CR>:lcd %:h<CR>:pwd<CR>
nnoremap <leader>er :tabe $MYVIMRC<CR>

nnoremap <leader>cd :lcd %:h<CR>:pwd<CR>

func! s:preserve(command)
  let _s=@/
  let l:winview = winsaveview()
  execute 'silent '.a:command
  call winrestview(l:winview)
  let @/=_s
endfunc

nmap _$ :call <SID>preserve("%s/\\s\\+$//e")<CR>
" nmap _= :call <SID>preserve("normal! gg=G")<CR>

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

func! s:command_abbr(abbreviation, expansion)
  execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunc
command! -nargs=+ Cabbr call s:command_abbr(<f-args>)

Cabbr sf CtrlSF
Cabbr gr Grep
Cabbr cpp Cppman
Cabbr gdb GdbStartLLDB\ lldb
Cabbr ob OpenBrowserSearch
Cabbr rr RustRun

func! s:source_if_exists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunc

call s:source_if_exists($VIMFILES.'/.localrc')

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

func! s:init()
  " need overwrite ultisnips keymap
  inoremap <silent> <tab> <C-R>=pumvisible() ? coc#_select_confirm() : UltiSnips#ExpandSnippet()<CR>
  " inoremap <silent><expr> <TAB>
  "     \ pumvisible() ? coc#_select_confirm() :
  "     \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  "     \ <SID>check_back_space() ? "\<TAB>" :
  "     \ coc#refresh()
  " nmap [a <Plug>(ale_previous_wrap)
  " nmap ]a <Plug>(ale_next_wrap)
  nmap <silent> [a <Plug>(coc-diagnostic-prev)
  nmap <silent> ]a <Plug>(coc-diagnostic-next)

  nmap [x :cpf<CR>
  nmap ]x :cnf<CR>
  nmap [X :lpf<CR>
  nmap ]X :lnf<CR>
  nmap [w gT
  nmap ]w gt
  nmap [W :tabfirst<CR>
  nmap ]W :tablast<CR>
  " call vista#RunForNearestMethodOrFunction()
endfunc

func! s:change_dir()
  if getcwd() != $HOME
    call s:source_if_exists(getcwd() . '/.vimrc')
  endif
endfunc

let dllpath = $vimfiles . "/gvimfullscreen.dll"
nnoremap <M-f> <Esc>:call libcallnr(dllpath, "ToggleFullScreen", 0)<CR>

function! s:cppcheck()
  cclose
  update
  setlocal makeprg=cppcheck\ --enable=all\ %
  " setlocal errorformat=[%f:%l]:%m
  setlocal errorformat=[%f:%l]\ ->\ %m,[%f:%l]:%m
  let curr_dir = expand('%:h')
  if curr_dir == ''
    let curr_dir = '.'
  endif
  echo curr_dir
  execute 'lcd ' . curr_dir
  execute 'AsyncMake'
  execute 'lcd -'
  " exe    ":botright cwindow"
  " copen
endfunction

command! -bang -nargs=* -complete=command CppCheck AsyncRun! cppcheck % --enable=style,performance,portability,unusedFunction --std=c++14 --template-location=gcc --template=gcc

command! -bang -nargs=0 UE execute "normal o\<C-o>" . len(getline('.')). "i="
command! -bang -nargs=0 UM execute "normal o\<C-o>" . len(getline('.')). "i-"

if argc() == 0
  call s:source_if_exists('Session.vim')
endif

