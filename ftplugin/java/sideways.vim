if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'start':     '(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \   {
      \     'start':     '\S\zs<\ze\S',
      \     'end':       '>',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \ ]
