if !has('nvim')
  source $VIMRUNTIME/defaults.vim
endif

command! -nargs=+ SilentExt execute 'silent !'. <q-args> | redraw!
command! -nargs=+ Execute execute '!'. <q-args> | redraw!
command! -nargs=+ Silent execute 'silent <args>' | redraw!
command! -bang -nargs=* -complete=file Grep silent grep <args> | cwindow
command! -nargs=? Code call s:code(<q-args>)
command! -nargs=? Co exec "Code -g " . expand('%:p').":". line('.')
func! s:code(args)
  let args = a:args
  if len(args) == 0
    let args = '.'
  endif
  exec 'silent !code -r ' . args
endfunc

let mapleader = " "
let maplocalleader = " "
let s:username = "Sinon"

set encoding=utf-8
set fileencoding=utf-8

let $VIMFILES=split(&rtp, ",")[0]
set rtp+=$HOME/.fzf
call plug#begin($VIMFILES . '/bundle')
Plug 'chriskempson/base16-vim'

Plug 'tpope/vim-characterize'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'
Plug 'AdUki/vim-dispatch-neovim'

nmap s<CR> :Start<CR>
nmap S<CR> :exec "Start -dir=" . expand("%:h")<CR>

aug dispatch_setting
  au!
  au FileType,BufWrite * call s:setup_makeprg()
aug END

let s:m = {
  \ 'dirvish': 'sh <sfile>',
  \ 'python': 'python %',
  \ 'cpp': "make CC='g++' CXXFLAGS='-std=c++17' %:p:r && %:p:r",
  \ 'c': 'make %:p:r && %:p:r',
  \ 'sh': 'sh %',
  \ 'go': 'go run %',
  \ 'rust': 'cargo run',
  \ }
let s:o = {
  \ 'go': 'go',
  \ 'rust': 'cargo',
  \ }

func! s:setup_makeprg()
  let f = &filetype
  let prg = get(s:m, f, '')
  let oprg = get(s:o, f, prg)
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
    exec "nmap <buffer> g<cr> :Dispatch ". prg. '<CR>'
    exec "nmap <buffer> g<space> :Dispatch ". oprg. '<space>'
    exec "nmap <buffer> g! :Dispatch! ". oprg. '<space>'
    exec "nmap <buffer> s<space> :Start ". oprg. '<space>'
    exec "nmap <buffer> s! :Dispatch! ". oprg. '<space>'
  end
endf

func s:get_go_func()
  let test = search('func \(Test\|Example\)', "bcnW")
  if test == 0
    return ""
  end
  let line = getline(test)
  let name = split(split(line, " ")[1], "(")[0]
  return name
endfunc

Plug 'machakann/vim-sandwich'

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

Plug 'junegunn/vim-easy-align'
vmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)

Plug 'tittanlee/fzf-tags'
nmap <C-]> <Plug>(fzf_tags)
" nnoremap <silent> <C-]> :tjump <C-r><C-w><CR>

Plug 'junegunn/fzf.vim'
let $FZF_DEFAULT_OPTS='--inline-info --layout=reverse'
let $FZF_DEFAULT_COMMAND="fd --type f --color never --no-ignore-vcs --exclude /vendor --exclude /target/debug --exclude /node_modules"
" let g:fzf_preview_window = 'right:60%'
nnoremap <leader>f :Files<CR>
nnoremap <leader>r :Files %:h<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>gh :History<CR>
nnoremap <leader>h :CwdHistory<CR>
nnoremap <leader>v :Lines<CR>

nnoremap <leader>j :BTags<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>: :History:<CR>
nnoremap <leader>/ :History/<CR>

let g:fzf_preview_window = ''

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  cwindow
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

if has('nvim')
  let s:fzf_floating_window_height = min([20, &lines])
  function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    let height = s:fzf_floating_window_height
    let width = min([140, float2nr(&columns - (&columns * 2 / 12))])
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
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'nvim-treesitter/playground'
  Plug 'norcalli/nvim-colorizer.lua'
else
  let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.6, 'highlight': 'Comment' }}
endif

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

