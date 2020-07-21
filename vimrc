if !has('nvim')
  source $VIMRUNTIME/defaults.vim
else
  " let g:loaded_python_provider = 1
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
command! -nargs=? Co exec "Code -g " . expand('%:p').":". line('.')

let mapleader = ","
let maplocalleader = ","
let s:username = "Sinon"

set encoding=utf-8
set fileencoding=utf-8

let $VIMFILES=split(&rtp, ",")[0]
set rtp+=$HOME/.fzf
call plug#begin($VIMFILES . '/bundle')
Plug 'chriskempson/base16-vim'
Plug 'arzg/vim-colors-xcode'

Plug 'tpope/vim-characterize'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-dispatch'
Plug 'AdUki/vim-dispatch-neovim'
let g:dispatch_no_neovim_start = 1
Plug 'tpope/vim-commentary'
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

function! s:directory_history()
  return s:_uniq(map(
    \ filter([expand('%')], 'len(v:val)')
    \   + filter(map(s:buflisted_sorted(), 'bufname(v:val)'), 'len(v:val)')
    \   + filter(copy(v:oldfiles), "s:file_is_in_cwd(fnamemodify(v:val, ':p'))"),
    \ 'fnamemodify(v:val, ":~:.")'))
endfunction

function! s:file_is_in_cwd(file)
  return filereadable(a:file) && match(a:file, getcwd() . '/') == 0
endfunction

function! s:_uniq(list)
  let visited = {}
  let ret = []
  for l in a:list
    if !empty(l) && !has_key(visited, l)
      call add(ret, l)
      let visited[l] = 1
    endif
  endfor
  return ret
endfunction

function! s:buflisted_sorted()
  return sort(s:buflisted(), 's:sort_buffers')
endfunction

function! s:sort_buffers(...)
  let [b1, b2] = map(copy(a:000), 'get(g:fzf#vim#buffers, v:val, v:val)')
  return b1 < b2 ? 1 : -1
endfunction

function! s:buflisted()
  return filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") != "qf"')
endfunction

Plug 'junegunn/fzf.vim'
let $FZF_DEFAULT_OPTS='--inline-info --layout=reverse'
let $FZF_DEFAULT_COMMAND="fd --type f --color never --no-ignore-vcs --exclude /vendor --exclude /target/debug"
" let g:fzf_preview_window = 'right:60%'
nnoremap <leader>f :Files<CR>
nnoremap <leader>r :Files %:h<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>gh :History<CR>
nnoremap <leader>h :CwdHistory<CR>
nnoremap <leader>v :Lines<CR>

nnoremap <leader>j :BTags<CR>
nnoremap <leader>gt :Tags<CR>
nnoremap <leader>: :History:<CR>
nnoremap <leader>/ :History/<CR>

nnoremap <leader>a :CocFzfList actions<CR>

let g:fzf_preview_window = ''

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

let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
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

command! -bang CwdHistory call fzf#run(fzf#wrap({
  \ 'source': s:directory_history(),
  \ 'options': [
  \   '--prompt', 'CwdHistory> ',
  \   '--multi',
  \ ]}, <bang>0))

if has('nvim')
  let s:fzf_floating_window_height = min([20, &lines])
  function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)

    let height = s:fzf_floating_window_height
    let width = min([110, float2nr(&columns - (&columns * 2 / 12))])
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
  let g:fzf_layout = { 'window': 'call FloatingFZF()' }
else
  let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.4, 'highlight': 'Comment' }}
endif

Plug 'antoinemadec/coc-fzf'

" Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
" let g:clap_layout = { 'relative': 'editor' }
" let g:clap#provider#cwd# = {
"   \ 'syntax': 'clap_files',
"   \ 'source': function("s:directory_history"),
"   \ 'sink': 'e',
"   \ }
" let g:clap_insert_mode_only = v:true

" aug clap_input
"   au!
"   au FileType clap_input inoremap <silent> <buffer> <C-n> <C-R>=clap#handler#navigate_result('down')<CR>
"   au FileType clap_input inoremap <silent> <buffer> <C-p> <C-R>=clap#handler#navigate_result('up')<CR>
" aug END

