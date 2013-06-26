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
      \     'start':     '\k:\s*',
      \     'end':       ';',
      \     'delimiter': '^\s',
      \     'skip':      '^\s',
      \     'brackets':  ['(''"', ')''"']
      \   },
      \   {
      \     'start':     '{\s*',
      \     'end':       ';\=\s*}',
      \     'delimiter': '^;\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['(''"', ')''"']
      \   },
      \   {
      \     'start':     '^\s*|',
      \     'end':       '|$',
      \     'delimiter': '^|',
      \     'skip':      '^$',
      \     'brackets':  ['(''"', ')''"']
      \   },
      \   {
      \     'start':     '\<if\s*',
      \     'end':       '^$',
      \     'delimiter': '^\s*\(and\|or\|||\|&&\)\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"']
      \   },
      \   {
      \     'start':     '\k\{1,} ',
      \     'end':       '^$',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"']
      \   },
      \ ]

command! SidewaysLeft  call sideways#Left(g:sideways_definitions)  | silent! call repeat#set(":SidewaysLeft\<cr>")
command! SidewaysRight call sideways#Right(g:sideways_definitions) | silent! call repeat#set(":SidewaysRight\<cr>")

let &cpo = s:keepcpo
unlet s:keepcpo
