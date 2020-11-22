if !has('nvim')
  source $VIMRUNTIME/defaults.vim
endif

let mapleader = " "
let maplocalleader = " "
let s:username = "Sinon"

set encoding=utf-8 fileencoding=utf-8

let $VIMFILES=split(&rtp, ",")[0]
call plug#begin($VIMFILES . '/bundle')
Plug 'chriskempson/base16-vim'

Plug 'tpope/vim-characterize'
nmap <leader>ga <Plug>(characterize)
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rhubarb'

Plug 'tpope/vim-dispatch'
Plug 'AdUki/vim-dispatch-neovim'
let g:dispatch_quickfix_height = 0
nmap S<CR> :exec "Start -dir=" . expand("%:h")<CR>
aug vimrc_dispatch
  au!
  au FileType,BufWrite * call s:setup_makeprg()
  au ShellCmdPost * call s:shell_cmd_post()
aug END

func! s:shell_cmd_post()
  if get(g:, "dispatch_flag", 0)
    call s:copen_hack("\|wincmd p")
    let g:dispatch_flag = 0
  end
endf

let s:mtype = {
  \ 'dirvish': 'sh <sfile>',
  \ 'python': 'python %',
  \ 'cpp': "make CC='g++' CXXFLAGS='-std=c++17' %:p:r && %:p:r",
  \ 'c': 'make %:p:r && %:p:r',
  \ 'sh': 'sh %',
  \ 'go': 'go run %',
  \ 'rust': 'cargo run -q',
  \ }
let s:stype = {
  \ 'go': 'go',
  \ 'rust': 'cargo -q',
  \ }
func! s:setup_makeprg()
  let f = &filetype
  let prg = get(s:mtype, f, '')
  let oprg = get(s:stype, f, prg)
  if prg != ''
    if f == 'go'
      if expand("%") =~ '_test.go'
        let name = s:get_go_func()
        if name == ""
          let prg = 'go test '. expand('%:p:h') . ' -count=1 -v'
        else
          let prg = 'go test '. expand('%:p:h').' -run=' . name . ' -count=1 -v'
        endif
      endif
    endif
    exec "nmap <buffer> g<cr> :Dispatch ". prg. '<cr>'
    exec "nmap <buffer> g<space> :Dispatch ". oprg. '<space>'
    exec "nmap <buffer> g! :Dispatch! ". oprg. '<space>'
    exec "nmap <buffer> s<cr> :Start ". prg. '<cr>'
    exec "nmap <buffer> s<space> :Start ". oprg. '<space>'
    exec "nmap <buffer> s! :Start! ". prg. '<cr>'
  end
endf

func! s:get_go_func()
  let test = search('func \(Test\|Example\)', "bcnW")
  if test == 0
    return ""
  end
  let line = getline(test)
  let name = split(split(line, " ")[1], "(")[0]
  return name
endf

Plug 'machakann/vim-sandwich'

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

Plug 'junegunn/vim-easy-align'
vmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:easy_align_delimiters = {
  \ '#': { 'pattern': '#\+', 'delimiter_align': 'l', 'ignore_groups': [] },
  \ }

Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-/']
let g:fzf_buffers_jump = 1

let $FZF_DEFAULT_OPTS='--inline-info --layout=reverse'
let $FZF_DEFAULT_COMMAND="fd --type f --color never --no-ignore-vcs"
nnoremap <silent><leader>f :Files<CR>
nnoremap <silent><leader>r :Files %:h<CR>
nnoremap <silent><leader>b :Buffers<CR>
nnoremap <silent><leader>gh :History<CR>
nnoremap <silent><leader>h :CHistory<CR>
nnoremap <silent><leader>v :Lines<CR>
nnoremap <silent><leader>j :BTags<CR>
nnoremap <silent><leader>t :Tags<CR>
nnoremap <silent><leader>; :History:<CR>
nnoremap <silent><leader>/ :History/<CR>

func! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  cwindow
  cc
endf

func! s:open_file(lines)
  exec 'silent !open ' . a:lines[0]
endf

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

command! -bang PHistory call fzf#run(fzf#wrap({
  \ 'source': s:file_history_from_directory(s:get_git_root()),
  \ 'options': ['-m', '--header-lines', !empty(expand('%')), '--prompt', 'PHist> '],
  \ }))

command! CHistory call fzf#run(fzf#wrap({
  \ 'source': s:file_history_from_directory(getcwd()),
  \ 'options': ['-m', '--header-lines', !empty(expand('%')), '--prompt', 'CHist> '],
  \ }))

func! s:file_history_from_directory(directory)
  return fzf#vim#_uniq(filter(fzf#vim#_recent_files(), "s:file_is_in_directory(fnamemodify(v:val, ':p'), a:directory)"))
endf

func! s:file_is_in_directory(file, directory)
  return filereadable(a:file) && match(a:file, a:directory . '/') == 0
endf

func! s:get_git_root()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endf

let g:fzf_layout = { 'window': { 'width': 120, 'height': 20, 'highlight': 'FzfWindow' }}
let g:fzf_colors = { 'fg': ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'Comment'],
  \ 'gutter':  ['bg', 'Normal'],
  \ 'border':  ['bg', 'Ignore'],
  \ 'prompt':  ['fg', 'Comment'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Comment'],
  \ }

Plug 'tittanlee/fzf-tags'
nmap <C-]> <Plug>(fzf_tags)
" nnoremap <silent> <C-]> :tjump <C-r><C-w><CR>

Plug 'xltan/lightline-colors.vim'
Plug 'itchyny/lightline.vim'
func! StatusDiagnostic() abort
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
endf
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

Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
" disable math tex conceal feature
let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:vim_markdown_new_list_item_indent = 2

