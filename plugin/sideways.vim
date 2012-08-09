if exists("g:loaded_sideways") || &cp
  finish
endif

let g:loaded_sideways = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

command! SidewaysLeft  call sideways#Left()
command! SidewaysRight call sideways#Right()

let &cpo = s:keepcpo
unlet s:keepcpo
