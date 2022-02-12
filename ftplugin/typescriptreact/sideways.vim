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
      \   sideways#html#Definition('tag_attributes', { 'brackets': ['"''{', '"''}'] }),
      \   {
      \     'skip_syntax':             [],
      \     'start':                   '\<className="',
      \     'end':                     '"',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['{', '}'],
      \   },
      \   {
      \     'skip_syntax':             [],
      \     'start':                   '\<className=''',
      \     'end':                     "'",
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['{', '}'],
      \   },
      \ ]