" nnoremap <leader>f :Clap files<CR>
" nnoremap <leader>r :Clap git_diff_files<CR>
" nnoremap <leader>b :Clap buffers<CR>
" nnoremap <leader>gh :Clap history<CR>
" nnoremap <leader>h :Clap cwd<CR>
" nnoremap <leader>v :Clap lines<CR>

" nnoremap <leader>j :Clap tags<CR>
" nnoremap <leader>gt :Clap proj_tags<CR>
" nnoremap <leader>: :Clap hist:<CR>
" nnoremap <leader>/ :Clap hist/<CR>
"
" Plug 'vn-ki/coc-clap'

Plug 'junegunn/vim-easy-align'
vmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)

" Plug 'ryanoasis/vim-devicons'
" Plug 'hardcoreplayers/spaceline.vim'
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
      \ 'component': {
      \   'custom_relativepath': "%{expand('%:~:.')!=#''?expand('%:~:.'):'[No\ Name]'}",
		  \   'lineinfo': '%3l,%-2v',
      \ },
      \ 'active': {
		  \   'left': [ [ 'paste' ],
		  \           [ 'readonly', 'custom_relativepath', 'modified', 'cocstatus', 'method', 'gitbranch' ] ],
      \  'right': [ [ 'percentwin' ],
      \            [ 'lineinfo' ],
      \            [ 'mode' ]]
      \ },
      \ 'inactive': {
		  \   'left': [ [ 'custom_relativepath' ] ],
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
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ }
      

" Plug 'christoomey/vim-tmux-navigator'
Plug 'voldikss/vim-floaterm'
let g:floaterm_position='right'
let g:floaterm_gitcommit = 'tabe'
let g:floaterm_keymap_new    = '<leader>gv'
let g:floaterm_keymap_prev   = '<leader>gp'
let g:floaterm_keymap_next   = '<leader>gn'
" let g:floaterm_keymap_toggle = '<c-z>'
let g:floaterm_winblend = 10
let g:floaterm_width = 110
let g:floaterm_height = 0.9
vmap <leader>gv :<c-u>'<,'>FloatermSend<CR>
nnoremap <silent> <C-z> :update<CR>:FloatermToggle<CR>

Plug 'skywind3000/asyncrun.vim'
let g:asyncrun_open = 6
command! -bang -nargs=* -complete=file AsyncMake AsyncRun! -program=make @ <args>
command! -bang -nargs=* -complete=file Grep silent grep <args>

Plug 'skywind3000/asynctasks.vim'
function! s:runner_proc(opts)
  let curr_bufnr = floaterm#curr()
  if has_key(a:opts, 'silent') && a:opts.silent == 1
    FloatermHide!
  endif
  let cmd = 'pushd ' . shellescape(getcwd()) . ' && '. a:opts.cmd . ' && popd'
  echom curr_bufnr
  call floaterm#terminal#send(curr_bufnr, [cmd])
  stopinsert
  if &filetype == 'floaterm' && g:floaterm_autoinsert
    call floaterm#util#startinsert()
  endif
endfunction

let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
let g:asyncrun_runner.floaterm = function('s:runner_proc')

Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_math = 1
let g:tex_conceal = 0

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
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

function! s:get_args(args)
  if len(a:args) > 0
    let word = a:args
  else
    let word = s:get_current_word(':')
  endif
  return word
endf

function! s:std_get_commands(args)
  let word = s:get_args(a:args)
  if word =~ "^std"
    return 'silent !rustup doc '. word
  endif

  return 'OpenBrowserSearch -rs '. word
endfunction

command! -bang -nargs=* -complete=command Doc execute <SID>std_get_commands(<q-args>)
command! -bang -nargs=* -complete=command Rs execute 'OpenBrowserSearch -rsd ' . <SID>get_args(<q-args>)

