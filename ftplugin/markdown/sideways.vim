if exists('b:sideways_definitions')
  finish
endif

" TODO (2021-03-17) Change brackets, test: [Link](link)

let b:sideways_definitions = [
      \   {
      \     'start':     '^\s*|\s*',
      \     'end':       '\s*|$',
      \     'delimiter': '\s*|\s*',
      \     'brackets':  ['(''"', ')''"'],
      \   },
      \ ]
