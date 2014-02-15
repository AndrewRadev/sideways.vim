function! sideways#Parse()
  if exists('b:sideways_definitions')
    let definitions = extend(copy(g:sideways_definitions), b:sideways_definitions)
  else
    let definitions = g:sideways_definitions
  endif

  return sideways#parsing#Parse(definitions)
endfunction

function! sideways#MoveLeft()
  let movement = sideways#movement#New('left', sideways#Parse())
  if movement.IsBlank()
    return 0
  endif

  call movement.Swap()
  return 1
endfunction

function! sideways#MoveRight()
  let movement = sideways#movement#New('right', sideways#Parse())
  if movement.IsBlank()
    return 0
  endif

  call movement.Swap()
  return 1
endfunction

function! sideways#JumpLeft()
  let movement = sideways#movement#New('left', sideways#Parse())
  if movement.IsBlank()
    return 0
  endif

  call movement.Jump()
  return 1
endfunction

function! sideways#JumpRight()
  let movement = sideways#movement#New('right', sideways#Parse())
  if movement.IsBlank()
    return 0
  endif

  call movement.Jump()
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

  let first_index = sideways#FindActiveItem(items)
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

" Finds the item in the internal list of items where the cursor is currently
" positioned.
"
" Returns the index of the found item, or -1 if it's not found.
"
function! sideways#FindActiveItem(items)
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