let g:targets_aiAI = 'ai  '
let g:targets_quotes = '"d '' `'
Plug 'wellle/targets.vim'

Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_fold_enabled = 0
let g:vimtex_view_general_callback = 'ViewerCallback'

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
let g:signify_vcs_list = ['git']

omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-inner-pending)
xmap ac <plug>(signify-motion-inner-visual)

nnoremap [r :SignifyHunkUndo<CR>
nnoremap ]r :SignifyHunkDiff<CR>

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
  if has('nvim')
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
    Plug 'vim-utils/vim-man'
  endif
endif

Plug 'justinmk/vim-dirvish'
nnoremap <silent><C-e> :<C-U>exe 'vsplit +Dirvish\ %:p'.repeat(':h',v:count1)<CR>

func! s:setup_dirvish()
  " silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d
  " silent! unmap <silent><buffer> <C-p>
  nnoremap <silent><buffer> q :bd<CR>
  nnoremap <silent><buffer> o :call dirvish#open("p", 1)<CR><C-w>p
  nnoremap <silent><buffer> gs :sort ,^.*[\/],<CR>:set conceallevel=3<CR>
  nnoremap <silent><buffer> gr :noau Dirvish %<CR>
  nnoremap <silent><buffer> gh :Silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d<CR>:set conceallevel=3<CR>
  if has('win32')
    nnoremap <silent><buffer> gx :SilentExt start <C-R><C-L><CR>
  else
    nnoremap <silent><buffer> gx :SilentExt open <C-R><C-L><CR>
  endif
  execute 'nnoremap <expr>'.'<buffer> <leader>xm ":<C-u>"."AsyncRun -mode=term -pos=flaoterm sh ".shellescape(fnamemodify(getline("."),":."))."<CR>"'
  nnoremap <buffer> t :call dirvish#open('tabedit', 0)<CR>
  xnoremap <buffer> t :call dirvish#open('tabedit', 0)<CR>
endfun

aug dirvish_custom
  au!
  au FileType dirvish call <SID>setup_dirvish()
aug END

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

Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
map <M-;> <Plug>Sneak_,

Plug 'justinmk/vim-gtfo'
let g:gtfo#terminals = { 'win': 'cmd.exe /k' }
if has('win32')
  nmap gox :SilentExt start %<CR>
else
  nmap gox :SilentExt open %<CR>
endif
cnoremap %% <C-R>=fnameescape(expand('%:h'))<CR>/
nmap gon :sav %%

" Plug 'mattboehm/vim-unstack'
" let g:unstack_mapkey=''
" let g:unstack_populate_quickfix=1
" let g:unstack_open_tab=0

Plug 'Valloric/ListToggle'
let g:lt_quickfix_list_toggle_map = '<leader>z'
let g:lt_height = 7

let s:error_symbol = '>'
let s:warning_symbol = '-'

let g:coc_global_extensions = [
\ 'coc-ultisnips',
\ 'coc-go',
\ 'coc-json',
\ 'coc-clangd',
\ 'coc-rust-analyzer',
\ 'coc-cmake',
\ 'coc-yaml',
\ 'coc-git',
\ ]
Plug 'neoclide/coc.nvim', {'tag': '*'}
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

nmap <silent> gd :call <SID>goto_tag("Definition")<CR>
nmap <silent> gi :call <SID>goto_tag("Implementation")<CR>
nmap <silent> gr :call <SID>goto_tag("References")<CR>
nmap <silent> gy :call <SID>goto_tag("TypeDefinition")<CR>
nmap <silent> gn <Plug>(coc-rename)
nmap <silent> gz <Plug>(coc-fix-current)
nmap <silent> gh :call <SID>show_documentation()<CR>
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
nmap <silent> ]v :CocNext<CR>
nmap <silent> [v :CocPrev<CR>

function! s:goto_tag(tagkind) abort
  let tagname = expand('<cWORD>')
  let winnr = winnr()
  let pos = getcurpos()
  let pos[0] = bufnr()

  if CocAction('jump' . a:tagkind)
    call settagstack(winnr, { 
      \ 'curidx': gettagstack()['curidx'], 
      \ 'items': [{'tagname': tagname, 'from': pos}] 
      \ }, 't')
  endif
endfunction

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

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
\   'cpp': 'https://en.cppreference.com/mwiki/index.php?search={query}',
\}
" let g:openbrowser_default_search = "duckduckgo"
"
" Plug 'tyru/caw.vim'
" vmap gc	<Plug>(caw:hatpos:toggle)

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

