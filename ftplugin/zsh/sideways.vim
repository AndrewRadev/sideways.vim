if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['zshString', 'zshComment'],
      \     'start':       '\%(^\|[|(`]\)\s*\k\{1,} \ze\s*[^=]',
      \     'end':         '\s*\%(|\|\_$\)',
      \     'brackets':    ['([{''"', ')]}''"'],
      \     'single_line': 1,
      \     'delimited_by_whitespace': 1,
      \   },
      \ ]
