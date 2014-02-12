function! sideways#Parse()
  if exists('b:sideways_definitions')
    let definitions = extend(copy(g:sideways_definitions), b:sideways_definitions)
  else
    let definitions = g:sideways_definitions
  endif

  return sideways#parsing#Parse(definitions)
endfunction

function! sideways#Left()
  let items = sideways#Parse()
  if empty(items)
    return []
  end

  let last_index   = len(items) - 1
  let active_index = s:FindActiveItem(items)
  if active_index < 0
    return []
  endif

  if active_index == 0
    let first             = items[active_index]
    let second            = items[last_index]
    let new_cursor_column = second[0]
    let wrap              = 1
  else
    let first             = items[active_index - 1]
    let second            = items[active_index]
    let new_cursor_column = first[0]
    let wrap              = 0
  endif

  return [first, second, new_cursor_column, wrap]
endfunction

function! sideways#Right()
  let items = sideways#Parse()
  if empty(items)
    return []
  end

  let last_index   = len(items) - 1
  let active_index = s:FindActiveItem(items)
  if active_index < 0
    return []
  endif

  if active_index == last_index
    let first             = items[0]
    let second            = items[last_index]
    let new_cursor_column = first[0]
    let wrap              = 1
  else
    let first             = items[active_index]
    let second            = items[active_index + 1]
    let new_cursor_column = second[0]
    let wrap              = 0
  endif

  return [first, second, new_cursor_column, wrap]
endfunction

function! sideways#MoveRight()
  let movement = sideways#Right()
  if empty(movement)
    return 0
  endif
  let [first, second, new_cursor_column, wrap] = movement

  if !wrap
    let new_cursor_column += s:Delta(second, first)
  endif

  call s:Swap(first, second, new_cursor_column)
  return 1
endfunction

function! sideways#MoveLeft()
  let movement = sideways#Left()
  if empty(movement)
    return 0
  endif
  let [first, second, new_cursor_column, wrap] = movement

  if !wrap
    let new_cursor_column += s:Delta(second, first)
  endif

  call s:Swap(first, second, new_cursor_column)
  return 1
endfunction

function! sideways#JumpLeft()
  let movement = sideways#Left()
  if empty(movement)
    return 0
  endif
  let [_f, _s, new_cursor_column, _w] = movement

  call sideways#util#SetCol(new_cursor_column)
  return 1
endfunction

function! sideways#JumpRight()
  let movement = sideways#Right()
  if empty(movement)
    return 0
  endif
  let [_f, _s, new_cursor_column, _w] = movement

  call sideways#util#SetCol(new_cursor_column)
  return 1
endfunction

" This function locates a set of items around the cursor. The result looks
" like this:
"
"   [previous_item, [cursor_item, ...], next_item]
"
" When given a {count: N}, it returns the item under the cursor and the next
" N - 1 items. The previous_item and next_item are the one that are before and
" after the set of "cursor" ones.
"
" The list of items doesn't loop. If N is larger than the number of items
" available going forward, it doesn't take them from the beginning.
"
function! sideways#AroundCursor(...)
  let options = get(a:000, 0, {})
  let n       = get(options, 'count', 1)

  let items = sideways#Parse()
  if empty(items)
    return []
  end

  let first_index = s:FindActiveItem(items)
  if first_index < 0
    return 0
  endif

  let last_index  = first_index
  let cursor_item = items[first_index]
  let selected    = [cursor_item]

  while n > 1
    let n -= 1
    let last_index += 1

    if last_index == len(items)
      break
    endif

    call add(selected, items[last_index])
  endwhile

  if first_index == 0
    let previous = []
  else
    let previous = items[first_index - 1]
  endif

  if last_index >= len(items) - 1
    let next = []
  else
    let next = items[last_index + 1]
  endif

  return [previous, selected, next]
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

  call sideways#util#ReplaceCols(second_start, second_end, first_body)
  call sideways#util#ReplaceCols(first_start, first_end, second_body)

  call sideways#util#SetCol(a:new_cursor_column)
endfunction

" Finds an item in the given list of column pairs, which the cursor is
" currently positioned in.
"
" Returns the index of the found item, or -1 if it's not found.
function! s:FindActiveItem(items)
  let column = col('.')

  if empty(a:items)
    return -1
  endif

  if column < a:items[0][0]
    " column is before the first item
    return - 1
  endif

  let index = 0
  for item in a:items
    let [start, end] = item

    if column <= end
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
"
" TODO (2014-02-12) Seems like faulty documentation, called as s:Delta(second,first)
"
function! s:Delta(first, second)
  return (a:first[1] - a:first[0]) - (a:second[1] - a:second[0])
endfunction
