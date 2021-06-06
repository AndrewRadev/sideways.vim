if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'start':       '\k\+:\s*',
      \     'end':         '\s*;',
      \     'delimiter':   '\s*|',
      \     'brackets':    ['''"', '''"'],
      \   },
      \ ]