Plug 'tpope/vim-markdown'
let g:markdown_fenced_languages = ['go', 'c', 'cpp', 'python', 'bash=sh', 'rust', 'javascript', 'js=javascript', 'json', 'yaml', 'css', 'xml', 'html']
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
  " if word =~ "^std"
  "   return 'silent !rustup doc '. word
  " endif
  return 'OpenBrowserSearch -' . &filetype . ' ' . word
endfunction

command! -bang -nargs=* -complete=command Doc execute <SID>std_get_commands(<q-args>)
command! -bang -nargs=* -complete=command Dev execute <SID>std_get_commands(<q-args>)
command! -bang -nargs=* -complete=command Rs execute 'OpenBrowserSearch -rsd ' . <SID>get_args(<q-args>)

let g:targets_aiAI = 'ai  '
Plug 'wellle/targets.vim'
Plug 'wellle/tmux-complete.vim'
" Plug 'wellle/context.vim'
" let g:context_nvim_no_redraw = 1
Plug 'machakann/vim-swap'
let g:swap_no_default_key_mappings = 1
map z[ <Plug>(swap-prev)
map z] <Plug>(swap-next)

" Plug 'lervag/vimtex'
" let g:tex_flavor = 'latex'
" let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
" let g:vimtex_view_general_options = '-r @line @pdf @tex'
" let g:vimtex_fold_enabled = 0
" let g:vimtex_view_general_callback = 'ViewerCallback'

" function! ViewerCallback(status) dict
"   if a:status
"     VimtexView
"   endif
" endfunction
" if has('nvim')
"   let g:vimtex_compiler_progname = 'nvr'
" endif
" aug vimtex_config
"   au!
"   au User VimtexEventQuit call vimtex#compiler#clean(0)
"   " au User VimtexEventInitPost call vimtex#compiler#compile()
" aug END

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

Plug 'AndrewRadev/linediff.vim'

Plug 'xltan/algorithm-mnemonics.vim'
let g:algorithm_mnemonics_lambda_parameter = ""
Plug 'honza/vim-snippets'
let g:snips_author = s:username
let g:snips_email = "lidmuse@email.com"
let g:snips_github = "https://github.com/xltan"
Plug 'xltan/vim-extra-snippets'
xmap <leader>x  <Plug>(coc-convert-snippet)

Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = [ 'tags' ]
" '.git', '.svn', '.gutctags', '.clang-format', '.ignore']
let g:gutentags_exclude_project_root = ['/usr/local', $HOME, $HOME.'/Documents']
let g:gutentags_ctags_exclude = ['testdata', 'build', 'bin', 'vendor', 'tags', 
    \ 'github.com', 'auth_cli',
    \ '*_test.go', '*.json', '*.pb.go', '*_gen.go',
    \ ]

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

let g:loaded_netrwPlugin = 1
Plug 'justinmk/vim-dirvish'

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
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S

" Plug 'easymotion/vim-easymotion'
" let g:EasyMotion_do_mapping = 0
" let g:EasyMotion_smartcase = 1
" let g:EasyMotion_do_shade = 0
" nmap <leader>s <Plug>(easymotion-overwin-f2)

let s:istmux = !(empty($TMUX))

