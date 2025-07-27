if !exists('b:sideways_skip_syntax') |
  let b:sideways_skip_syntax = [
        \ '^elixirString$',
        \ '^elixirAtom$',
        \ '^elixirComment$',
        \ '^elixirInterpolation$',
        \ ]
endif

if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
    \   {
    \     'start':       '\k\{1,}[?!]\= \ze\s*\%([^}=,*/<>+-]\|->\)',
    \     'end':         '\s*\%(\<do\>\?\|#\)',
    \     'delimiter':   ',\s*',
    \     'brackets':    ['([\%(%{\)''"', ')]}''"'],
    \   },
    \ ]
