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

autocmd FileType ruby,eruby let b:sideways_definitions = [
      \   {
      \     'start':     '\k\{1,} ',
      \     'end':       '^$',
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

command! SidewaysLeft  call sideways#Left(s:SidewaysDefinitions())  | silent! call repeat#set(":SidewaysLeft\<cr>")
command! SidewaysRight call sideways#Right(s:SidewaysDefinitions()) | silent! call repeat#set(":SidewaysRight\<cr>")

function! s:SidewaysDefinitions()
  if exists('b:sideways_definitions')
    return extend(copy(g:sideways_definitions), b:sideways_definitions)
  else
    return g:sideways_definitions
  endif
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
