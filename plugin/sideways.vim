if exists("g:loaded_sideways") || &cp
  finish
endif

let g:loaded_sideways = '0.0.2' " version number
let s:keepcpo = &cpo
set cpo&vim

let g:sideways_definitions =
      \ [
      \   {
      \     'start':     '(\s*',
      \     'end':       '\s*)',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"']
      \   },
      \   {
      \     'start':     '\[\s*',
      \     'end':       '\s*\]',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"']
      \   },
      \   {
      \     'start':     '{\s*',
      \     'end':       ';\=\s*}',
      \     'delimiter': '^;\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['(''"', ')''"']
      \   },
      \   {
      \     'start':     '\<if\s*',
      \     'end':       '^$',
      \     'delimiter': '^\s*\(and\|or\|||\|&&\)\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"']
      \   },
      \ ]

autocmd FileType ruby let b:sideways_definitions = [
      \   {
      \     'start':     '\k\{1,} ',
      \     'end':       '$',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"']
      \   },
      \ ]

autocmd FileType eruby let b:sideways_definitions = [
      \   {
      \     'start':     '\k\{1,} ',
      \     'end':       '\s*%>',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"']
      \   },
      \ ]

autocmd FileType css,scss,less let b:sideways_definitions = [
      \   {
      \     'start':     '\k:\s*',
      \     'end':       ';',
      \     'delimiter': '^\s',
      \     'skip':      '^\s',
      \     'brackets':  ['(''"', ')''"']
      \   },
      \ ]

autocmd FileType cucumber let b:sideways_definitions = [
      \   {
      \     'start':     '^\s*|',
      \     'end':       '|$',
      \     'delimiter': '^|',
      \     'skip':      '^$',
      \     'brackets':  ['(''"', ')''"']
      \   },
      \ ]

command! SidewaysLeft  call sideways#Left(sideways#Definitions())  | silent! call repeat#set(":SidewaysLeft\<cr>")
command! SidewaysRight call sideways#Right(sideways#Definitions()) | silent! call repeat#set(":SidewaysRight\<cr>")

onoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a')<cr>
xnoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a')<cr>
onoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i')<cr>
xnoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i')<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
