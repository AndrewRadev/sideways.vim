function! sideways#Parse()
  if exists('b:sideways_definitions')
    let definitions = extend(copy(g:sideways_definitions), b:sideways_definitions)
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
    let new_cursor_column = first[0]
  else
    let first             = items[active_index]
    let second            = items[active_index + 1]
    let new_cursor_column = second[0] + s:Delta(second, first)
  endif

  call s:Swap(first, second, new_cursor_column)
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

  if active_index == 0
    let first             = items[active_index]
    let second            = items[last_index]
    let new_cursor_column = second[0]
  else
    let first             = items[active_index - 1]
    let second            = items[active_index]
    let new_cursor_column = first[0]
  endif

  let position = getpos('.')
  let position[2] = new_cursor_column
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

  if active_index == last_index
    let first             = items[0]
    let second            = items[last_index]
    let new_cursor_column = first[0]
  else
    let first             = items[active_index]
    let second            = items[active_index + 1]
    let new_cursor_column = second[0]
  endif

  let position = getpos('.')
  let position[2] = new_cursor_column
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

  if current_index == 0
    let previous = []
  else
    let previous = items[current_index - 1]
  endif

  if current_index == len(items) - 1
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
function! s:Swap(first, second, new_cursor_column)
  let [first_start, first_end]   = a:first
  let [second_start, second_end] = a:second

  let first_body  = sideways#util#GetCols(first_start, first_end)
  let second_body = sideways#util#GetCols(second_start, second_end)

  let position = getpos('.')

  call sideways#util#ReplaceCols(second_start, second_end, first_body)
  call sideways#util#ReplaceCols(first_start, first_end, second_body)

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
    let [start, end] = item

    if start <= column && column <= end
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
  return (a:first[1] - a:first[0]) - (a:second[1] - a:second[0])
endfunction
