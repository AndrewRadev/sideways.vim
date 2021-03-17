if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['coffeeString', 'coffeeComment'],
      \     'start':       '\k\{1,} ',
      \     'end':         '\%(,\s*[-=]>\|\s*#\|$\)',
      \     'delimiter':   ',\s*',
      \     'brackets':    ['([''"', ')]''"'],
      \   },
      \ ]
