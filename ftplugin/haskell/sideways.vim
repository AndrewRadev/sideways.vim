if exists('b:sideways_definitions')
  finish
endif

" \   {
" \     'start':       '\%(^\s*\|[=(]\s*\)\k\{1,} \ze\s*[^=,*/%<>+-]',
" \     'end':         '\s*\%(=\|--\)',
" \     'delimiter':   ' \+',
" \     'brackets':    ['([{"', ')]}"'],
" \   },

let b:sideways_definitions = [
      \   {
      \     'start':     '\k\+\s*::\s*',
      \     'end':       '\s*\%(--\|$\)',
      \     'delimiter': '\s*->\s*',
      \     'brackets':  ['([{"', ')]}"'],
      \   },
      \   {
      \     'start':     '\',
      \     'end':       '->',
      \     'delimiter': ' \+',
      \     'brackets':  ['', ''],
      \   },
      \   {
      \     'start':       '^\s*\k\{1,} \ze\s*[^=,*/%<>+-]',
      \     'end':         '\s*\%(=\|--\)',
      \     'brackets':    ['([{"', ')]}"'],
      \     'single_line': 1,
      \     'delimited_by_whitespace': 1,
      \   },
      \ ]