" Plug 'xltan/LeaderF-tjump'
" aug vimrc_tjump
"   au!
"   au FileType c,cpp,objc,objcpp,actionscript,python nmap <silent><buffer> <C-]> :LeaderfTjump <C-r><C-w><CR>
" aug END

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
command! -nargs=0 -complete=command ImportRemove update | SilentExt autoflake --in-place --remove-all-unused-imports %<CR>
command! -range=% Isort :<line1>,<line2>! isort

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
let g:rustfmt_autosave = 1
Plug 'mhinz/vim-crates'

Plug 'fatih/vim-go'
let g:go_def_mapping_enabled = 0
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1
let g:go_list_type = "quickfix"
let g:go_doc_url = 'https://pkg.go.dev'
let g:go_echo_go_info = 0
let g:go_gopls_enabled = 0
let g:go_def_mode = 'gopls'
" let g:go_gopls_options = ["-remote", "auto"]
" let g:go_metalinter_autosave = 1
" let g:go_metalinter_autosave_enabled = ['vet', 'golint']
map gb :GoDocBrowser<CR>

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
" Plug 'Quramy/tsuquyomi'
"
Plug 'cespare/vim-toml'

Plug 'delphinus/vim-auto-cursorline'
let g:auto_cursorline_wait_ms = 5000

Plug 'mhinz/vim-startify'
let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]

Plug 'airblade/vim-rooter'
let g:rooter_manual_only = 1
let g:rooter_cd_cmd = "lcd"
let g:rooter_patterns = ['.git/', 'cargo.toml', 'go.mod']

call plug#end()

if has("termguicolors")
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Eager-load these plugins so we can override their settings.
runtime! plugin/unimpaired.vim
runtime! plugin/rsi.vim
inoremap <C-E> <End>
inoremap <M-t> <esc>diwbPa <esc>ea
if !has("gui_running") " from tpope/vim-rsi
  silent! exe "set <F36>=\<esc>t"
  map! <F36> <M-t>
  map <F36> <M-t>
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

  hi! link fugitiveHunk Comment 
  hi! link gitDiff Comment 
  hi! link DiffNewFile Normal
  hi! link DiffFile Normal
  hi! link diffIndexLine Comment
  hi DiffAdded guibg=NONE
  hi DiffRemoved guibg=NONE
  hi ErrorMsg guibg=NONE
  hi Statement gui=NONE
  hi ModeMsg gui=NONE
  exe "hi DiffAdd gui=bold guibg=#" . g:base16_gui02
  exe "hi DiffDelete gui=NONE guibg=#" . g:base16_gui02
  exe "hi DiffText gui=bold guifg=#" .g:base16_gui0A . " guibg=#" . g:base16_gui02
  exe "hi DiffChange guibg=#" . g:base16_gui02
  exe "hi VertSplit guifg=#". g:base16_gui01 . " guibg=#" . g:base16_gui01
  exe "hi StatusLine guifg=#". g:base16_gui05 . " guibg=#" . g:base16_gui01
  exe "hi QuickfixLine guifg=#". g:base16_gui0A . " guibg=#" . g:base16_gui02
  " hi link CocListsLine QuickfixLine
	hi! link FloatermBorder Comment
  hi! link jsonCommentError Comment
endfunction

set background=dark
aug color_tomorrow
  au!
  au ColorScheme * call <SID>reset_color()
aug END

color base16-tomorrow-night

call s:reset_color()

set guioptions=
set mouse=a
set diffopt+=vertical,algorithm:patience

