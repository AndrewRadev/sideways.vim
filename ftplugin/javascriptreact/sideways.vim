if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
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
