if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'start':     '\k:\s*',
      \     'end':       ';',
      \     'delimiter': '\s',
      \     'brackets':  ['(''"', ')''"'],
      \   },
      \   {
      \     'start':     '{\_s*',
      \     'end':       ';\=\_s*}',
      \     'delimiter': ';\_s*',
      \     'brackets':  ['(''"', ')''"'],
      \   },
      \ ]
