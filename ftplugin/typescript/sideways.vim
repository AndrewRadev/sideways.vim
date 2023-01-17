if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['typescriptObjectLabel', 'typescriptObjectLiteral', 'typescriptCall'],
      \     'start':       '^\s*\k\+:\s*',
      \     'end':         '\s*;',
      \     'delimiter':   '\s*|',
      \     'brackets':    ['''"', '''"'],
      \   },
      \   {
      \     'start':     '(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{''"<', ')]}''">'],
      \   },
      \ ]
