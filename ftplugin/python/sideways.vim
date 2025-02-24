if exists('b:sideways_definitions')
  finish
endif

let s:stopline_pattern = '^\s*\(def\|class\)\s\+\k\+('

let b:sideways_definitions = [
      \   {
      \     'start':            '^\%(from .*\)\=import ',
      \     'end':              '$',
      \     'delimiter':        ',\s*',
      \     'brackets':         ['', ''],
      \     'stopline_pattern': s:stopline_pattern,
      \   },
      \   {
      \     'start':            '\<for ',
      \     'end':              ' in\>',
      \     'delimiter':        ',\s*',
      \     'brackets':         ['([{''"', ')]}''"'],
      \     'stopline_pattern': s:stopline_pattern,
      \   },
      \   {
      \     'start':            '\<return ',
      \     'end':              '$',
      \     'delimiter':        ',\s*',
      \     'brackets':         ['([{''"', ')]}''"'],
      \     'stopline_pattern': s:stopline_pattern,
      \   },
      \ ]
