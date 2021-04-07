if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'start':                   '{{#\=\%(\k\|-\|/\)\+\s*',
      \     'end':                     '\_s*}}',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['(''"', ')''"'],
      \   },
      \   sideways#html#Definition('tag_attributes',      { 'brackets': ['"''{', '"''}'] }),
      \   sideways#html#Definition('double_quoted_class', { 'brackets': ['{', '}'] }),
      \   sideways#html#Definition('single_quoted_class', { 'brackets': ['{', '}'] }),
      \   sideways#html#Definition('double_quoted_style', { 'brackets': ['<', '>'] }),
      \   sideways#html#Definition('single_quoted_style', { 'brackets': ['<', '>'] }),
      \ ]