" Plug 'tpope/vim-markdown'
" let g:markdown_fenced_languages = [
"   \ 'go', 'c', 'cpp', 'python', 'sh=sh', 
"   \ 'bash=sh', 'rust', 'javascript', 
"   \ 'js=javascript', 'json', 'yaml', 
"   \ 'css', 'xml', 'html', 'make',
"   \ ]
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
let g:mkdp_markdown_css = expand('~/.markdown.css')
let g:mkdp_highlight_css = expand('~/.highlight.css')

Plug 'dhruvasagar/vim-table-mode'
let g:table_mode_map_prefix = '<Leader>y'
let g:table_mode_corner='|'
" func! s:is_start_of_line(mapping)
"   let text_before_cursor = getline('.')[0 : col('.')-1]
"   let mapping_pattern = '\V' . escape(a:mapping, '\')
"   let comment_pattern = '\V' . escape(substitute(&commentstring, '%s.*$', '', ''), '\')
"   return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
" endf

" inoreabbrev <expr> <bar><bar>
"   \ <SID>is_start_of_line('\|\|') ?
"   \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'

func! s:get_current_word(pattern)
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
endf

func! s:get_args(args)
  if len(a:args) > 0
    let word = a:args
  else
    let word = s:get_current_word(':')
  endif
  return word
endf

func! s:std_get_commands(args)
  let word = s:get_args(a:args)
  " if word =~ "^std"
  "   return 'silent !rustup doc '. word
  " endif
  return 'OpenBrowserSearch -' . &filetype . ' ' . word
endf

Plug 'wellle/targets.vim'
let g:targets_aiAI = 'ai  '
Plug 'wellle/tmux-complete.vim'
" Plug 'wellle/context.vim'
" let g:context_nvim_no_redraw = 1
Plug 'machakann/vim-swap'
let g:swap_no_default_key_mappings = 1
map z[ <Plug>(swap-prev)
map z] <Plug>(swap-next)

Plug 'mbbill/undotree'
nnoremap <silent> <leader>u :UndotreeToggle<CR>

Plug 'kana/vim-niceblock'

Plug 'haya14busa/vim-asterisk'
" noremap *   <Plug>(asterisk-*)
" noremap #   <Plug>(asterisk-#)
" noremap g*  <Plug>(asterisk-g*)
" noremap g#  <Plug>(asterisk-g#)
" noremap z*  <Plug>(asterisk-z*)
" noremap z#  <Plug>(asterisk-z#)

Plug 'AndrewRadev/linediff.vim'

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
let g:gutentags_ctags_exclude = ['testdata', 'build', 'bin', 'vendor', 'tags',
  \ 'github.com', 'auth_cli',
  \ '*_test.go', '*.json', '*.pb.go', '*_gen.go',
  \ ]

let g:loaded_netrwPlugin = 1
Plug 'justinmk/vim-dirvish'

func! s:filetype_dirvish()
  " silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d
  " silent! unmap <buffer><silent> <C-p>
  nnoremap <buffer><silent> q :bd<CR>
  nnoremap <buffer><silent> o :call dirvish#open("p", 1)<CR><C-w>p
  nnoremap <buffer><silent> gs :sort ,^.*[\/],<CR>:set conceallevel=3<CR>
  nnoremap <buffer><silent> gr :noau Dirvish %<CR>
  nnoremap <buffer><silent> gh :Silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d<CR>:set conceallevel=3<CR>
  if has('win32')
    nnoremap <buffer><silent> gx :SilentExt start <C-R><C-L><CR>
  else
    nnoremap <buffer><silent> gx :SilentExt open <C-R><C-L><CR>
  endif
endfun

Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
omap z <Plug>Sneak_s
omap Z <Plug>Sneak_S

func! s:scrub(s) abort
  "replace \\ with \ (greedy) #21
  return substitute(a:s, '\\\\\+', '\', 'g')
endf

func! s:open_term(direction, cmd) abort "{{{
  let dir = s:scrub(expand("%:p:h", 1))
  if !isdirectory(dir) "this happens if a directory was deleted outside of vim.
    call s:beep('invalid/missing directory: '.dir)
    return
  endif

  if !(empty($TMUX))
    silent call system("tmux split-window " .  a:direction. " -c '" . dir . "'")
  else
    call gtfo#open#term(dir, a:cmd)
  endif
endf

Plug 'justinmk/vim-gtfo'
nmap <silent> got :<c-u>call <SID>open_term("", "")<cr>
nmap <silent> gov :<c-u>call <SID>open_term("-h", "")<cr>
if has('win32')
  nmap <silent> gox :SilentExt start %<CR>
else
  nmap <silent> gox :SilentExt open %<CR>
endif
cmap %% <C-R>=fnameescape(expand('%:h'))<CR>/
nmap gon :sav %%

" Plug 'neoclide/coc.nvim', {'tag': '*'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
  \ 'coc-imselect',
  \ 'coc-snippets',
  \ 'coc-json',
  \ 'coc-go',
  \ 'coc-clangd',
  \ 'coc-emoji',
  \ 'coc-git',
  \ 'coc-rust-analyzer',
  \ 'coc-cmake',
  \ 'coc-yaml',
  \ 'coc-flutter',
  \ 'coc-tsserver',
  \ 'coc-prettier',
  \ ]

nmap <silent> gd :call <SID>goto_tag("Definition")<CR>
nmap <silent> gi :call <SID>goto_tag("Implementation")<CR>
nmap <silent> gy :call <SID>goto_tag("TypeDefinition")<CR>
nmap <silent> gh :call <SID>show_documentation()<CR>
nmap gr <Plug>(coc-references-used)
nmap gn <Plug>(coc-rename)
nmap gz <Plug>(coc-fix-current)