func! s:scrub(s) abort
  "replace \\ with \ (greedy) #21
  return substitute(a:s, '\\\\\+', '\', 'g')
endf

func! s:open_term(direction, cmd) abort "{{{
  let l:dir = s:scrub(expand("%:p:h", 1))
  if !isdirectory(l:dir) "this happens if a directory was deleted outside of vim.
    call s:beep('invalid/missing directory: '.l:dir)
    return
  endif

  if s:istmux
    silent call system("tmux split-window " .  a:direction. " -c '" . l:dir . "'")
  else
    call gtfo#open#term(l:dir, a:cmd)
  endif
endfunc

Plug 'justinmk/vim-gtfo'
let g:gtfo#terminals = { 'win': 'cmd.exe /k' }
nnoremap <silent> got :<c-u>call <SID>open_term("", "")<cr>
nnoremap <silent> gov :<c-u>call <SID>open_term("-h", "")<cr>
if has('win32')
  nmap gox :SilentExt start %<CR>
else
  nmap gox :SilentExt open %<CR>
endif
cnoremap %% <C-R>=fnameescape(expand('%:h'))<CR>/
nmap gon :sav %%

let s:error_symbol = '>'
let s:warning_symbol = '-'

Plug 'antoinemadec/coc-fzf'
let g:coc_global_extensions = [
\ 'coc-imselect',
\ 'coc-snippets',
\ 'coc-json',
\ 'coc-go',
\ 'coc-clangd',
\ 'coc-rust-analyzer',
\ 'coc-cmake',
\ 'coc-yaml',
\ 'coc-flutter',
\ 'coc-tsserver',
\ 'coc-prettier',
\ ]
" Plug 'neoclide/coc.nvim', {'tag': '*'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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
omap if <Plug>(coc-funcobj-i)
xmap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
xmap af <Plug>(coc-funcobj-a)
nmap <silent> ]v :CocNext<CR>
nmap <silent> [v :CocPrev<CR>
xmap <silent> <leader>a <Plug>(coc-codeaction-selected)
nmap <silent> <leader>a v<Plug>(coc-codeaction-selected)
nmap <silent> [a <Plug>(coc-diagnostic-prev)
nmap <silent> ]a <Plug>(coc-diagnostic-next)
nnoremap <leader>ca :CocFzfList actions<CR>
nnoremap <leader>cc :CocFzfList commands<CR>
vmap <silent> <leader>f  <Plug>(coc-format-selected)

" nmap [c <Plug>(coc-git-prevchunk)
" nmap ]c <Plug>(coc-git-nextchunk)
" " show chunk diff at current position
" nmap [r <Plug>(coc-git-chunkinfo)
" " show commit contains current position
" nmap ]r :CocCommand git.chunkUndo<CR>
" " create text object for git chunks
" omap ic <Plug>(coc-git-chunk-inner)
" xmap ic <Plug>(coc-git-chunk-inner)
" omap ac <Plug>(coc-git-chunk-outer)
" xmap ac <Plug>(coc-git-chunk-outer)

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
\   'wiki': 'http://en.wikipedia.org/wiki/{query}',
\   'cpan': 'http://search.cpan.org/search?query={query}',
\   'devdocs': 'http://devdocs.io/#q={query}',
\   'duckduckgo': 'http://duckduckgo.com/?q={query}',
\   'github': 'http://github.com/search?q={query}',
\   'google': 'http://google.com/search?q={query}',
\   'rsd': 'https://docs.rs/releases/search?query={query}',
\   'rust': 'https://doc.rust-lang.org/nightly/std/index.html?search={query}',
\   'python': 'http://docs.python.org/dev/search.html?q={query}&check_keywords=yes&area=default',
\   'go': 'https://pkg.go.dev/search?q={query}',
\   'cpp': 'https://en.cppreference.com/mwiki/index.php?search={query}',
\}
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" let g:openbrowser_default_search = "duckduckgo"
"

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
nmap <silent> <leader>gw :silent grep <c-r><c-w> %% <cr>:copen<cr>:wincmd p<cr>
nmap <leader>go :CtrlSFToggle<CR>

if executable("rg")
  set grepprg=rg\ --vimgrep
endif

" " language related
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

let c_no_curly_error = 1
let g:cpp_no_function_highlight = 1
let g:cpp_simple_highlight = 1
Plug 'bfrg/vim-cpp-modern'

Plug 'pboettch/vim-cmake-syntax'

Plug 'dart-lang/dart-vim-plugin'
Plug 'dag/vim-fish'
Plug 'rust-lang/rust.vim'
let g:cargo_shell_command_runner = 'Dispatch!'

Plug 'fatih/vim-go'
let g:go_def_mapping_enabled = 0
let g:go_textobj_enabled = 0
let g:go_gopls_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 0
let g:go_list_type = "quickfix"
let g:go_doc_url = 'https://pkg.go.dev'
let g:go_echo_go_info = 0
let g:go_def_mode = 'gopls'
let g:go_template_autocreate = 1
let g:go_template_use_pkg = 1
" let g:go_gopls_options = ["-remote", "auto"]
" let g:go_metalinter_autosave = 1
" let g:go_metalinter_autosave_enabled = ['vet', 'golint']

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'keith/swift.vim'
Plug 'cespare/vim-toml'

" Plug 'delphinus/vim-auto-cursorline'
" let g:auto_cursorline_wait_ms = 5000

