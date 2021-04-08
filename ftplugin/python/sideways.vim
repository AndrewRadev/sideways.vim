if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'start':     '^\%(from .*\)\=import ',
      \     'end':       '$',
      \     'delimiter': ',\s*',
      \     'brackets':  ['', ''],
      \   },
      \ ]
