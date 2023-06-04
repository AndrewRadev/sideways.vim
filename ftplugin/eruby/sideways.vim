if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'start':     '<%=\=\s*\%(\k\|\.\|::\)*\k\{1,} ',
      \     'end':       '\s*%>',
      \     'delimiter': ',\s*',
      \     'brackets':  ['([''"', ')]''"'],
      \   },
      \   {
      \     'skip_syntax':             [],
      \     'start':                   '\%(\<class:\|:class\s*=>\)\s*[''"]',
      \     'end':                     '[''"]',
      \     'delimited_by_whitespace': 1,
      \     'single_line':             1,
      \     'brackets':                ['', ''],
      \   },
      \   sideways#html#Definition('tag_attributes',      { 'brackets': ['"''<', '"''>'] }),
      \   sideways#html#Definition('double_quoted_class', { 'brackets': ['<', '>'] }),
      \   sideways#html#Definition('single_quoted_class', { 'brackets': ['<', '>'] }),
      \   sideways#html#Definition('double_quoted_style', { 'brackets': ['<', '>'] }),
      \   sideways#html#Definition('single_quoted_style', { 'brackets': ['<', '>'] }),
      \ ]
