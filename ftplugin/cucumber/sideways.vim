if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'start':     '^\s*|\s*',
      \     'end':       '\s*|$',
      \     'delimiter': '\s*|\s*',
      \     'brackets':  ['(''"', ')''"'],
      \   },
      \ ]
