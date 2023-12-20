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
  endw

  while npos < len(line)
    if match(line[npos], pattern) == -1
      break
    endif
    let npos += 1
  endw
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

func! s:open_origin_file()
  let filename = @%
  exec "e ".substitute(filename, "fugitive.*\.git\/\/[a-f0-9]*\/", "", "")
endf

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

func! s:command_abbr(args, abbreviation, expansion)
  silent exec 'cabbr ' . a:args . a:abbreviation . ' <c-r>=(getcmdpos() == 1 \|\| getcmdline()=="''<,''>") && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endf

command! -nargs=+ SExec exec 'silent !'. <q-args> | redraw!
command! -nargs=+ Exec exec '!'. <q-args> | redraw!
command! -nargs=? Code exe "silent !code '" . getcwd() . "' --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
command! -nargs=0 Only %bd|e#
command! -nargs=* -complete=function Doc exec s:std_get_commands(<q-args>)
command! -nargs=* -complete=function Rs exec 'OpenBrowserSearch -rsd ' . s:get_args(<q-args>)
command! -nargs=+ -complete=command TabMessage call s:tab_message(<q-args>)
command! -nargs=* MS marks abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
command! -nargs=1 E exec 'edit '. <f-args> . ' | Mkdir!'
command! -nargs=* Cabbr call s:command_abbr("", <f-args>)
command! -nargs=* Cabbrb call s:command_abbr("<buffer>", <f-args>)
command! -nargs=0 Jenkins Dispatch! local/jenkins.sh


Cabbr nw noau\ write
Cabbr c Cargo
Cabbr code Code
Cabbr sf CtrlSF
Cabbr sr CtrlSF\ -R

Cabbr Gfa G\ fa
Cabbr Gp Dispatch!\ git\ push
Cabbr Gblame G\ blame
Cabbr Gmerge G\ merge
Cabbr Gbrowse GBrowse
Cabbr Gsw G\ sw
Cabbr Gsp G\ sp
Cabbr Gst G\ stash
Cabbr gl GV\ -50
Cabbr glc GV!
Cabbr ge call\ <SID>open_origin_file()

Cabbr ob OpenBrowserSmartSearch
Cabbr os OpenBrowserSearch
Cabbr oc OpenBrowserSearch\ -cpp
Cabbr of OpenBrowserSearch\ -stackoverflow
Cabbr og OpenBrowserSearch\ -github
Cabbr op OpenGithubProject

Cabbr t SlimeSend
Cabbr tt SlimeSend1

Cabbr lr LspRestart
Cabbr li LspInfo

Cabbr fl FzfLua
