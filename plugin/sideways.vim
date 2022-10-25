if exists("g:loaded_sideways") || &cp
  finish
endif

let g:loaded_sideways = '0.4.0' " version number
let s:keepcpo = &cpo
set cpo&vim

" Global definitions, active in all filetypes (local ones are in ftplugin):
if !exists('g:sideways_definitions')
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
endif

if !exists('g:sideways_search_timeout')
  let g:sideways_search_timeout = 0
endif

if !exists('g:sideways_skip_strings_and_comments')
  let g:sideways_skip_strings_and_comments = 1
endif

if !exists('g:sideways_add_item_cursor_restore')
  let g:sideways_add_item_cursor_restore = 0
endif

if !exists('g:sideways_add_item_repeat')
  let g:sideways_add_item_repeat = 1
endif

command! SidewaysLeft  call sideways#MoveLeft()  | silent! call repeat#set("\<Plug>SidewaysLeft")
command! SidewaysRight call sideways#MoveRight() | silent! call repeat#set("\<Plug>SidewaysRight")

command! SidewaysJumpLeft  call sideways#JumpLeft()
command! SidewaysJumpRight call sideways#JumpRight()

nnoremap <silent> <Plug>SidewaysLeft  :<c-u>SidewaysLeft<cr>
nnoremap <silent> <Plug>SidewaysRight :<c-u>SidewaysRight<cr>

onoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a')<cr>
xnoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a')<cr>
onoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i')<cr>
xnoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i')<cr>

nnoremap <Plug>SidewaysArgumentInsertBefore :<c-u>call sideways#new_item#Add('i')<cr>
nnoremap <Plug>SidewaysArgumentAppendAfter  :<c-u>call sideways#new_item#Add('a')<cr>
nnoremap <Plug>SidewaysArgumentInsertFirst  :<c-u>call sideways#new_item#AddFirst()<cr>
nnoremap <Plug>SidewaysArgumentAppendLast   :<c-u>call sideways#new_item#AddLast()<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
