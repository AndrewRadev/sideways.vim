if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'start':     '\\left\[\s*',
      \     'end':       '\s*\\right\]',
      \     'delimiter': '\s*\%([+\-,<>]\|\\leq\|\\geq\)\s*',
      \     'brackets':  ['|[(','|])'],
      \   },
      \   {
      \     'start':     '\\left(\s*',
      \     'end':       '\s*\\right)',
      \     'delimiter': '\s*\%([+\-,<>]\|\\leq\|\\geq\)\s*',
      \     'brackets':  ['|[(','|])'],
      \   },
      \   {
      \     'start':     '\\left|\s*',
      \     'end':       '\s*\\right|',
      \     'delimiter': '\s*\%([+\-,<>]\|\\leq\|\\geq\)\s*',
      \     'brackets':  ['|[(','|])'],
      \   },
      \   {
      \     'start':     '\\(\s*',
      \     'end':       '\s*\\)',
      \     'delimiter': '\s*\%([=+\-,<>]\|\\leq\|\\geq\)\s*',
      \     'brackets':  ['|[(','|])'],
      \   },
      \   {
      \     'start':     '^\s*',
      \     'end':       '\s*\(\\\\\)\?\s*$',
      \     'delimiter': '\s*\%([&=+\-,<>]\|\\leq\|\\geq\)\s*',
      \     'brackets':  ['$|[(','$|])'],
      \   },
      \   {
      \     'start':     '\\\[\s*',
      \     'end':       '\s*\\\]',
      \     'delimiter': '\s*\%([+\-,<>]\|\\leq\|\\geq\)\s*',
      \     'brackets':  ['|[(','|])'],
      \   },
      \   {
      \     'start':     '(\s*',
      \     'end':       '\s*)',
      \     'delimiter': '\s*\%([+\-,<>]\|\\leq\|\\geq\)\s*',
      \     'brackets':  ['|[(','|])'],
      \   },
      \   {
      \     'start':     '\\{\s*',
      \     'end':       '\s*\\}',
      \     'delimiter': '\s*\%([+\-,<>]\|\\leq\|\\geq\)\s*',
      \     'brackets':  ['|[(','|])'],
      \   },
      \   {
      \     'start':     '\$\s*',
      \     'end':       '\s*\$',
      \     'delimiter': '\s*\%([=+\-,<>]\|\\leq\|\\geq\)\s*',
      \     'brackets':  ['|[(','|])'],
      \   },
      \ ]
