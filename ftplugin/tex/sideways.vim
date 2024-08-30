if exists('b:sideways_definitions')
  finish
endif

" The default {} definition gets in the way of \command{}{} and \command[]{}
" and the others should not be useful in LaTeX:
let b:sideways_ignore_global_definitions = 1

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
      \   {
      \     'start':     '\\\k\+{',
      \     'end':       '}$',
      \     'delimiter': '}{',
      \     'brackets':  ['{[','}]'],
      \   },
      \   {
      \     'start':     '\\\k\+[',
      \     'end':       '}$',
      \     'delimiter': ']{',
      \     'brackets':  ['{[','}]'],
      \   },
      \ ]