inoremap <silent><expr> <C-n> pumvisible() ? "\<C-n>" : coc#refresh()
inoremap <silent><expr> <cr> pumvisible() ? "\<C-e>\<cr>" : "\<cr>"
inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a v<Plug>(coc-codeaction-selected)
nmap <leader>= <Plug>(coc-format)
vmap = <Plug>(coc-format-selected)
nmap <leader>ce <Plug>(coc-codelens-action)
nmap <silent> <leader>ca :CocFzfList actions<CR>
nmap <silent> <leader>cc :CocFzfList commands<CR>
nmap <silent> <leader>cl :CocFzfList<CR>
nmap <silent> <leader>cr :CocRestart<CR>

omap if <Plug>(coc-funcobj-i)
xmap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
xmap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
nmap [a <Plug>(coc-diagnostic-prev)
nmap ]a <Plug>(coc-diagnostic-next)
nmap <silent> ]v :CocNext<CR>
nmap <silent> [v :CocPrev<CR>

omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)
nmap [g <Plug>(coc-git-chunkinfo)
nmap <expr> ]c &diff ? ']c' : '<Plug>(coc-git-nextchunk)'
nmap <expr> [c &diff ? '[c' : '<Plug>(coc-git-prevchunk)'
nmap <silent> ]g :CocCommand git.chunkUndo<CR>
xmap <leader>x  <Plug>(coc-convert-snippet)

func! s:goto_tag(tagkind) abort
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
endf

func! s:show_documentation()
  if &filetype == 'vim'
    exec 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endf

Plug 'antoinemadec/coc-fzf'
let g:coc_fzf_preview = 'up:70%'
" let g:coc_fzf_opts = []

Plug 'tyru/open-browser.vim'
let g:openbrowser_search_engines = {
  \ 'wiki': 'http://en.wikipedia.org/wiki/{query}',
  \ 'cpan': 'http://search.cpan.org/search?query={query}',
  \ 'devdocs': 'http://devdocs.io/#q={query}',
  \ 'duckduckgo': 'http://duckduckgo.com/?q={query}',
  \ 'github': 'http://github.com/search?q={query}',
  \ 'google': 'http://google.com/search?q={query}',
  \ 'rsd': 'https://docs.rs/releases/search?query={query}',
  \ 'rust': 'https://doc.rust-lang.org/nightly/std/index.html?search={query}',
  \ 'python': 'http://docs.python.org/dev/search.html?q={query}&check_keywords=yes&area=default',
  \ 'go': 'https://pkg.go.dev/search?q={query}',
  \ 'cpp': 'https://en.cppreference.com/mwiki/index.php?search={query}',
  \ }
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" let g:openbrowser_default_search = "duckduckgo"
"

Plug 'dyng/ctrlsf.vim'
let g:ctrlsf_ackprg="rg"
let g:ctrlsf_context = '-C 2'
let g:ctrlsf_search_mode = 'sync'
" let g:ctrlsf_auto_focus = {
"   \ "at" : "done",
"   \ "duration_less_than": 1000
"   \ }
let g:ctrlsf_mapping = {
  \ "open": ["<CR>", "o", "<C-O>"],
  \ "next": "<C-N>",
  \ "prev": "<C-P>",
  \ }
let g:ctrlsf_populate_qflist = 1

vmap <leader>g <Plug>CtrlSFVwordPath<CR>
nmap <leader>gs <Plug>CtrlSFCwordPath<CR>
nmap <silent> <leader>gw :silent grep <c-r><c-w> %% <cr>:copen<cr>:wincmd p<cr>
nmap <leader>go :CtrlSFToggle<CR>

if executable("rg")
  set grepprg=rg\ --vimgrep
endif

let c_no_curly_error = 1
let g:cpp_no_function_highlight = 1
let g:cpp_simple_highlight = 1
Plug 'bfrg/vim-cpp-modern'

Plug 'pboettch/vim-cmake-syntax'

Plug 'dart-lang/dart-vim-plugin'
Plug 'dag/vim-fish'
Plug 'rust-lang/rust.vim'
let g:cargo_shell_command_runner = 'Dispatch'

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'keith/swift.vim'
Plug 'cespare/vim-toml'

Plug 'mhinz/vim-crates'

Plug 'airblade/vim-rooter'
let g:rooter_manual_only = 1
let g:rooter_cd_cmd = "lcd"
let g:rooter_patterns = ['.git/', 'cargo.toml', 'go.mod']

Plug 'fatih/vim-go'
let g:go_def_mapping_enabled = 0
let g:go_textobj_enabled = 0
let g:go_gopls_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_code_completion_enabled = 0
let g:go_echo_go_info = 0
let g:go_echo_command_info = 0
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 0
let g:go_list_type = "quickfix"
let g:go_echo_go_info = 0
let g:go_def_mode = 'gopls'
let g:go_template_autocreate = 1
let g:go_template_use_pkg = 1
let g:go_gopls_options = ["-remote", "auto"]
let g:go_metalinter_autosave = 0
let g:go_metalinter_autosave_enabled = ['vet', 'golint']

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
"   au FileType clap_input inoremap <buffer><silent> <C-n> <C-R>=clap#handler#navigate_result('down')<CR>
"   au FileType clap_input inoremap <buffer><silent> <C-p> <C-R>=clap#handler#navigate_result('up')<CR>
" aug END
" nnoremap <leader>f :Clap files<CR>
" nnoremap <leader>r :Clap git_diff_files<CR>
" nnoremap <leader>b :Clap buffers<CR>
" nnoremap <leader>gh :Clap history<CR>
" nnoremap <leader>h :Clap cwd<CR>
" nnoremap <leader>v :Clap lines<CR>
" nnoremap <leader>t :Clap tags<CR>
" nnoremap <leader>gt :Clap proj_tags<CR>
" nnoremap <leader>: :Clap hist:<CR>
" nnoremap <leader>/ :Clap hist/<CR>
"
" Plug 'vn-ki/coc-clap'

