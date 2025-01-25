if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   {
      \     'start':     'set\s\+\k\+[+^-]\==',
      \     'end':       '$',
      \     'delimiter': ',',
      \     'brackets':  ['', ''],
      \   },
      \ ]
