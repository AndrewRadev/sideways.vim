if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['typescriptObjectLabel', 'typescriptObjectLiteral'],
      \     'start':       '\k\+:\s*',
      \     'end':         '\s*;',
      \     'delimiter':   '\s*|',
      \     'brackets':    ['''"', '''"'],
      \   },
      \ ]
