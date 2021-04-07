if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['rubyString'],
      \     'start':       '\k\{1,} ',
      \     'end':         '\s*\%(\<do\>\|#\|$\)',
      \     'delimiter':   ',\s*',
      \     'brackets':    ['([''"', ')]''"'],
      \   },
      \   {
      \     'start':       '^[^.]*\.',
      \     'end':         '\%(\k\|\.\)\@!',
      \     'single_line': 1,
      \     'delimiter':   '\.',
      \     'brackets':    ['', ''],
      \   },
      \ ]