" Plug 'ryanoasis/vim-devicons'
" Plug 'hardcoreplayers/spaceline.vim'

" Plug 'voldikss/vim-floaterm'
" let g:floaterm_position='right'
" let g:floaterm_gitcommit = 'tabe'
" let g:floaterm_keymap_new    = '<leader>gv'
" let g:floaterm_keymap_prev   = '<leader>gp'
" let g:floaterm_keymap_next   = '<leader>gn'
" let g:floaterm_keymap_toggle = '<c-z>'
" let g:floaterm_winblend = 10
" let g:floaterm_width = 110
" let g:floaterm_height = 0.9
" vmap <leader>gv :<c-u>'<,'>FloatermSend<CR>
" nnoremap <silent> <C-z> :update<CR>:FloatermToggle<CR>

" Plug 'lervag/vimtex'
" let g:tex_flavor = 'latex'
" let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
" let g:vimtex_view_general_options = '-r @line @pdf @tex'
" let g:vimtex_fold_enabled = 0
" let g:vimtex_view_general_callback = 'ViewerCallback'
" func! ViewerCallback(status) dict
"   if a:status
"     VimtexView
"   endif
" endf
" if has('nvim')
"   let g:vimtex_compiler_progname = 'nvr'
" endif
" aug vimtex_config
"   au!
"   au User VimtexEventQuit call vimtex#compiler#clean(0)
"   " au User VimtexEventInitPost call vimtex#compiler#compile()
" aug END

" Plug 'vim-python/python-syntax'
" let g:python_version_3 = 1
" let g:python_highlight_class_vars = 0
" let g:python_highlight_indent_errors = 0
" let g:python_highlight_space_errors = 0
" let g:python_highlight_operators = 0
" let g:python_highlight_all = 1
" let g:python_slow_sync = 0
" " a little bit slow
" Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'xltan/pythonhelper.vim'
" command! -range=% Isort :<line1>,<line2>! isort

" Plug 'delphinus/vim-auto-cursorline'
" let g:auto_cursorline_wait_ms = 5000

" Plug 'mhinz/vim-signify'
" let g:signify_vcs_list = ['git']

" omap ig <plug>(signify-motion-inner-pending)
" xmap ig <plug>(signify-motion-inner-visual)
" nnoremap [g :SignifyHunkUndo<CR>
" nnoremap ]g :SignifyHunkDiff<CR>

" Plug 'mhinz/vim-startify'
" let g:startify_change_to_dir = 0
" let g:startify_lists = [
"         \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
"         \ { 'type': 'files',     'header': ['   MRU']            },
"         \ { 'type': 'sessions',  'header': ['   Sessions']       },
"         \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
"         \ { 'type': 'commands',  'header': ['   Commands']       },
"         \ ]

if has('nvim')
  " Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
  " let g:nvimgdb_config_override = {
  "   \ 'key_next': 'n',
  "   \ 'key_step': 's',
  "   \ 'key_finish': 'f',
  "   \ 'key_continue': 'c',
  "   \ 'key_until': '<space>',
  "   \ 'key_breakpoint': 'b',
  "   \ 'set_tkeymaps': "NvimGdbNoTKeymaps",
  "   \ }
  " Plug 'nvim-treesitter/nvim-treesitter'
  " Plug 'nvim-treesitter/playground'
  " Plug 'norcalli/nvim-colorizer.lua'
else
  Plug 'vim-utils/vim-man'
endif

call plug#end()

if has("termguicolors")
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

runtime! macros/sandwich/keymap/surround.vim
let g:sandwich#recipes += [
  \ {
  \   'buns'    : ['dbg!(', ')'],
  \   'filetype': ['rust'],
  \   'kind'    : ['add'],
  \   'action'  : ['add'],
  \   'input'   : ['d'],
  \ },
  \ {
  \   'buns'    : ['RegInput(0)', 'RegInput(1)'],
  \   'expr'    : 1,
  \   'kind'    : ['add'],
  \   'action'  : ['add'],
  \   'input'   : ['0'],
  \ },
  \ ]
func! RegInput(is_tail)
  if a:is_tail
    return ')'
  endif
  let tag = @0 . '('
  return tag
endf

" Eager-load these plugins so we can override their settings.
runtime! plugin/unimpaired.vim
runtime! plugin/rsi.vim
runtime! plugin/dispatch.vim

func! s:dispatch_hack(bang, qargs, count)
  let g:dispatch_flag = 1
  exec dispatch#compile_command(a:bang, a:qargs, a:count, '<mods>')
endf

func! s:make_hack(bang, qargs, count)
  let g:dispatch_flag = 1
  exec dispatch#compile_command(a:banng, '-- ' . a:qargs, a:count, '<mods>')
endf

command! -bang -nargs=* -range=-1 -complete=customlist,dispatch#command_complete Dispatch 
  \ call s:dispatch_hack(<bang>0, <q-args>, <count> < 0 || <line1> == <line2> ? <count> : 0)

command! -bang -nargs=* -range=-1 -complete=customlist,dispatch#make_complete Make 
  \ call s:dispatch_hack(<bang>0, '-- ' . <q-args>, <count> < 0 || <line1> == <line2> ? <count> : 0)

nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

inoremap <C-E> <End>
inoremap <M-t> <esc>diwbPa <esc>ea
if !has("gui_running") " from tpope/vim-rsi
  silent! exec "set <F36>=\<esc>t"
  map! <F36> <M-t>
  map <F36> <M-t>
endif

set mps+=<:>
if !has('nvim')
  packadd! matchit
endif
packadd! cfilter

nnoremap <silent> coz :if exists("g:syntax_on") <Bar>
  \   syntax off <Bar>
  \ else <Bar>
  \   syntax on <Bar>
  \ endif <CR>

