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

function! sideways#JumpLeft(initial_position, count)
  let n     = a:count
  let items = sideways#Parse()

  call setpos('.', getpos(a:initial_position))

  for _ in range(n)
    let movement = sideways#movement#New('left', items)
    if movement.IsBlank()
      return 0
    endif

    call movement.Jump()
  endfor

  return 1
endfunction

function! sideways#JumpRight(initial_position, count)
  let n     = a:count
  let items = sideways#Parse()

  call setpos('.', getpos(a:initial_position))

  for _ in range(n)
    let movement = sideways#movement#New('right', items)
    if movement.IsBlank()
      return 0
    endif

    call movement.Jump()
  endfor

  return 1
endfunction

" This function locates a set of items around the cursor. The result looks
" like this:
"
"   [previous_item, current_item, next_item]
"
" The list of items doesn't loop:
"
"   - If the current item is first then the previous one is an empty list.
"   - If the current item is last then the next one is an empty list.
"
function! sideways#AroundCursor(items)
  let items = a:items
  if empty(items)
    return []
  end

  let active_index = sideways#FindActiveItem(items)
  if active_index < 0
    return 0
  endif

  let current = items[active_index]

  if active_index == 0
    let previous = []
  else
    let previous = items[active_index - 1]
  endif

  if active_index >= len(items) - 1
    let next = []
  else
    let next = items[active_index + 1]
  endif

  return [previous, current, next]
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
