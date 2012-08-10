" vim: foldmethod=marker

" Main {{{1

" function! sideways#Left() {{{2
"
" Move the current argument to the left
function! sideways#Left()
  let items = sideways#Parse()
  if empty(items)
    return 0
  end

  let last_index   = len(items) - 1
  let active_index = s:FindActiveItem(items)
  if active_index < 0
    return 0
  endif

  if active_index == 0
    let first             = items[active_index]
    let second            = items[last_index]
    let new_cursor_column = second[0] + s:Delta(second, first)
  else
    let first             = items[active_index - 1]
    let second            = items[active_index]
    let new_cursor_column = first[0]
  endif

  call s:Swap(first, second, new_cursor_column)
  return 1
endfunction

" function! sideways#Right() {{{2
"
" Move the current argument to the right
function! sideways#Right()
  let items = sideways#Parse()
  if empty(items)
    return 0
  end

  let last_index   = len(items) - 1
  let active_index = s:FindActiveItem(items)
  if active_index < 0
    return 0
  endif

  if active_index == last_index
    let first             = items[0]
    let second            = items[last_index]
    let new_cursor_column = first[0]
  else
    let first             = items[active_index]
    let second            = items[active_index + 1]
    let new_cursor_column = second[0] + s:Delta(second, first)
  endif

  call s:Swap(first, second, new_cursor_column)
  return 1
endfunction

" function! sideways#Parse() {{{2
"
" Extract column positions for "arguments" on the current line. Returns a list
" of pairs, each pair contains the start and end columns of the item
"
" Example:
"
" On the following line:
"
"   def function(one, two):
"
" The result would be:
"
"   [ [14, 16], [19, 21] ]
"
function! sideways#Parse()
  let definitions =
        \ [
        \   {
        \     'start':     '\k\+\zs(',
        \     'end':       '^)',
        \     'delimiter': '^,\s*',
        \     'skip':      '^\s',
        \   },
        \   {
        \     'start':     '[',
        \     'end':       '^]',
        \     'delimiter': '^,\s*',
        \     'skip':      '^\s',
        \   },
        \ ]

  let items = []

  for definition in definitions
    let start_pattern     = definition.start
    let end_pattern       = definition.end
    let delimiter_pattern = definition.delimiter
    let skip_pattern      = definition.skip

    normal! zR
    call sideways#PushCursor()

    if search(start_pattern, 'bW', line('.')) <= 0
      call sideways#PopCursor()
      continue
    endif

    normal! l

    let current_item = [col('.'), -1]

    " TODO (2012-08-10) bail out at EOL
    " TODO (2012-08-10) s:StackEmpty(stack)
    while s:RemainderOfLine() !~ end_pattern
      normal! l

      if s:RemainderOfLine() =~ delimiter_pattern
        let current_item[1] = col('.') - 1
        call add(items, current_item)

        normal! l
        while s:RemainderOfLine() =~ skip_pattern
          normal! l
        endwhile
        let current_item = [col('.'), -1]
      endif
    endwhile

    let current_item[1] = col('.') - 1
    call add(items, current_item)

    if !empty(items)
      call sideways#PopCursor()
      break
    endif

    call sideways#PopCursor()
  endfor

  return items
endfunction

" function! s:Swap(first, second, new_cursor_column) {{{2
"
" Swaps the a:first and a:second items in the buffer. Both first arguments are
" expected to be pairs of start and end columns. The last argument is a
" number, the new column to position the cursor on.
"
" In order to avoid having to consider eventual changes in column positions,
" a:first is expected to be positioned before a:second. Assuming that, the
" function first places the second item and then the first one, ensuring that
" the column number remain consistent until it's done.
function! s:Swap(first, second, new_cursor_column)
  let [first_start, first_end]   = a:first
  let [second_start, second_end] = a:second

  let first_body  = sideways#GetCols(first_start, first_end)
  let second_body = sideways#GetCols(second_start, second_end)

  let position = getpos('.')

  call sideways#ReplaceCols(second_start, second_end, first_body)
  call sideways#ReplaceCols(first_start, first_end, second_body)

  let position[2] = a:new_cursor_column
  call setpos('.', position)
endfunction

" function! s:FindActiveItem(items) {{{2
"
" Finds an item in the given list of column pairs, which the cursor is
" currently positioned in.
"
" Returns the index of the found item, or -1 if it's not found.
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

" function! s:Delta(first, second) {{{2
"
" Return the difference in length between the first start-end column pair and
" the second one.
"
" It is assumed that a:first is positioned before a:second. This is used to
" account for the column positions becoming inconsistent after replacing text
" in the current line.
function! s:Delta(first, second)
  return (a:first[1] - a:first[0]) - (a:second[1] - a:second[0])
endfunction

" Returns the remainder of the line from the current cursor position to the
" end.
function! s:RemainderOfLine()
  return strpart(getline('.'), col('.') - 1)
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

  call setreg('z', original_reg, original_reg_type)
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

" function! sideways#GetCols(start, end) {{{2
"
" Retrieve the text from columns "start" to "end" on the current line.
function! sideways#GetCols(start, end)
  return strpart(getline('.'), a:start - 1, a:end - a:start + 1)
endfunction