set hlsearch
set nowrap
set noshowmode

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

set ignorecase smartcase
set lazyredraw
" set textwidth=120

set nofixeol
set formatoptions+=j " Delete comment character when joining commented lines
set viminfo^=!
set cpoptions+=>
set belloff=all
set history=1000
set updatetime=300
set gdefault
set number
set relativenumber
syntax sync minlines=500

if has('nvim')
  aug Term
    au!
    au TermOpen * nnoremap <buffer> q a
    au TermEnter * setlocal scrolloff=0
    au TermLeave * setlocal scrolloff=3
  aug END
else
  set scrolloff=3
end

" set cinoptions=:0,g0,(0,Ws,l1
" set completeopt=menuone
" set statusline=%<%f\ %h%m%r\ %=\ %{'['.(&fenc!=''?&fenc:&enc).','.&ff.']'}\ %-14.(%l,%c%V%)\ %P
" set cursorline
" set nu
" set foldcolumn=1
" set nofoldenable
" set wildignore=*.pyc,*.pyo,*.exe,*.DS_Store,._*,*.svn,*.git,*.o,*.dSYM,*.ccls-cache,
"     \*.vscode,tags,*.vs,*.pyproj,*.idea,*.clangd,*__pycache__,
"     \*.bin,*.rlib,*.rmeta

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

