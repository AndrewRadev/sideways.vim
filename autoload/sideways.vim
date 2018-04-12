function! sideways#Parse()
  if exists('b:sideways_definitions')
    let definitions = extend(b:sideways_definitions, copy(g:sideways_definitions))
  else
    let definitions = g:sideways_definitions
  endif

  return sideways#parsing#Parse(definitions)
endfunction

function! sideways#MoveLeft()
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
    let first           = items[active_index]
    let second          = items[last_index]
    let new_cursor_line = second.start_line

    if first.start_line == second.start_line
      " same line, adjust for size
      let new_cursor_column = second.start_col + s:Delta(second, first)
    else
      let new_cursor_column = second.start_col
    endif
  else
    let first             = items[active_index - 1]
    let second            = items[active_index]
    let new_cursor_line   = first.start_line
    let new_cursor_column = first.start_col
  endif

  call s:Swap(first, second, new_cursor_line, new_cursor_column)
  return 1
endfunction

function! sideways#MoveRight()
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
    let new_cursor_line   = first.start_line
    let new_cursor_column = first.start_col
  else
    let first             = items[active_index]
    let second            = items[active_index + 1]
    let new_cursor_line   = second.start_line

    if first.start_line == second.start_line
      " same line, adjust for size
      let new_cursor_column = second.start_col + s:Delta(second, first)
    else
      let new_cursor_column = second.start_col
    endif
  endif

  call s:Swap(first, second, new_cursor_line, new_cursor_column)
  return 1
endfunction

function! sideways#JumpLeft()
  let items = sideways#Parse()
  if empty(items)
    return 0
  end

  let last_index   = len(items) - 1
  let active_index = s:FindActiveItem(items)
  if active_index < 0
    return 0
  endif

  let position = getpos('.')

  if active_index == 0
    let first       = items[active_index]
    let second      = items[last_index]
    let position[1] = second.start_line
    let position[2] = second.start_col
  else
    let first       = items[active_index - 1]
    let second      = items[active_index]
    let position[1] = first.start_line
    let position[2] = first.start_col
  endif

  call setpos('.', position)

  return 1
endfunction

function! sideways#JumpRight()
  let items = sideways#Parse()

  if empty(items)
    return 0
  end

  let last_index   = len(items) - 1
  let active_index = s:FindActiveItem(items)
  if active_index < 0
    return 0
  endif

  let position = getpos('.')

  if active_index == last_index
    let first       = items[0]
    let second      = items[last_index]
    let position[1] = first.start_line
    let position[2] = first.start_col
  else
    let first       = items[active_index]
    let second      = items[active_index + 1]
    let position[1] = second.start_line
    let position[2] = second.start_col
  endif

  call setpos('.', position)

  return 1
endfunction

function! sideways#AroundCursor()
  let items = sideways#Parse()
  if empty(items)
    return []
  end

  let current_index = s:FindActiveItem(items)
  let current       = items[current_index]

  if current_index <= 0
    let previous = []
  else
    let previous = items[current_index - 1]
  endif

  if current_index >= len(items) - 1
    let next = []
  else
    let next = items[current_index + 1]
  endif

  return [previous, current, next]
endfunction

" Swaps the a:first and a:second items in the buffer. Both first arguments are
" expected to be pairs of start and end columns. The last argument is a
" number, the new column to position the cursor on.
"
" In order to avoid having to consider eventual changes in column positions,
" a:first is expected to be positioned before a:second. Assuming that, the
" function first places the second item and then the first one, ensuring that
" the column number remain consistent until it's done.
function! s:Swap(first, second, new_cursor_line, new_cursor_column)
  let [first_line, first_start, first_end] =
        \ [a:first.start_line, a:first.start_col, a:first.end_col]
  let [second_line, second_start, second_end] =
        \ [a:second.start_line, a:second.start_col, a:second.end_col]

  let first_body  = sideways#util#GetCols(first_line, first_start, first_end)
  let second_body = sideways#util#GetCols(second_line, second_start, second_end)

  let position = getpos('.')

  call sideways#util#ReplaceCols(second_line, second_start, second_end, first_body)
  call sideways#util#ReplaceCols(first_line, first_start, first_end, second_body)

  let position[1] = a:new_cursor_line
  let position[2] = a:new_cursor_column
  call setpos('.', position)
endfunction

" Finds an item in the given list of column pairs, which the cursor is
" currently positioned in.
"
" Returns the index of the found item, or -1 if it's not found.
function! s:FindActiveItem(items)
  let column = col('.')

  let index = 0
  for item in a:items
    if item.start_line == line('.') && item.start_col <= column && column <= item.end_col
      return index
    endif

    let index += 1
  endfor

  return -1
endfunction

" Return the difference in length between the first start-end column pair and
" the second one.
"
" It is assumed that a:first is positioned before a:second. This is used to
" account for the column positions becoming inconsistent after replacing text
" in the current line.
function! s:Delta(first, second)
  return (a:first.end_col - a:first.start_col) - (a:second.end_col - a:second.start_col)
endfunction
