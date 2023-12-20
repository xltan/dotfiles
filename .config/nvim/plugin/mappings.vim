func! s:copen_hack(a)
  let g:dispatch_quickfix_height = 10
  exec "Copen | copen 10". a:a
  let g:dispatch_quickfix_height = 0
endf

func! s:qfix_toggle()
  if exists("g:qfix_win")
    unlet g:qfix_win
    cclose
  else
    call s:copen_hack('')
  endif
endf

func! s:move_to_char(str)
  let c = col('.')
  let s = getline('.')
  for i in split(a:str, '\zs')
    let p = stridx(s, i, c)
    if p != -1
      startinsert
      call cursor(line('.'), p+2)
      return 0
    endif
  endfor
  return -1
endf

func! s:omni_jump()
  let res = s:move_to_char('})''"|')
  if res != -1
    return
  endif

  if line('.') == line('$')
    normal o
  else
    normal j
    startinsert
    call cursor(line('.'), col('.')+1)
  end
endf

tnoremap <expr> <M-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
tnoremap [w <C-\><C-n>gT
tnoremap ]w <C-\><C-n>gt

nnoremap Q @q
xnoremap Q :normal @q<CR>
xnoremap . :normal! .<CR>

nnoremap gV `[v`]
vnoremap < <gv
vnoremap > >gv
vnoremap Y y`>p
vnoremap P "0p

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

nnoremap [w gT
nnoremap ]w gt
nnoremap [W :tabfirst<CR>
nnoremap ]W :tablast<CR>

nnoremap <C-w>t :tab sp<CR>

inoremap <C-^> <Esc><C-^>
inoremap <C-l> <C-o>zz
inoremap <C-k> <C-o>D
inoremap <silent><C-j> <Esc>:call <SID>omni_jump()<cr>

nnoremap <C-C> :let @+=@"<CR>
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y
nnoremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> :startinsert<cr><C-c>:update<cr>
inoremap <silent> <C-S> <Esc>:update<CR>
inoremap <silent><expr> <S-CR> "\<CR>\<C-u>"
nnoremap <silent><expr> <S-CR> "o\<C-u>"
inoremap <silent> ZZ <Esc>ZZ
nnoremap <silent> ZA :qa<CR>
nnoremap <silent> L :nohl<CR>

nnoremap <silent> <leader>cd :lcd %:h<CR>:pwd<CR>
nnoremap <silent> <leader>z :call <SID>qfix_toggle()<CR>
nnoremap <silent> <leader>a :A<CR>
nnoremap <silent> <leader>= :Format<CR>