aug vimrc_filetype
  au FileType go command! -bang GA call go#alternate#Switch(<bang>0, 'edit')
        \| command! -bang GAV call go#alternate#Switch(<bang>0, 'vsplit')
        \| command! -bang GAS call go#alternate#Switch(<bang>0, 'split')
        \| nnoremap s= :s/ =/ :=<cr>:nohl<cr>
        \| nmap <buffer> <C-]> <Plug>(go-def)
        \| nmap <buffer> <C-t> <Plug>(go-def-pop)

  au FileType git setlocal foldmethod=syntax
        \| nnoremap <buffer> coc :exec "G checkout ".expand("<cWORD>")<CR>
        \| nnoremap <buffer> cdd :exec "G branch -d ".expand("<cWORD>")<CR>
        \| nnoremap <buffer> q <c-w>q

  au FileType gitcommit setlocal foldmethod=syntax nofoldenable

  au FileType python nmap <silent> <buffer> ]s :call <SID>super()<CR>
        \| nmap <silent> <buffer> [s <C-^>
  au FileType c,cpp,objc,objcpp command! GA call s:a('e')
        \| command! GAV call s:a('botright vertical split')
  au FileType c,cpp,objc,objcpp,go,python nmap <buffer> <silent> <leader>ca :GA<CR>
  au filetype markdown setlocal conceallevel=2
      \| nnoremap <silent><buffer> gN O<Esc>C- [ ] 
      \| nnoremap <silent><buffer> gn o<Esc>C- [ ] 
      \| nnoremap <silent><buffer> gd :<HOME>silent! <END>S/- [{ ,x}]/- [{x, }]/<CR>:nohl<CR>
      \| nnoremap <buffer> <leader>q :q<CR>
  au FileType help wincmd L | nnoremap <buffer><silent> q :bd<CR>
  au FileType man  wincmd L | nnoremap <buffer><silent> q :lclose<CR>:bd<CR>
  au FileType leaderf setlocal nonumber | setlocal foldcolumn=1
  au FileType python,javascript setlocal expandtab ts=4 sw=4
  au FileType tex setlocal ts=2 sw=2
  au FileType vim,lua,c,cpp,yaml,fish setlocal expandtab ts=2 sw=2
  au FileType make setlocal noexpandtab
  au FileType fzf tnoremap <silent><buffer> <Esc> <C-c>
        \| tnoremap <silent><buffer> <C-j> <C-n>
        \| tnoremap <silent><buffer> <C-k> <C-p>
        \| tnoremap <silent><buffer> <C-h> <BS>
        \| tnoremap <silent><buffer> <C-l> <C-c>
  au FileType c,cpp,objc,objcpp,cs,json,java,actionscript,glsl,dot setlocal commentstring=//\ %s
  au FileType cmake,tmux,cfg setlocal commentstring=#\ %s
aug END

aug vimrc_misc
  au!
  au VimEnter * call s:init()
  au WinEnter * if &diff | call<SID>stupid_diff() | endif
  au BufRead *gl.vs,*gl.ps setlocal ft=glsl iskeyword=@,48-57,_,128-167,224-235
  au BufRead .clang-format setlocal ft=yaml
  au BufRead .localrc setlocal ft=vim
  au BufRead *.mangle setlocal equalprg=c++filt
  au BufWritePost *vimrc,*.vim so % | setlocal expandtab ts=2 sw=2
  au BufWritePost *.cc,*.c call CocActionAsync("format")
  au FocusGained,CursorHold ?* if getcmdwintype() == '' | checktime | endif
  au QuickFixCmdPost * botright copen 7
aug END

" aug vimrc_old
"   au!
"   au TermOpen * startinsert
"   au WinEnter * if &buftype == 'terminal' | startinsert | endif
"   au BufEnter,BufNew * if &buftype == 'terminal' | startinsert | endif
"   au FileType rust nmap gd <Plug>(rust-def)
"   au FileType rust nmap gs <Plug>(rust-def-split)
"   au FileType rust nmap gv <Plug>(rust-def-vertical)
"   au FileType rust nmap <leader>gd <Plug>(rust-doc)
"   au FileType python let b:delimitMate_nesting_quotes = ['"']
"   au FileType python syn sync match pythonSync grouphere NONE '):$'
"   au FileType python setlocal equalprg=yapf
"   au CursorHold * silent call CocAction('doHover')
"   au CursorHold * silent call CocActionAsync('highlight')
"   au BufRead * if search('\M-*- C++ -*-', 'n', 1) | setlocal ft=cpp | endif
"   au FileType c,cpp,objc,objcpp setlocal equalprg=clang-format formatprg=clang-format
"   au FileType c,cpp,objc,objcpp nmap <buffer> <silent> [a :lprevious<CR>
"         \ | nmap <buffer> <silent> ]a :lnext<CR>
"         \ | nmap <buffer> <silent> [A :lfirst<CR>
"         \ | nmap <buffer> <silent> ]A :llast<CR>
"   au FileType c,cpp nmap <buffer> <silent> gd :YcmCompleter GoTo<CR>
"   au FileType c,cpp nmap <buffer> <silent> gz :YcmCompleter FixIt<CR>
"   au FileType c setlocal keywordprg=:Vman
"   au FileType cpp setlocal keywordprg=cppman
"   au FileType markdown let b:delimitMate_nesting_quotes = ['`']
"   au filetype markdown inoremap <silent><buffer> $ $<C-o>:set ft=tex<CR>
"   au InsertLeave *.md if &filetype == 'tex' | set filetype=markdown | endif
"   au InsertLeave * set imi=0 | set cursorline
"   au InsertEnter * set nocursorline
"   au WinEnter * set cursorline
"   au BufEnter * set cursorline
"   au BufLeave * set nocursorline
"   au BufWinEnter * if &buftype == 'terminal' | nnoremap <buffer> <leader>q a<C-W><C-c> | endif
"   au DirChanged * call s:change_dir()
" aug END

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
  normal dv
endfunc

func! s:stupid_diff()
  if winheight(0) < (&lines - 13)
    exe "resize " . (&lines - 13)
  endif
  nmap <buffer><silent> ]d :call <SID>goto_index("n")<CR>
  nmap <buffer><silent> [d :call <SID>goto_index("p")<CR>
endfunc

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

  " nnoremap <silent> <C-z> :call <SID>toggle_term()<CR>
  " tnoremap <buffer> <C-z> <C-w>N<C-^>

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

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-^> <C-\><C-n>:FloatermToggle<CR>:
  tnoremap <silent><C-z> <C-\><C-N>:FloatermToggle<CR>
  tnoremap <expr> <M-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  " tnoremap <C-h> <C-\><C-N><C-w>h
  " tnoremap <C-j> <C-\><C-N><C-w>j
  " tnoremap <C-k> <C-\><C-N><C-w>k
  " tnoremap <C-l> <C-\><C-N><C-w>l
else
  tnoremap <Esc> <C-w>N
  tnoremap <C-^> <C-w>N<C-^>
  " tnoremap <C-h> <C-w>h
  " tnoremap <C-l> <C-w>l
  " tnoremap <C-j> <C-w>j
  " tnoremap <C-k> <C-w>k
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
  set guifont=SF\ Mono:h12
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
  elseif &filetype == 'sh'
    let cmd = 'sh '. expand('%:p')
  elseif &filetype == 'go'
    if bin =~ "_test$"
      let cmd = 'go test -v -count=1 ' . expand('%:p:h')
    else
      let cmd = 'go run ' . expand('%:p:h')
    end
  elseif &filetype == 'rust'
    let cmd = 'cargo run'
  else
    let cmd = &makeprg." %<"
  endif
  return cmd.' '.a:args
endfunc

func! s:run(args)
  exe '!'.<SID>make_args(a:args)
endfunc

func! s:async_run(args)
  silent update
  exe 'AsyncRun -mode=term -pos=floaterm '.<SID>make_args(a:args)
endfunc

nnoremap <silent> <leader>xm :call <SID>async_run('')<CR>
nnoremap <silent> <leader>xx :AsyncStop!<CR>

command! -nargs=* -complete=command Run call s:run(<q-args>)

command! Only %bd|e#
command! Todo exec "Grep 'XFIXME'"

nnoremap <M-p> "0p

cnoremap <C-p> <UP>
cnoremap <C-n> <DOWN>

nnoremap <leader>et :tabe ~/Documents/notes/todo.md<CR>
nnoremap <leader>en :tabe ~/Documents/notes<CR>:lcd %:h<CR>:pwd<CR>
nnoremap <leader>es :tabe $VIMFILES/bundle/vim-extra-snippets/UltiSnips<CR>:lcd %:h<CR>:pwd<CR>
nnoremap <leader>er :tabe $MYVIMRC<CR>

nnoremap <leader>cd :lcd %:h<CR>:pwd<CR>
nnoremap <silent> <C-]> :tjump <C-r><C-w><CR>
nnoremap <space> za

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
Cabbr gp Grep
Cabbr Gp Grep
Cabbr Gpi Grep\ -i
Cabbr gpi Grep\ -i
Cabbr fs FloatermSend
Cabbr cpp Cppman
Cabbr gdb GdbStartLLDB\ lldb
Cabbr ob OpenBrowserSearch
Cabbr go OpenBrowserSearch\ -go
Cabbr t AsyncTask
Cabbr cl CocFzfList
Cabbr clc CocFzfList\ commands
Cabbr cr CocRestart
Cabbr ife GoIfErr

Cabbr gat GoAddTags
Cabbr grt GoRemoveTags
Cabbr gtf GoTestFunc
Cabbr gi GoImpl
" Cabbr ufc UnstackFromClipboard
" Cabbr ufs UnstackFromSelection
" Cabbr uft UnstackFromTmux

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
  " inoremap <silent> <tab> <C-R>=UltiSnips#ExpandSnippet()<CR>
  " inoremap <silent><expr> <TAB>
  "     \ pumvisible() ? coc#_select_confirm() :
  "     \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  "     \ <SID>check_back_space() ? "\<TAB>" :
  "     \ coc#refresh()
  " nmap [a <Plug>(ale_previous_wrap)
  " nmap ]a <Plug>(ale_next_wrap)
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)

  nmap [x :cpf<CR>
  nmap ]x :cnf<CR>
  nmap [X :lpf<CR>
  nmap ]X :lnf<CR>
  nmap [w gT
  nmap ]w gt
  nmap [W :tabfirst<CR>
  nmap ]W :tablast<CR>
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

call s:change_dir()
