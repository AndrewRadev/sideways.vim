if exists("g:loaded_sideways") || &cp
  finish
endif

let g:loaded_sideways = '0.3.0' " version number
let s:keepcpo = &cpo
set cpo&vim

let g:sideways_definitions =
      \ [
      \   {
      \     'start':     '(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{''"', ')]}''"'],
      \   },
      \   {
      \     'start':     '\[\_s*',
      \     'end':       '\]',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{''"', ')]}''"'],
      \   },
      \   {
      \     'start':     '{\_s*',
      \     'end':       '}',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{''"', ')]}''"'],
      \   },
      \ ]

autocmd FileType ruby let b:sideways_definitions = [
      \   {
      \     'start':     '|\s*',
      \     'end':       '\s*|',
      \     'delimiter': ',\s*',
      \     'brackets':  ['([{''"', ')]}''"'],
      \   },
      \   {
      \     'skip_syntax': ['rubyString', 'rubySymbol', 'rubyComment', 'rubyInterpolation'],
      \     'start':       '\k\{1,}[?!]\= \ze\s*[^=,*/%<>+-]',
      \     'end':         '\s*\%(\<do\>\|#\)',
      \     'delimiter':   ',\s*',
      \     'brackets':    ['([{''"', ')]}''"'],
      \   },
      \ ]

autocmd FileType coffee let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['coffeeString', 'coffeeComment'],
      \     'start':       '\k\{1,} ',
      \     'end':         '\%(,\s*[-=]>\|\s*#\|$\)',
      \     'delimiter':   ',\s*',
      \     'brackets':    ['([''"', ')]''"'],
      \   },
      \ ]

autocmd FileType haml,slim let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['rubyString'],
      \     'start':       '\k\{1,} ',
      \     'end':         '\s*\%(\<do\>\|#\|$\)',
      \     'delimiter':   ',\s*',
      \     'brackets':    ['([''"', ')]''"'],
      \   },
      \   {
      \     'start':     '^[^.]*\.',
      \     'end':       '\%(\k\|\.\)\@!',
      \     'delimiter': '\.',
      \     'brackets':  ['', ''],
      \   },
      \ ]

autocmd FileType html let b:sideways_definitions = [
      \   {
      \     'start':                   '<\k\+\_s\+',
      \     'end':                     '\s*/\?>',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['"''', '"'''],
      \   },
      \ ]

autocmd FileType eruby let b:sideways_definitions = [
      \   {
      \     'start':     '<%=\=\s*\%(\k\|\.\|::\)*\k\{1,} ',
      \     'end':       '\s*%>',
      \     'delimiter': ',\s*',
      \     'brackets':  ['([''"', ')]''"'],
      \   },
      \   {
      \     'start':                   '<\k\+\_s\+',
      \     'end':                     '\s*/\?>',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['"''<', '"''>'],
      \   },
      \ ]

autocmd FileType handlebars,html.handlebars let b:sideways_definitions = [
      \   {
      \     'start':                   '{{#\=\%(\k\|-\|/\)\+\s*',
      \     'end':                     '\_s*}}',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['(''"', ')''"'],
      \   },
      \   {
      \     'start':                   '<\k\+\_s\+',
      \     'end':                     '\s*/\?>',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['"''{', '"''}'],
      \   },
      \ ]

autocmd FileType javascript.jsx let b:sideways_definitions = [
      \   {
      \     'start':                   '<\k\+\_s\+',
      \     'end':                     '\s*/\?>',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['"''{', '"''}'],
      \   },
      \ ]

autocmd FileType rust let b:sideways_definitions = [
      \   {
      \     'start':     '\<[A-Z]\k\+<',
      \     'end':       '>',
      \     'delimiter': ',\s*',
      \     'brackets':  ['<([', '>)]'],
      \     'single_line': 1,
      \   },
      \   {
      \     'start':     '::<',
      \     'end':       '>',
      \     'delimiter': ',\s*',
      \     'brackets':  ['<([', '>)]'],
      \     'single_line': 1,
      \   },
      \   {
      \     'start':     ')\_s*->\_s*',
      \     'end':       '\_s*{',
      \     'delimiter': 'NO_DELIMITER_SIDEWAYS_CARES_ABOUT',
      \     'brackets':  ['<([', '>)]'],
      \   },
      \ ]

autocmd FileType go let b:sideways_definitions = [
      \   {
      \     'start':     '{\_s*',
      \     'end':       '\_s*}',
      \     'delimiter': ',\s*',
      \     'brackets':  ['([''"', ')]''"'],
      \   },
      \ ]

autocmd FileType cpp let b:sideways_definitions = [
      \   {
      \     'start':     '(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \   {
      \     'start':     '\[\_s*',
      \     'end':       '\]',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \   {
      \     'start':     '{\_s*',
      \     'end':       '}',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \   {
      \     'start':     'template \zs<\ze\|\S\zs<\ze\S',
      \     'end':       '>',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \ ]

autocmd FileType css,scss,less let b:sideways_definitions = [
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

autocmd FileType cucumber let b:sideways_definitions = [
      \   {
      \     'start':     '^\s*|\s*',
      \     'end':       '\s*|$',
      \     'delimiter': '\s*|\s*',
      \     'brackets':  ['(''"', ')''"'],
      \   },
      \ ]

autocmd FileType sh let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['shDoubleQuote', 'shSingleQuote', 'shComment'],
      \     'start':       '\%(^\|[|(`]\)\s*\k\{1,} \ze\s*[^=]',
      \     'end':         '\s*\%(|\|\_$\)',
      \     'brackets':    ['([{''"', ')]}''"'],
      \     'single_line': 1,
      \     'delimited_by_whitespace': 1,
      \   },
      \ ]

command! SidewaysLeft  call sideways#MoveLeft()  | silent! call repeat#set("\<Plug>SidewaysLeft")
command! SidewaysRight call sideways#MoveRight() | silent! call repeat#set("\<Plug>SidewaysRight")

command! SidewaysJumpLeft  call sideways#JumpLeft()
command! SidewaysJumpRight call sideways#JumpRight()

nnoremap <silent> <Plug>SidewaysLeft :<c-u>SidewaysLeft<cr>
nnoremap <silent> <Plug>SidewaysRight :<c-u>SidewaysRight<cr>

onoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a')<cr>
xnoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a')<cr>
onoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i')<cr>
xnoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i')<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
