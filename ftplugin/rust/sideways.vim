if !exists('b:sideways_skip_syntax')
  let b:sideways_skip_syntax = [
        \     'String',
        \     'Comment',
        \     'rustCharacter',
        \   ]
endif

if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'start':       '|\s*',
      \     'end':         '\s*|',
      \     'delimiter':   ',\s*',
      \     'single_line': 1,
      \     'brackets':    ['<([', '>)]'],
      \   },
      \   {
      \     'start':     '\%(struct\|enum\) \k\+\%(<.\{-}>\)\=\s*{\_s*',
      \     'end':       '}',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([<', ')]>'],
      \   },
      \   {
      \     'start':     '\%(struct\|enum\) \k\+\%(<.\{-}>\)\=\s*(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([<', ')]>'],
      \   },
      \   {
      \     'start':     '\k\s*{\_s*',
      \     'end':       '}',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{''"|', ')]}''"|'],
      \   },
      \   {
      \     'start':     'type \k\+\s*=.*(',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([<', ')]>'],
      \   },
      \   {
      \     'start':     'fn \k\+\%(<.\{-}>\)\=(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([<', ')]>'],
      \   },
      \   {
      \     'start':     '(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{"|', ')]}"|'],
      \   },
      \   {
      \     'start':     '\[\_s*',
      \     'end':       '\]',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{"', ')]}"'],
      \   },
      \   {
      \     'start':     '\<\k\+<',
      \     'end':       '>',
      \     'delimiter': ',\s*',
      \     'brackets':  ['<([', '>)]'],
      \     'single_line': 1,
      \   },
      \   {
      \     'start':     '\k\+:\s*',
      \     'end':       '[,>]',
      \     'delimiter': '\s*+\s*',
      \     'brackets':  ['', ''],
      \     'single_line': 1,
      \   },
      \   {
      \     'start':     '::<',
      \     'end':       '>',
      \     'delimiter': ',\s*',
      \     'brackets':  ['<([', '>)]'],
      \     'single_line': 1,
      \   },
      \   {
      \     'start':     ')\_s*->\_s*',
      \     'end':       '\_s*{',
      \     'delimiter': 'NO_DELIMITER_SIDEWAYS_CARES_ABOUT',
      \     'brackets':  ['<([', '>)]'],
      \   },
      \ ]
