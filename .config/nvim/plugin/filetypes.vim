aug vimrc_term
  au!
  au TermLeave * setlocal scrolloff=3
  au TermOpen * setlocal norelativenumber nonumber statusline=%{b:term_title} | startinsert | nnoremap <buffer> q a<CR>
aug END

func! s:filetype_dirvish()
  " silent keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d
  nnoremap <buffer> gs :sort ,^.*[\/],<CR>:set conceallevel=3<CR>
  nnoremap <buffer><silent> gh :keeppatterns g@\v[\\/]\.[^\/]+[\\/]?$@d<CR>:set conceallevel=3<CR>
  nnoremap <buffer> ; :Shdo! {}<Left><Left><Left>
  if has('win32')
    nnoremap <buffer><silent> gox :SExec start <C-R><C-L><CR>
  else
    nnoremap <buffer><silent> gox :SExec open <C-R><C-L><CR>
  endif
endfun

aug vimrc_filetype
  au!
  au FileType dirvish call s:filetype_dirvish()
  au Filetype go call s:filetype_go()
  au FileType rust call s:filetype_rust()
  au FileType c,cpp,objc,objcpp call s:filetype_cfamily()
  au FileType markdown call s:filetype_markdown()
  au FileType startify nnoremap <silent> <buffer> - :e .<CR>

  au FileType git setlocal foldmethod=syntax
    \| nnoremap <buffer> coc 0w:exec "G checkout ".expand("<cWORD>")<CR>
    \| nnoremap <buffer> cdd 0w:exec "G branch -D ".expand("<cWORD>")<CR>
    \| nnoremap <buffer> q <c-w>q
    \| nmap <buffer> ]<space> ]/
    \| nmap <buffer> [<space> [/
  au FileType fugitiveblame,fugitive nnoremap <buffer> q <c-w>q
  au FileType fugitive nnoremap <buffer> cn :G commit --no-verify<CR>
    \| nnoremap <buffer> gp :Git push<CR>
  au FileType gitcommit setlocal foldmethod=syntax nofoldenable

  au FileType dot,gradle,java,kotlin,xml,sh,zsh,bash,dart,vim,html,typescriptreact,typescript,javascriptreact,javascript,css,scss,json,jsonc,yaml,fish,lua,svelte setlocal expandtab ts=2 sw=2
  au FileType tex setlocal ts=2 sw=2
  au FileType template setlocal expandtab ts=4 sw=4
  au FileType make setlocal noexpandtab
  au FileType cs,jsonc,java,gomod,dot setlocal commentstring=//\ %s
  au FileType cmake,tmux,cfg setlocal commentstring=#\ %s
  au FileType scss setlocal iskeyword+=@-@
aug END

aug vimrc_misc
  au!
  au BufRead * if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") | exec "normal g`\"" | endif
  au SwapExists * let v:swapchoice = "e"
  au TextChanged,InsertLeave * execute 'normal! mI'
aug END

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
  Cabbrb gi GoImpl 
  nnoremap <buffer><silent> s; :<c-u>call <SID>toggle_words(' := ',' = ')<CR>
  nnoremap <buffer><silent> <leader>= :noau update<cr>:SExec go fmt %<cr>:e %<cr>
  setlocal sw=4 ts=4
endf

func! s:filetype_rust()
  func! s:toggle_ending()
    let cline = getline(".")
    if stridx(cline, ";") > 0
      s/;$//
    else
      s/;\@<!$/;/
    end
  endf

  nnoremap <buffer><silent> s; mz:<c-u>call <SID>toggle_ending()<CR>`z
  nnoremap <buffer><silent> sm :<c-u>call <SID>toggle_words('let mut', 'let')<CR>
  nnoremap <buffer><silent> s7 :<c-u>call <SID>toggle_words('&mut ', '&')<CR>
  nnoremap <buffer><silent> s/ :<c-u>call <SID>toggle_words('{}', '{:?}')<CR>
endf

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

func! s:filetype_cfamily()
  setlocal expandtab ts=2 sw=2
  setlocal commentstring=//\ %s
  command! -buffer -nargs=0 A call s:alternate('e')
  command! -buffer -nargs=0 AV call s:alternate('botright vertical split')
endf

func! s:filetype_markdown()
  setlocal ts=4 sw=4
  let b:delimitMate_expand_space = 0
  nnoremap <buffer><silent> o <END>a<CR>
  nnoremap <buffer><silent> gN O<Esc>C- [ ] 
  nnoremap <buffer><silent> gn o<Esc>C- [ ] 
  nnoremap <buffer><silent> gd mz:silent! S/- [{ ,x}]/- [{x, }]/<CR>:nohl<CR>`z
  nnoremap <buffer><silent> <leader>q :q<CR>
endf
