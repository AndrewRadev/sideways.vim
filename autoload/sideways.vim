function! sideways#Left()
  let items        = sideways#Parse()
  let last_index   = len(items) - 1
  let active_index = s:FindActiveItem(items)

  if active_index < 0
    return
  endif

  if active_index == 0
    let first      = items[active_index]
    let second     = items[last_index]
    let new_active = second
  else
    let first      = items[active_index - 1]
    let second     = items[active_index]
    let new_active = first
  endif

  let position = getpos('.')
  call s:Swap(first, second)
  let position[2] = new_active[0] + s:Delta(first, second)
  call setpos('.', position)
endfunction

function! sideways#Right()
  let items        = sideways#Parse()
  let last_index   = len(items) - 1
  let active_index = s:FindActiveItem(items)

  if active_index < 0
    return
  endif

  if active_index == last_index
    let first      = items[last_index]
    let second     = items[0]
    let new_active = first
  else
    let first      = items[active_index]
    let second     = items[active_index + 1]
    let new_active = second
  endif

  let position = getpos('.')
  call s:Swap(first, second)
  let position[2] = new_active[0] + s:Delta(first, second)
  call setpos('.', position)
endfunction

function! sideways#Parse()
  return [ [14, 16], [19, 21], [24, 28] ]
endfunction

function! s:Swap(first, second)
  let [first_start, first_end]   = a:first
  let [second_start, second_end] = a:second

  let first_body  = sideways#GetCols(first_start, first_end)
  let second_body = sideways#GetCols(second_start, second_end)

  call sideways#ReplaceCols(second_start, second_end, first_body)
  call sideways#ReplaceCols(first_start, first_end, second_body)
endfunction

function! s:FindActiveItem(items)
  let column = col('.')

  let index = 0
  for item in a:items
    let [start, end] = item

    if start <= column && column <= end
      return index
    endif

    let index += 1
  endfor

  return -1
endfunction

function! s:Delta(first, second)
  return abs((a:first[1] - a:first[0]) - (a:second[1] - a:second[0]))
endfunction

" Cursor stack manipulation {{{1
"
" In order to make the pattern of saving the cursor and restoring it
" afterwards easier, these functions implement a simple cursor stack. The
" basic usage is:
"
"   call sideways#PushCursor()
"   " Do stuff that move the cursor around
"   call sideways#PopCursor()

" function! sideways#PushCursor() {{{2
"
" Adds the current cursor position to the cursor stack.
function! sideways#PushCursor()
  if !exists('b:cursor_position_stack')
    let b:cursor_position_stack = []
  endif

  call add(b:cursor_position_stack, getpos('.'))
endfunction

" function! sideways#PopCursor() {{{2
"
" Restores the cursor to the latest position in the cursor stack, as added
" from the sideways#PushCursor function. Removes the position from the stack.
function! sideways#PopCursor()
  if !exists('b:cursor_position_stack')
    let b:cursor_position_stack = []
  endif

  call setpos('.', remove(b:cursor_position_stack, -1))
endfunction

" function! sideways#PeekCursor() {{{2
"
" Returns the last saved cursor position from the cursor stack.
" Note that if the cursor hasn't been saved at all, this will raise an error.
function! sideways#PeekCursor()
  return b:cursor_position_stack[-1]
endfunction

" Text replacement {{{1
"
" Vim doesn't seem to have a whole lot of functions to aid in text replacement
" within a buffer. The ":normal!" command usually works just fine, but it
" could be difficult to maintain sometimes. These functions encapsulate a few
" common patterns for this.

" function! sideways#ReplaceMotion(motion, text) {{{2
"
" Replace the normal mode "motion" with "text". This is mostly just a wrapper
" for a normal! command with a paste, but doesn't pollute any registers.
"
"   Examples:
"     call sideways#ReplaceMotion('Va{', 'some text')
"     call sideways#ReplaceMotion('V', 'replacement line')
"
" Note that the motion needs to include a visual mode key, like "V", "v" or
" "gv"
function! sideways#ReplaceMotion(motion, text)
  let original_reg      = getreg('z')
  let original_reg_type = getregtype('z')

  let @z = a:text
  exec 'normal! '.a:motion.'"zp'
  normal! gv=

  call setreg('z', original_reg, original_reg_type)
endfunction

" function! sideways#ReplaceLines(start, end, text) {{{2
"
" Replace the area defined by the 'start' and 'end' lines with 'text'.
function! sideways#ReplaceLines(start, end, text)
  let interval = a:end - a:start

  return sideways#ReplaceMotion(a:start.'GV'.interval.'j', a:text)
endfunction

" function! sideways#ReplaceCols(start, end, text) {{{2
"
" Replace the area defined by the 'start' and 'end' columns on the current
" line with 'text'
"
" TODO Multibyte characters break it
function! sideways#ReplaceCols(start, end, text)
  let start    = a:start - 1
  let interval = a:end - a:start

  if start > 0
    let motion = '0'.start.'lv'.interval.'l'
  else
    let motion = '0v'.interval.'l'
  endif

  return sideways#ReplaceMotion(motion, a:text)
endfunction

" function! sideways#ReplaceByPosition(start, end, text) {{{2
"
" Replace the area defined by the 'start' and 'end' positions with 'text'. The
" positions should be compatible with the results of getpos():
"
"   [bufnum, lnum, col, off]
"
function! sideways#ReplaceByPosition(start, end, text)
  call setpos('.', a:start)
  call setpos("'z", a:end)

  return sideways#ReplaceMotion('v`z', a:text)
endfunction

" Text retrieval {{{1
"
" These functions are similar to the text replacement functions, only retrieve
" the text instead.

" function! sideways#GetMotion(motion) {{{2
"
" Execute the normal mode motion "motion" and return the text it marks.
"
" Note that the motion needs to include a visual mode key, like "V", "v" or
" "gv"
function! sideways#GetMotion(motion)
  call sideways#PushCursor()

  let original_reg      = getreg('z')
  let original_reg_type = getregtype('z')

  exec 'normal! '.a:motion.'"zy'
  let text = @z

  call setreg('z', original_reg, original_reg_type)
  call sideways#PopCursor()

  return text
endfunction

" function! sideways#GetLines(start, end) {{{2
"
" Retrieve the lines from "start" to "end" and return them as a list. This is
" simply a wrapper for getbufline for the moment.
function! sideways#GetLines(start, end)
  return getbufline('%', a:start, a:end)
endfunction

" function! sideways#GetCols(start, end) {{{2
"
" Retrieve the text from columns "start" to "end" on the current line.
function! sideways#GetCols(start, end)
  return strpart(getline('.'), a:start - 1, a:end - a:start + 1)
endfunction

" function! sideways#GetByPosition(start, end) {{{2
"
" Fetch the area defined by the 'start' and 'end' positions. The positions
" should be compatible with the results of getpos():
"
"   [bufnum, lnum, col, off]
"
function! sideways#GetByPosition(start, end)
  call setpos('.', a:start)
  call setpos("'z", a:end)

  return sideways#GetMotion('v`z')
endfunction

