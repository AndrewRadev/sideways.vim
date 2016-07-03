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
    let new_cursor_line = second[0]

    if first[0] == second[0]
      " same line, adjust for size
      let new_cursor_column = second[1] + s:Delta(second, first)
    else
      let new_cursor_column = second[1]
    endif
  else
    let first             = items[active_index - 1]
    let second            = items[active_index]
    let new_cursor_line   = first[0]
    let new_cursor_column = first[1]
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
    let new_cursor_line   = first[0]
    let new_cursor_column = first[1]
  else
    let first             = items[active_index]
    let second            = items[active_index + 1]
    let new_cursor_line   = second[0]

    if first[0] == second[0]
      " same line, adjust for size
      let new_cursor_column = second[1] + s:Delta(second, first)
    else
      let new_cursor_column = second[1]
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
    let position[1] = second[0]
    let position[2] = second[1]
  else
    let first       = items[active_index - 1]
    let second      = items[active_index]
    let position[1] = first[0]
    let position[2] = first[1]
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
    let position[1] = first[0]
    let position[2] = first[1]
  else
    let first       = items[active_index]
    let second      = items[active_index + 1]
    let position[1] = second[0]
    let position[2] = second[1]
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
  let [first_line, first_start, first_end]   = a:first
  let [second_line, second_start, second_end] = a:second

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
    let [line, start, end] = item

    if line == line('.') && start <= column && column <= end
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
  return (a:first[2] - a:first[1]) - (a:second[2] - a:second[1])
endfunction