nnoremap <silent> cos :if stridx(@/, '\<') == 0 <Bar>
  \   let @/=@/[2:-3] <Bar>
  \ else <Bar>
  \   let @/='\<'.@/.'\>' <Bar>
  \ endif <CR>

nnoremap <silent> cof :if get(b:, "syntax_fromstart", v:false) <Bar>
  \   let b:syntax_fromstart = v:false <Bar> syn sync minlines=60 <Bar>
  \ else <Bar>
  \   let b:syntax_fromstart = v:true <Bar> syn sync fromstart <Bar>
  \ endif <CR>

func! s:option_map(...)
  let [key, opt] = a:000[0:1]
  let op = get(a:, 3, 'setlocal '.opt.'!')
  exec printf("nnoremap co%s :%s<bar>set %s?<CR>", key, op, opt)
endf
call s:option_map('w', 'wrap')
call s:option_map('i', 'ignorecase')
call s:option_map('p', 'paste')
call s:option_map('e', 'expandtab', 'setlocal expandtab!<bar>retab')
call s:option_map('t', 'ts',
  \ 'let &ts = input("tabstop (". &ts ."): ")<bar>let &sw=&ts<bar>redraw')

func! s:reset_color() abort
  hi! link Folded GitGutterChange
  hi! link CocWarningSign Todo
  hi! link CocErrorSign GitGutterDelete
  hi! link MatchParen GitGutterDelete

  hi! link fugitiveHunk Comment
  hi! link gitDiff Comment
  hi! link DiffNewFile Comment
  hi! link diffIndexLine Comment
  hi! link Delimiter Normal
  hi! link TSParameter Normal
  hi DiffAdded guibg=NONE
  hi DiffRemoved guibg=NONE
  hi ErrorMsg guibg=NONE
  hi Statement gui=NONE
  hi ModeMsg gui=NONE
  exec "hi DiffAdd gui=bold guibg=#" . g:base16_gui02
  exec "hi DiffDelete gui=NONE guibg=#" . g:base16_gui02
  exec "hi DiffText gui=bold guifg=#" .g:base16_gui0A . " guibg=#" . g:base16_gui02
  exec "hi DiffChange guibg=#" . g:base16_gui02
  exec "hi DiffFile guifg=#". g:base16_gui04
  exec "hi VertSplit guifg=#". g:base16_gui01 . " guibg=#" . g:base16_gui01
  exec "hi StatusLine guifg=#". g:base16_gui05 . " guibg=#" . g:base16_gui01
  exec "hi QuickfixLine guifg=#". g:base16_gui0A . " guibg=#" . g:base16_gui02
  exec "hi FzfWindow guifg=#". g:base16_gui02

  " hi link CocListsLine QuickfixLine
  " hi! link FloatermBorder Comment
  hi! link jsonCommentError Comment
  hi! link CocHintSign Comment
  hi! link CocHoverRange Comment

  hi! link PmenuSel Visual
  hi! link PmenuThumb Visual
  hi! link PmenuSbar Pmenu
endf

set background=dark
color base16-tomorrow-night
call s:reset_color()

set lazyredraw guioptions= mouse=a winwidth=100
set hlsearch nowrap noshowmode laststatus=2
set autoindent smarttab gdefault
set hidden autowrite autoread
set nobackup undofile backupdir=$VIMFILES/.swap directory=$VIMFILES/.swap// undodir=$VIMFILES/.undo
set ignorecase smartcase tagcase=match
set exrc nofixeol listchars=tab:\|\ ,eol:¬
set formatoptions+=j viminfo^='500
set timeoutlen=500 updatetime=500 scrolloff=3 diffopt+=vertical,algorithm:patience,indent-heuristic
set shortmess+=c
set inccommand=nosplit
syn sync minlines=60

" set sw=4 ts=4 textwidth=120 number relativenumber
" set foldnestmax=2 foldmethod=expr foldcolumn=1 nofoldenable
" set foldexpr=nvim_treesitter#foldexpr()
" set cinoptions=:0,g0,(0,Ws,l1
" set wildignore=*.pyc,*.pyo,*.exe,*.DS_Store,._*,*.svn,*.git,*.o,*.dSYM,*.ccls-cache,
"     \*.vscode,tags,*.vs,*.pyproj,*.idea,*.clangd,*__pycache__,
"     \*.bin,*.rlib,*.rmeta

" for c-family files
func! s:alternate(cmd)
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
          exec a:cmd a
          return
        end
      endfor
    endif
  endfor
endf

func! s:python_super()
  let pattern = '^class [^(]*(\zs[^)]*\ze):'
  let lineno = search(pattern, 'bn')
  let content = getline(lineno)
  let m = matchstr(content, pattern)
  let sm = split(m, '\.')
  exec 'tag '.sm[len(sm)-1]
  return
endf

