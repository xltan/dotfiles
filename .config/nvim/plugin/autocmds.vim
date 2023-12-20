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

" Save current view settings on a per-window, per-buffer basis.
func! s:winview_autosave()
  if !exists("w:saved_view")
    let w:saved_view = {}
  endif
  let w:saved_view[bufnr("%")] = winsaveview()
endf

func! s:bufenter()
  call s:winview_autorest()
  if &buftype =~# 'prompt\|terminal'
    startinsert
  endif
endf

func! s:bufleave()
  call s:winview_autosave()
  if &buftype =~# 'prompt\|terminal'
    stopinsert
  endif
endf

func! s:bufwinenter()
  if &filetype ==# 'help'
    wincmd L
    vertical resize 80
    nnoremap <buffer><silent> q :bd<CR>
    setlocal nonu nornu
  elseif &filetype ==# 'man'
    silent wincmd T
    setlocal nonu nornu
  elseif &filetype ==# 'qf'
    wincmd J
    setlocal nonu nornu
    let g:qfix_win = bufnr("$")
    nnoremap <buffer><silent> q :cclose<CR>
  elseif &filetype ==# 'ctrlsf'
    setlocal nonu nornu
  endif
endf

aug vimrc_yank
  au!
  au TextYankPost * silent! lua vim.highlight.on_yank()
aug END

" used to track the quickfix window
aug vimrc_buffer
  au!
  au BufEnter * call s:bufenter()
  au BufLeave * call s:bufleave()
  au BufWinEnter * call s:bufwinenter()
aug END

