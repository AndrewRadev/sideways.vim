if &ft == 'eruby' || &ft == 'haml'
  " ERB and Haml evaluate the ruby filetype
  finish
endif

if !exists('b:sideways_skip_syntax') |
  let b:sideways_skip_syntax = [
        \ '^rubyString$',
        \ '^rubySymbol$',
        \ '^rubyComment$',
        \ '^rubyInterpolation$',
        \ ]
endif

if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
    \   {
    \     'start':       '|\s*',
    \     'end':         '\s*|',
    \     'single_line': 1,
    \     'delimiter':   ',\s*',
    \     'brackets':    ['([{''"', ')]}''"'],
    \   },
    \   {
    \     'start':       '\k\{1,}[?!]\= \ze\s*\%([^}=,*/%<>+-]\|->\)',
    \     'end':         '\s*\%(\<do\>\|#\)',
    \     'delimiter':   ',\s*',
    \     'brackets':    ['([{''"', ')]}''"'],
    \   },
    \ ]
