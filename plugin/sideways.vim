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
      \     'brackets':    ['([''"', ')]''"'],
      \   },
      \ ]

autocmd FileType coffee let b:sideways_definitions = [
      \   {
      \     'start':     '\k\{1,} ',
      \     'end':       '$',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"'],
      \   },
      \ ]

autocmd FileType haml let b:sideways_definitions = [
      \   {
      \     'start':     '\k\{1,} ',
      \     'end':       '$',
      \     'delimiter': '^,\s*',
      \     'skip':      '^\s',
      \     'brackets':  ['([''"', ')]''"'],
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

command! SidewaysJumpLeft  call sideways#JumpLeft(1)
command! SidewaysJumpRight call sideways#JumpRight(1)

nnoremap <Plug>SidewaysJumpLeft  :<c-u>call sideways#JumpLeft(".", v:count1)<cr>
onoremap <Plug>SidewaysJumpLeft  :<c-u>call sideways#JumpLeft(".", v:count1)<cr>
xnoremap <Plug>SidewaysJumpLeft  :<c-u>call sideways#JumpLeft("'>", v:count1)<cr>v`<o

nnoremap <Plug>SidewaysJumpRight :<c-u>call sideways#JumpRight(".", v:count1)<cr>
onoremap <Plug>SidewaysJumpRight :<c-u>call sideways#JumpRight(".", v:count1)<cr>
xnoremap <Plug>SidewaysJumpRight :<c-u>call sideways#JumpRight("'>", v:count1)<cr>v`<o

onoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a', v:count)<cr>
xnoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a', v:count)<cr>
onoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i', v:count)<cr>
xnoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i', v:count)<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
