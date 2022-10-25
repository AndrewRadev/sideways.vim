if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'start':     '{\_s*',
      \     'end':       '\_s*}',
      \     'delimiter': ',\s*',
      \     'brackets':  ['([''"', ')]''"'],
      \   },
      \ ]
