if exists("g:loaded_sideways") || &cp
  finish
endif

let g:loaded_sideways = '0.0.1' " version number
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
      \ ]

command! SidewaysLeft  call sideways#Left(g:sideways_definitions)
command! SidewaysRight call sideways#Right(g:sideways_definitions)

let &cpo = s:keepcpo
unlet s:keepcpo