aug vimrc_filetype
  au!
  au FileType dirvish call s:filetype_dirvish()
  au Filetype go call s:filetype_go()
  au Filetype python call s:filetype_python()
  au FileType rust call s:filetype_rust()
  au FileType c,cpp,objc,objcpp call s:filetype_cfamily()
  au FileType vim call s:filetype_vim()

  au FileType git setlocal foldmethod=syntax
    \| nnoremap <buffer> coc 0w:exec "G checkout ".expand("<cWORD>")<CR>
    \| nnoremap <buffer> cdd 0w:exec "G branch -D ".expand("<cWORD>")<CR>
    \| nnoremap <buffer> q <c-w>q
    \| nmap <buffer> ]<space> ]/
    \| nmap <buffer> [<space> [/
  au FileType fugitiveblame,fugitive nnoremap <buffer> q <c-w>q
  au FileType gitcommit setlocal foldmethod=syntax nofoldenable

  au filetype markdown nnoremap <buffer><silent> gN O<Esc>C- [ ] 
    \| nnoremap <buffer><silent> gn o<Esc>C- [ ] 
    \| nnoremap <buffer><silent> gd :<HOME>silent! <END>S/- [{ ,x}]/- [{x, }]/<CR>:nohl<CR>
    \| nnoremap <buffer><silent> <leader>q :q<CR>
    " \| setlocal conceallevel=2
  au FileType lua,typescript,javascript,json,yaml,fish setlocal expandtab ts=2 sw=2
  au FileType tex setlocal ts=2 sw=2
  au FileType sh setlocal ts=4 sw=4 expandtab
  au FileType make setlocal noexpandtab
  au FileType fzf tnoremap <buffer><silent> <Esc> <C-c>
    \| tnoremap <buffer><silent> <C-j> <C-n>
    \| tnoremap <buffer><silent> <C-k> <C-p>
    \| tnoremap <buffer><silent> <C-h> <BS>
  au FileType cs,json,java,gomod,dot setlocal commentstring=//\ %s
  au FileType cmake,tmux,cfg setlocal commentstring=#\ %s
aug END

aug vimrc_misc
  au!
  au BufRead * if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") | exec "normal g`\"" | endif
  au BufRead *gl.vs,*gl.ps setlocal ft=glsl iskeyword=@,48-57,_,128-167,224-235
  au BufRead,BufNewFile .clang-format setlocal ft=yaml
  au BufRead,BufNewFile go.mod setlocal ft=gomod
  au BufRead,BufNewFile *.tmpl setlocal ft=gohtmltmpl
  au BufRead,BufNewFile .localrc setlocal ft=vim
  au BufRead goscripts setlocal ft=go
  au BufRead *.mangle setlocal equalprg=c++filt
  " au BufRead Cargo.toml call crates#toggle()
  " au ColorScheme * call <SID>reset_color()
  " au WinEnter * if &diff | call<SID>stupid_diff() | endif
  " au FocusGained,CursorHold ?* if getcmdwintype() == '' | checktime | endif
aug END

" Save current view settings on a per-window, per-buffer basis.
func! s:winview_autosave()
  if !exists("w:saved_view")
    let w:saved_view = {}
  endif
  let w:saved_view[bufnr("%")] = winsaveview()
endf

" Restore current view settings.
func! s:winview_autorest()
  let buf = bufnr("%")
  if exists("w:saved_view") && has_key(w:saved_view, buf)
    let v = winsaveview()
    let is_start = v.lnum == 1 && v.col == 0
    if is_start && !&diff
      call winrestview(w:saved_view[buf])
    endif
    unlet w:saved_view[buf]
  endif
endf

aug vimrc_autosave
  au!
  au BufLeave * call s:winview_autosave()
  au BufEnter * call s:winview_autorest()
aug end

" func! s:goto_index(dir)
"   let winnr = bufwinnr('^.git/index$')
"   if winnr > 0
"     exec winnr 'wincmd w'
"   endif
"   if a:dir == "n"
"     exec "normal \<c-n>"
"   else
"     exec "normal \<c-p>"
"   end
"   normal dv
" endf

" func! s:stupid_diff()
"   if winheight(0) < (&lines - 13)
"     exec "resize " . (&lines - 13)
"   endif
"   nmap <buffer><silent> ]d :call <SID>goto_index("n")<CR>
"   nmap <buffer><silent> [d :call <SID>goto_index("p")<CR>
" endf

vnoremap <C-C> "+y
vnoremap <C-Insert> "+y
map <C-Q> "+gP
cmap <C-Q> <C-R>+
exec 'inoremap <script> <C-Q> <C-G>u' . paste#paste_cmd['i']
exec 'vnoremap <script> <C-Q> ' . paste#paste_cmd['v']

nnoremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <Esc>:update<CR>
inoremap <silent> ZZ <Esc>ZZ

nnoremap <silent> L :nohl<CR>

func! s:get_buffer_list()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endf

inoremap <C-^> <Esc><C-^>
inoremap <C-l> <C-o>zz
inoremap <C-k> <C-o>k
inoremap <C-j> <C-o>j

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

if has('nvim')
" lua <<EOF
" require 'nvim-treesitter.configs'.setup {
" ensure_installed = { "go", "c", "cpp", "typescript", "javascript"},
" highlight = {
" enable = true,            -- false will disable the whole extension
" disable = {"rust"},       -- list of language that will be disabled
" },
" }
" require 'colorizer'.setup {
" 'css';
" 'javascript';
" 'vim';
" }
" EOF
  
  aug vimrc_term
    au!
    au TermLeave * setlocal scrolloff=3
    au TermOpen * setlocal statusline=%{b:term_title} | nnoremap <buffer> q a<CR>
    au BufEnter term://* startinsert
  aug END

  tnoremap <Esc> <C-\><C-n>
  tnoremap <expr> <M-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  tnoremap [w <C-\><C-n>gT
  tnoremap ]w <C-\><C-n>gt
  tnoremap g<Tab> <C-\><C-n>g<Tab>
  tnoremap <silent><C-d> <C-\><C-n>:call <SID>end_terminal()<CR>
  " tnoremap <C-^> <C-\><C-n>:FloatermToggle<CR>:
  " tnoremap <silent><C-z> <C-\><C-N>:FloatermToggle<CR>
else
  tnoremap <Esc> <C-w>N
  tnoremap [w <C-w>NgT
  tnoremap ]w <C-w>Ngt
  tnoremap g<Tab> <C-w>Ng<Tab>
endif

nnoremap Q @q
xnoremap Q :normal @q<CR>

vnoremap < <gv
vnoremap > >gv
nnoremap gV `[v`]
nnoremap Y y$
vnoremap P y`>o<Esc>p
nnoremap yp vapyP

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

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
    exec 'silent! !start '. s:tortoise_svn_path. ' /command:'. a:cmd. ' /path:"'. a:path. '"'
  endf
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

func! s:closetab()
  let lasttab = tabpagenr()
  exec "normal g\<tab>"
  exec "tabclose " . lasttab
endf
nmap <silent><leader>w :call <SID>closetab()<CR>
nmap [w gT
nmap ]w gt
nmap [W :tabfirst<CR>
nmap ]W :tablast<CR>
nmap <silent> <M-1> 1gt
nmap <silent> <M-2> 2gt
nmap <silent> <M-3> 3gt
nmap <silent> <M-4> 4gt
nmap <silent> <M-5> 5gt
nmap <silent> <M-6> 6gt
nmap <silent> <M-7> 7gt
nmap <silent> <M-8> 8gt
nmap <silent> <M-9> 9gt

noremap <silent> [[ m':call search('{', 'b')<CR>:keepjumps normal w99[{<CR>^
noremap <silent> ][ m':call search('}')<CR>:keepjumps normal b99]}<CR>
noremap <silent> ]] m'j0:call search('{', 'b')<CR>:keepjumps normal w99[{<CR>:keepjumps normal! %<CR>:call search('{')<CR>^
noremap <silent> [] m'k$:call search('}')<CR>:keepjumps normal b99]}<CR>:keepjumps normal! %<CR>:call search('}', 'b')<CR>

nnoremap <leader>et :tabe ~/Documents/notes/todo.md<CR>
nnoremap <leader>er :tabe ~/Documents/notes/reading.md<CR>
nnoremap <leader>en :tabe ~/Documents/notes<CR>:lcd %:h<CR>:pwd<CR>
nnoremap <leader>es :tabe $VIMFILES/bundle/vim-extra-snippets/UltiSnips<CR>:lcd %:h<CR>:pwd<CR>

nnoremap <leader>cd :lcd %:h<CR>:pwd<CR>
nnoremap <leader><space> za
nnoremap <silent><leader>z :call <SID>qfix_toggle()<CR>
nnoremap <silent><leader>co :call <SID>copen_hack("\|normal G")<CR>

func! s:copen_hack(a)
  let g:dispatch_quickfix_height = 10
  exec "Copen | copen 10". a:a
  let g:dispatch_quickfix_height = 0
endf

" used to track the quickfix window
aug vimrc_qfix_toggle
  au!
  au BufWinEnter * call s:bufwinenter()
  au BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
aug END

func! s:qfix_toggle()
  if exists("g:qfix_win")
    cclose
  else
    call s:copen_hack('')
  endif
endf

func! s:preserve(command)
  let _s=@/
  let v = winsaveview()
  exec 'silent '.a:command
  call winrestview(v)
  let @/=_s
endf

nmap _$ :call <SID>preserve("%s/\\s\\+$//e")<CR>
" nmap _= :call <SID>preserve("normal! gg=G")<CR>

func! s:indent_len(str)
  return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
endf

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
  exec printf('normal! %dGV%dG', max([1, d[0] + a:bd]), min([x, d[1] + a:ed]))
endf
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
  silent exec a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put!=message
  endif
endf

func! s:source_if_exists(file)
  if filereadable(expand(a:file))
    exec 'source' a:file
  endif
endf

func! s:end_terminal() abort
  let col = col('.')
  if col == 1
    bd!
  else
    startinsert
    call feedkeys("\<C-d>", 'n')
  endif
endf

func! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endf

func! s:cppcheck()
  cclose
  update
  setlocal makeprg=cppcheck\ --enable=all\ %
  setlocal errorformat=[%f:%l]\ ->\ %m,[%f:%l]:%m
  let curr_dir = expand('%:h')
  if curr_dir == ''
    let curr_dir = '.'
  endif
  echo curr_dir
  exec 'lcd ' . curr_dir
  exec 'lcd -'
endf

func! s:unescape()
  silent %s/\\n/\r/
  silent %s/\\t/\t/
  silent %s/\S*\/seatalk-server\///
endf

function s:diff_current_quickfix_entry() abort
  " Cleanup windows
  diffoff!
  silent! only
  silent! cc
  call s:add_mappings()
  let qf = getqflist({'context': 0, 'idx': 0})
  if get(qf, 'idx') && type(get(qf, 'context')) == type({}) && type(get(qf.context, 'items')) == type([])
    let diff = get(qf.context.items[qf.idx - 1], 'diff', [])
    for i in reverse(range(len(diff)))
      exec 'leftabove vert diffsplit' fnameescape(diff[i].filename)
      call s:add_mappings()
      wincmd l
    endfor
  endif
endf

func! s:add_mappings() abort
  nnoremap <buffer><silent> [<C-Q> :cpfile <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  nnoremap <buffer><silent> ]<C-Q> :cnfile <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  nnoremap <buffer><silent> [q :cprevious <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  nnoremap <buffer><silent> ]q :cnext <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  copen 10
  wincmd p
endf

func! s:code(args)
  let args = a:args
  if len(args) == 0
    let args = '.'
  endif
  exec 'silent !code -r ' . args
endf

func! s:open_origin_file()
  let filename = @%
  exec "e ".substitute(filename, "fugitive.*\.git\/\/[a-f0-9]*\/", "", "")
endf

func! s:command_abbr(args, abbreviation, expansion)
  exec 'cabbr ' . a:args . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endf

func! s:quickfix_replace(sstr)
  let w = ""
  let idx = stridx(a:sstr, '/')
  if idx == 0
    let w = expand("<cword>")
  elseif idx < 0
    let w = expand("<cword>") . '/'
  endif
  exec 'cfdo %s/' . w . a:sstr . '/ | update'
endf

if has('gui_running')
  if has('win32')
    let g:prog_name = '!start gvim'
  elseif has('mac')
    let g:prog_name = 'silent !mvim'
  endif

  command! -nargs=0 -complete=command New exec g:prog_name
  command! -nargs=0 -complete=command Restart exec g:prog_name . " %" | quitall
endif

command! -nargs=* -complete=tag Grep silent grep <args> | cwindow | cc
command! -nargs=+ SilentExt exec 'silent !'. <q-args> | redraw!
command! -nargs=+ Execute exec '!'. <q-args> | redraw!
command! -nargs=+ Silent exec 'silent <args>' | redraw!
command! -nargs=? CodeCommand call s:code(<q-args>)
command! -nargs=? Code exec 'CodeCommand -g ' . expand('%:p').':'.line('.') . ' --folder-uri '.getcwd()

command! -nargs=0 Only %bd|e#
command! -nargs=0 Todo exec "Grep 'XFIXME'"

command! -nargs=* -complete=function Doc exec s:std_get_commands(<q-args>)
command! -nargs=* -complete=function Dev exec s:std_get_commands(<q-args>)
command! -nargs=* -complete=function Rs exec 'OpenBrowserSearch -rsd ' . s:get_args(<q-args>)

command! -nargs=+ -complete=command TabMessage call s:tab_message(<q-args>)
command! -nargs=0 OrganizeImport silent call CocAction("runCommand", "editor.action.organizeImport")

command! -nargs=0 UE exec "normal o\<C-o>" . len(getline('.')). "i="
command! -nargs=0 UM exec "normal o\<C-o>" . len(getline('.')). "i-"
command! -nargs=0 Unescape call s:unescape()
command! -nargs=0 Unstack setlocal efm-=%-G%.%# efm+=%f:%l | cbuffer
command! -nargs=1 VagrantProvision exec "Dispatch! vagrant provision --provision-with " . <q-args>

command! -nargs=? DiffBranch exec "Git difftool " . <q-args> | wincmd p | call s:diff_current_quickfix_entry()
command! -nargs=0 DiffQuickfix call s:diff_current_quickfix_entry()

command! -nargs=* Cabbr call s:command_abbr("", <f-args>)
command! -nargs=* Cabbrb call s:command_abbr("<buffer>", <f-args>)

command! -nargs=1 QuickfixReplace call s:quickfix_replace(<q-args>)
command! -nargs=0 QuickfixUndo cfdo exec "normal u" | update

" Cabbr gdb GdbStartLLDB\ lldb

Cabbr co Code
Cabbr sf CtrlSF
Cabbr gp Grep
Cabbr gpi Grep\ -i
Cabbr gpn Grep\ --no-ignore
Cabbr qr QuickfixReplace
Cabbr qu QuickfixUndo

Cabbr Gfa Git\ fa\ --prune

Cabbr os OpenBrowserSearch
Cabbr og OpenBrowserSearch\ -go
Cabbr oc OpenBrowserSearch\ -cpp

Cabbr db DiffBranch
Cabbr gl GV\ -22
Cabbr glc GV!
Cabbr ge call\ <SID>open_origin_file()

Cabbr vp VagrantProvision

call s:source_if_exists($VIMFILES.'/.localrc')
if getcwd() != $HOME | call s:source_if_exists(getcwd() . '/.vimrc') | endif

func! s:filetype_python()
  nmap <buffer><silent> ]s :call <SID>python_super()<CR>
  nmap <buffer><silent> [s <C-^>
  command! -buffer -nargs=0 -complete=command ImportRemove update | Execute autoflake --in-place --remove-all-unused-imports %<CR>
endf

func! s:toggle_words(l, r)
  let cline = getline(".")
  if stridx(cline, a:l) >= 0
    let r = a:r
    if stridx(r, '&') >= 0
      let r = substitute(r, '&', '\\\&', '')
      echo r
    end
    call setline('.', substitute(cline, a:l, r, ''))
  elseif stridx(cline, a:r) >= 0
    let r = a:l
    if stridx(r, '&') >= 0
      let r = substitute(r, '&', '\\\&', 'g')
    end
    call setline('.', substitute(cline, a:r, r, ''))
  end
endf

func! s:filetype_go()
  Cabbrb gat CocCommand\ go.tags.add
  Cabbrb grt CocCommand\ go.tags.clear
  Cabbrb gi CocCommand\ go.impl.cursor
  nnoremap <buffer><silent> s; :<c-u>call <SID>toggle_words(' := ',' = ')<CR>
  setlocal sw=4 ts=4
  aug filetype_go
    au! * <buffer>
    au BufWritePre <buffer> OrganizeImport
  aug END
  silent au! vim-go-buffer
endf

func! s:filetype_rust()
  setlocal iskeyword+=!
  nnoremap <buffer><silent> s; :<c-u>call <SID>toggle_words('let mut', 'let')<CR>
  nnoremap <buffer><silent> s7 :<c-u>call <SID>toggle_words('&mut ', '&')<CR>
  nnoremap <buffer><silent> s/ :<c-u>call <SID>toggle_words('{}', '{:?}')<CR>
endf

func! s:filetype_cfamily()
  setlocal expandtab ts=2 sw=2
  setlocal commentstring=//\ %s
  command! -buffer -nargs=0 A call s:alternate('e')
  command! -buffer -nargs=0 AV call s:alternate('botright vertical split')
  command! -buffer -nargs=0 Cppcheck call s:cppcheck()
endf

func! s:filetype_vim()
  setlocal expandtab ts=2 sw=2
  aug filetype_vim
    au! * <buffer>
    au BufWrite <buffer> so %
  aug END
endf

func! s:bufwinenter()
  if &filetype ==# 'help'
    wincmd L
    nnoremap <buffer><silent> q :bd<CR>
  elseif &filetype ==# 'man'
    silent wincmd T
  elseif &filetype ==# 'qf'
    wincmd J
    setlocal nonu norelativenumber
    let g:qfix_win = bufnr("$")
    nnoremap <buffer><silent> q :cclose<CR>
  endif
endf