Plug 'mhinz/vim-signify'
let g:signify_vcs_list = ['git']

omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
nnoremap [r :SignifyHunkUndo<CR>
nnoremap ]r :SignifyHunkDiff<CR>

Plug 'mhinz/vim-crates'
" Plug 'mhinz/vim-startify'
" let g:startify_change_to_dir = 0
" let g:startify_lists = [
"         \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
"         \ { 'type': 'files',     'header': ['   MRU']            },
"         \ { 'type': 'sessions',  'header': ['   Sessions']       },
"         \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
"         \ { 'type': 'commands',  'header': ['   Commands']       },
"         \ ]

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

runtime! macros/sandwich/keymap/surround.vim
let g:sandwich#recipes += [
      \   {
      \     'buns'    : ['dbg!(', ')'],
      \     'filetype': ['rust'],
      \     'kind'    : ['add'],
      \     'action'  : ['add'],
      \     'input'   : ['d'],
      \   },
      \   {
      \     'buns'    : ['RegInput(0)', 'RegInput(1)'],
      \     'expr'    : 1,
      \     'kind'    : ['add'],
      \     'action'  : ['add'],
      \     'input'   : ['0'],
      \   },
      \ ]
function! RegInput(is_tail)
  if a:is_tail
    return ')'
  endif
  let tag = @0 . '('
  return tag
endfunction

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
packadd! cfilter

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
  hi! link DiffNewFile Comment
  hi! link diffIndexLine Comment
  hi! link Delimiter Normal
  hi! link TSParameter Normal
  hi DiffAdded guibg=NONE
  hi DiffRemoved guibg=NONE
  hi ErrorMsg guibg=NONE
  hi Statement gui=NONE
  hi ModeMsg gui=NONE
  exe "hi DiffAdd gui=bold guibg=#" . g:base16_gui02
  exe "hi DiffDelete gui=NONE guibg=#" . g:base16_gui02
  exe "hi DiffText gui=bold guifg=#" .g:base16_gui0A . " guibg=#" . g:base16_gui02
  exe "hi DiffChange guibg=#" . g:base16_gui02
  exe "hi DiffFile guifg=#". g:base16_gui04
  exe "hi VertSplit guifg=#". g:base16_gui01 . " guibg=#" . g:base16_gui01
  exe "hi StatusLine guifg=#". g:base16_gui05 . " guibg=#" . g:base16_gui01
  exe "hi QuickfixLine guifg=#". g:base16_gui0A . " guibg=#" . g:base16_gui02
  " hi link CocListsLine QuickfixLine
	" hi! link FloatermBorder Comment
  hi! link jsonCommentError Comment
  hi! link CocHintSign Comment
  hi! link CocHoverRange Comment
endfunction

set background=dark
aug color_tomorrow
  au!
  au ColorScheme * call <SID>reset_color()
aug END

color base16-tomorrow-night

call s:reset_color()

set exrc

set guioptions=
set mouse=a

set hlsearch
set nowrap
set noshowmode

set listchars=tab:\|\ ,eol:¬

set autoindent
set smarttab
" set sw=4 ts=4
set timeoutlen=500

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
set tagcase=match
set lazyredraw
" set textwidth=120

set nofixeol
set formatoptions+=j " Delete comment character when joining commented lines
set viminfo^=!
set cpoptions+=>
set belloff=all
set updatetime=500
set gdefault
" set number
" set relativenumber
syntax sync minlines=200
set scrolloff=3

set diffopt+=vertical,algorithm:patience

" set foldnestmax=2
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" set foldcolumn=1
" set nofoldenable

" set cinoptions=:0,g0,(0,Ws,l1
" set statusline=%<%f\ %h%m%r\ %=\ %{'['.(&fenc!=''?&fenc:&enc).','.&ff.']'}\ %-14.(%l,%c%V%)\ %P
" set cursorline
" set wildignore=*.pyc,*.pyo,*.exe,*.DS_Store,._*,*.svn,*.git,*.o,*.dSYM,*.ccls-cache,
"     \*.vscode,tags,*.vs,*.pyproj,*.idea,*.clangd,*__pycache__,
"     \*.bin,*.rlib,*.rmeta


