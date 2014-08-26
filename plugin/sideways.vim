if exists("g:loaded_sideways") || &cp
  finish
endif

let g:loaded_sideways = '0.1.0' " version number
let s:keepcpo = &cpo
set cpo&vim

let g:sideways_definitions =
      \ [
      \   {
      \     'start':     '(\s*',
      \     'end':       '\s*)',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([{''"', ')]}''"'],
      \   },
      \   {
      \     'start':     '\[\s*',
      \     'end':       '\s*\]',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"'],
      \   },
      \   {
      \     'start':     '{\s*',
      \     'end':       '\s*}',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([{''"', ')]}''"'],
      \   },
      \   {
      \     'start':     '\<if\s*',
      \     'end':       '^$',
      \     'delimiter': '^\s*\(and\|or\|||\|&&\)\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"'],
      \   },
      \ ]

autocmd FileType ruby let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['rubyString', 'rubyComment'],
      \     'start':       '\k\{1,}[?!]\= ',
      \     'end':         '\s*\%(\<do\>\|#\|$\)',
      \     'delimiter':   '^,\s*',
      \     'skip':        '^\s',
      \     'brackets':    ['([{''"', ')]}''"'],
      \   },
      \ ]

autocmd FileType coffee let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['coffeeString', 'coffeeComment'],
      \     'start':       '\k\{1,} ',
      \     'end':         '\%(,\s*[-=]>\|\s*#\|$\)',
      \     'delimiter':   '^,\s*',
      \     'skip':        '^\s',
      \     'brackets':    ['([''"', ')]''"'],
      \   },
      \ ]

autocmd FileType haml let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['rubyString'],
      \     'start':       '\k\{1,} ',
      \     'end':         '$',
      \     'delimiter':   '^,\s*',
      \     'skip':        '^\s',
      \     'brackets':    ['([''"', ')]''"'],
      \   },
      \   {
      \     'start':     '^[^.]*\.',
      \     'end':       '\%(\k\|\.\)\@!',
      \     'delimiter': '^\.',
      \     'skip':      '',
      \     'brackets':  ['', ''],
      \   },
      \ ]

autocmd FileType eruby let b:sideways_definitions = [
      \   {
      \     'start':     '\k\{1,} ',
      \     'end':       '\s*%>',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"'],
      \   },
      \ ]

autocmd FileType html let b:sideways_definitions = [
      \   {
      \     'start':     '<\k\+\s\+',
      \     'end':       '\s*/\?>',
      \     'delimiter': '^\s\+',
      \     'skip':      '^\s',
      \     'brackets':  ['"', '"'],
      \   },
      \ ]

autocmd FileType go let b:sideways_definitions = [
      \   {
      \     'start':     '{\s*',
      \     'end':       '\s*}',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"'],
      \   },
      \ ]

autocmd FileType css,scss,less let b:sideways_definitions = [
      \   {
      \     'start':     '\k:\s*',
      \     'end':       ';',
      \     'delimiter': '^\s',
      \     'skip':      '^\s',
      \     'brackets':  ['(''"', ')''"'],
      \   },
      \   {
      \     'start':     '{\s*',
      \     'end':       ';\=\s*}',
      \     'delimiter': '^;\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['(''"', ')''"'],
      \   },
      \ ]

autocmd FileType cucumber let b:sideways_definitions = [
      \   {
      \     'start':     '^\s*|',
      \     'end':       '|$',
      \     'delimiter': '^|',
      \     'skip':      '^$',
      \     'brackets':  ['(''"', ')''"'],
      \   },
      \ ]

command! SidewaysLeft  call sideways#MoveLeft()  | silent! call repeat#set(":SidewaysLeft\<cr>")
command! SidewaysRight call sideways#MoveRight() | silent! call repeat#set(":SidewaysRight\<cr>")

command! SidewaysJumpLeft  call sideways#JumpLeft()
command! SidewaysJumpRight call sideways#JumpRight()

onoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a')<cr>
xnoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a')<cr>
onoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i')<cr>
xnoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i')<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