if has('nvim')
lua <<EOF
require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "query", "c", "cpp", "typescript", "javascript"},
  highlight = {
    enable = true,       -- false will disable the whole extension
    disable = { },       -- list of language that will be disabled
  },
} 
require 'colorizer'.setup {
  'css';
  'javascript';
  'vim';
}
EOF

  aug Term
    au!
    au TermLeave * setlocal scrolloff=3
    " au TermClose * silent call feedkeys('\<CR>')
    au TermOpen * setlocal statusline=%{b:term_title} | nnoremap <buffer> q a<CR>
    au BufEnter term://* startinsert
  aug END
end

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

func! s:python_super()
  let pattern = '^class [^(]*(\zs[^)]*\ze):'
  let lineno = search(pattern, 'bn')
  let content = getline(lineno)
  let m = matchstr(content, pattern)
  let sm = split(m, '\.')
  exe 'tag '.sm[len(sm)-1]
  return
endfunc

aug vimrc_filetype
  au!
  au Filetype go call s:filetype_go()
  au Filetype python call s:filetype_python()

  au FileType c,cpp,objc,objcpp command! A -buffer call s:a('e')
        \| command! AV -buffer call s:a('botright vertical split')

  au FileType git setlocal foldmethod=syntax
        \| nnoremap <buffer> coc 0w:exec "G checkout ".expand("<cWORD>")<CR>
        \| nnoremap <buffer> cdd 0w:exec "G branch -D ".expand("<cWORD>")<CR>
        \| nnoremap <buffer> q <c-w>q
        \| nmap <buffer> ]<space> ]/
        \| nmap <buffer> [<space> [/
  au FileType fugitive nnoremap <buffer> q <c-w>q
  au FileType gitcommit setlocal foldmethod=syntax nofoldenable

  au FileType rust setlocal iskeyword+=!

  au filetype markdown setlocal conceallevel=2
      \| nnoremap <silent><buffer> gN O<Esc>C- [ ] 
      \| nnoremap <silent><buffer> gn o<Esc>C- [ ] 
      \| nnoremap <silent><buffer> gd :<HOME>silent! <END>S/- [{ ,x}]/- [{x, }]/<CR>:nohl<CR>
      \| nnoremap <silent><buffer> <leader>q :q<CR>
  au FileType help wincmd L | nnoremap <buffer><silent> q :bd<CR>
  au FileType man silent wincmd T
  au FileType quickfix wincmd J | setlocal nonu norelativenumber
  au FileType leaderf setlocal nonumber foldcolumn=1
  au FileType vim,lua,c,cpp,typescript,javascript,json,yaml,fish setlocal expandtab ts=2 sw=2
  au FileType tex setlocal ts=2 sw=2
  au FileType make setlocal noexpandtab
  au FileType fzf tnoremap <silent><buffer> <Esc> <C-c>
        \| tnoremap <silent><buffer> <C-j> <C-n>
        \| tnoremap <silent><buffer> <C-k> <C-p>
        \| tnoremap <silent><buffer> <C-h> <BS>
        \| tnoremap <silent><buffer> <C-l> <C-c>
  au FileType c,cpp,objc,objcpp,cs,json,java,gomod,dot setlocal commentstring=//\ %s
  au FileType cmake,tmux,cfg setlocal commentstring=#\ %s
aug END

aug vimrc_misc
  au!
  au BufRead *
      \ if search('\M-*- C++ -*-', 'n', 1) | setlocal ft=cpp | endif
      \ | if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
  au BufRead *gl.vs,*gl.ps setlocal ft=glsl iskeyword=@,48-57,_,128-167,224-235
  au BufRead .clang-format setlocal ft=yaml
  au BufRead,BufNewFile go.mod setlocal ft=gomod
  au BufRead,BufNewFile *.tmpl setlocal ft=gohtmltmpl
  au BufRead .localrc setlocal ft=vim
  au BufRead goscripts setlocal ft=go
  au BufRead *.mangle setlocal equalprg=c++filt
  au BufWritePre *.go OrganizeImport
  au BufWritePost *vimrc,*.vim so %
  au BufRead Cargo.toml call crates#toggle()
  " au WinEnter * if &diff | call<SID>stupid_diff() | endif
  " au FocusGained,CursorHold ?* if getcmdwintype() == '' | checktime | endif
aug END

" Save current view settings on a per-window, per-buffer basis.
function! s:auto_save_win_view()
  if !exists("w:SavedBufView")
    let w:SavedBufView = {}
  endif
  let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! s:auto_restore_win_view()
  let buf = bufnr("%")
  if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
    let v = winsaveview()
    let atStartOfFile = v.lnum == 1 && v.col == 0
    if atStartOfFile && !&diff
      call winrestview(w:SavedBufView[buf])
    endif
    unlet w:SavedBufView[buf]
  endif
endfunction

aug auto_save_view
  au!
  au BufLeave * call s:auto_save_win_view()
  au BufEnter * call s:auto_restore_win_view()
aug end

func! s:open_origin_file()
  let filename = @%
  exec "e ".substitute(filename, "fugitive.*\.git\/\/[a-f0-9]*\/", "", "")
endf

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
" endfunc

" func! s:stupid_diff()
"   if winheight(0) < (&lines - 13)
"     exe "resize " . (&lines - 13)
"   endif
"   nmap <buffer><silent> ]d :call <SID>goto_index("n")<CR>
"   nmap <buffer><silent> [d :call <SID>goto_index("p")<CR>
" endfunc

vnoremap <C-C> "+y
vnoremap <C-Insert> "+y
map <C-Q> "+gP
cmap <C-Q> <C-R>+
exe 'inoremap <script> <C-Q> <C-G>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <C-Q> ' . paste#paste_cmd['v']

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
endfunc

if has('gui_running')
  if has('win32')
    let g:prog_name = '!start gvim'
  elseif has('mac')
    let g:prog_name = 'silent !mvim'
  endif

  command! -nargs=0 -complete=command New execute g:prog_name
  command! -nargs=0 -complete=command Restart execute g:prog_name . " %" | quitall
endif

inoremap <C-^> <Esc><C-^>
inoremap <C-l> <C-o>zz
inoremap <C-k> <C-o>k
inoremap <C-j> <C-o>j

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  " tnoremap <C-^> <C-\><C-n>:FloatermToggle<CR>:
  " tnoremap <silent><C-z> <C-\><C-N>:FloatermToggle<CR>
  tnoremap <expr> <M-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  tnoremap [w <C-\><C-n>gT
  tnoremap ]w <C-\><C-n>gt
  tnoremap g<Tab> <C-\><C-n>g<Tab>
  tnoremap <silent><C-d> <C-\><C-n>:call <SID>end_terminal()<CR>
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

func! s:closetab()
  let l:lasttab = tabpagenr()
  exec "normal g\<tab>"
  exec "tabclose " . l:lasttab
endfunc
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

nnoremap <leader>et :tabe ~/Documents/notes/todo.md<CR>
nnoremap <leader>er :tabe ~/Documents/notes/reading.md<CR>
nnoremap <leader>en :tabe ~/Documents/notes<CR>:lcd %:h<CR>:pwd<CR>
nnoremap <leader>es :tabe $VIMFILES/bundle/vim-extra-snippets/UltiSnips<CR>:lcd %:h<CR>:pwd<CR>

nnoremap <leader>cd :lcd %:h<CR>:pwd<CR>
nnoremap <leader><space> za
nnoremap <silent><leader>z :call <SID>qfix_toggle()<CR>
nnoremap <silent><leader>co :execute "Copen \| copen 10 \| normal G"<CR>

" used to track the quickfix window
aug vimrc_qfix_toggle
  au!
  au BufWinEnter quickfix let g:qfix_win = bufnr("$")
  au BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
aug END

function! s:qfix_toggle()
  if exists("g:qfix_win")
    cclose
  else
    execute "Copen \| copen 10"
  endif
endfunction

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
    silent put!=message
  endif
endfunc
command! -nargs=+ -complete=command TabMessage call s:tab_message(<q-args>)

command! -nargs=0 OrganizeImport :silent call CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=0 Prettier :CocCommand prettier.formatFile

func! s:source_if_exists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunc

function! s:end_terminal() abort
  let col = col('.')
  if col == 1
    bd!
  else
    startinsert
    call feedkeys("\<C-d>", 'n')
  endif
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
    \ pumvisible() ? coc#_select_confirm() :
    \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()

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
  execute 'lcd -'
endfunction

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
endfunction

function! s:add_mappings() abort
  nnoremap <silent><buffer> [<C-Q> :cpfile <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  nnoremap <silent><buffer> ]<C-Q> :cnfile <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  nnoremap <silent><buffer> [q :cprevious <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  nnoremap <silent><buffer> ]q :cnext <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  copen 10
  wincmd p
endfunction

command! -bang -nargs=0 UE execute "normal o\<C-o>" . len(getline('.')). "i="
command! -bang -nargs=0 UM execute "normal o\<C-o>" . len(getline('.')). "i-"
command! -bang -nargs=0 Unescape call <SID>unescape()
command! -bang -nargs=0 Unstack setlocal efm-=%-G%.%# efm+=%f:%l | cbuffer

command! -nargs=? GitDiffBranch exec "Git difftool " . <q-args> | wincmd p | call s:diff_current_quickfix_entry()
command! -nargs=0 DiffQuickfix call s:diff_current_quickfix_entry()

command! -nargs=1 VagrantProvision exec "Dispatch! vagrant provision --provision-with " . <q-args>

func! s:command_abbr(args, abbreviation, expansion)
  execute 'cabbr ' . a:args . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunc
command! -nargs=* Cabbr call s:command_abbr("", <f-args>)
command! -nargs=* Cabbrb call s:command_abbr("<buffer>", <f-args>)

command! Only %bd|e#
command! Todo exec "Grep 'XFIXME'"


Cabbr sf CtrlSF
Cabbr gp Grep
Cabbr gpi Grep\ -i

Cabbr gdb GdbStartLLDB\ lldb

Cabbr Gfa Git\ fa\ --prune

Cabbr obs OpenBrowserSearch
Cabbr obg OpenBrowserSearch\ -go
Cabbr obg OpenBrowserSearch\ -cpp

Cabbr cl CocFzfList
Cabbr cc CocFzfList\ commands
Cabbr ca CocFzfList\ actions
Cabbr cr CocRestart

Cabbr gd GitDiffBranch
Cabbr gl GV\ -22
Cabbr glc GV!
Cabbr ge call\ <SID>open_origin_file()

Cabbr vp VagrantProvision

func! s:change_dir()
  if getcwd() != $HOME
    call s:source_if_exists(getcwd() . '/.vimrc')
  endif
endfunc

call s:source_if_exists($VIMFILES.'/.localrc')
call s:change_dir()

func s:filetype_python() 
  nmap <silent> <buffer> ]s :call <SID>python_super()<CR>
  nmap <silent> <buffer> [s <C-^>
  command! -buffer -nargs=0 -complete=command ImportRemove update | Execute autoflake --in-place --remove-all-unused-imports %<CR>
endf

func s:filetype_go() 
  Cabbrb ife GoIfErr
  Cabbrb gat GoAddTags
  Cabbrb grt GoRemoveTags
  Cabbrb gfs GoFillStruct
  Cabbrb gi GoImpl
  nnoremap <buffer><silent> gb :GoDocBrowser<CR>
  nnoremap <buffer><silent> ]] :<c-u>call go#textobj#FunctionJump('n', 'next')<cr>
  nnoremap <buffer><silent> [[ :<c-u>call go#textobj#FunctionJump('n', 'prev')<cr>
  onoremap <buffer><silent> ]] :<c-u>call go#textobj#FunctionJump('o', 'next')<cr>
  onoremap <buffer><silent> [[ :<c-u>call go#textobj#FunctionJump('o', 'prev')<cr>
  xnoremap <buffer><silent> ]] :<c-u>call go#textobj#FunctionJump('v', 'next')<cr>
  xnoremap <buffer><silent> [[ :<c-u>call go#textobj#FunctionJump('v', 'prev')<cr>
  command! -bang -buffer A call go#alternate#Switch(<bang>0, 'edit')
  command! -bang -buffer AV call go#alternate#Switch(<bang>0, 'vsplit')
  command! -bang -buffer AS call go#alternate#Switch(<bang>0, 'split')
  setlocal sw=4 ts=4
endf

