function! sideways#Parse()
  let defined = {}
  let definitions = g:sideways_definitions

  if exists('g:sideways_custom_definitions')
    let definitions = s:ExtendDefinitions(g:sideways_custom_definitions, definitions)
  endif

  if exists('b:sideways_definitions')
    let definitions = s:ExtendDefinitions(b:sideways_definitions, definitions)
  endif

  if exists('b:sideways_custom_definitions')
    let definitions = s:ExtendDefinitions(b:sideways_custom_definitions, definitions)
  endif

  return sideways#parsing#Parse(definitions)
endfunction

function! sideways#MoveLeft()
  let [definition, items] = sideways#Parse()
  if empty(items)
    return 0
  end

  let last_index   = len(items) - 1
  let active_index = s:FindActiveItem(items)
  if active_index < 0
    return 0
  endif

  if active_index == 0
    let first            = items[active_index]
    let second           = items[last_index]
    let new_active_index = last_index
  else
    let first            = items[active_index - 1]
    let second           = items[active_index]
    let new_active_index = active_index - 1
  endif

  call s:Swap(first, second)
  call s:JumpToItem(items, 0)
  let [_, new_items] = sideways#parsing#Parse([definition])
  call s:JumpToItem(new_items, new_active_index)

  return 1
endfunction

function! sideways#MoveRight()
  let [definition, items] = sideways#Parse()
  if empty(items)
    return 0
  end

  let last_index   = len(items) - 1
  let active_index = s:FindActiveItem(items)
  if active_index < 0
    return 0
  endif

  if active_index == last_index
    let first = items[0]
    let second = items[last_index]
    let new_active_index = 0
  else
    let first = items[active_index]
    let second = items[active_index + 1]
    let new_active_index = active_index + 1
  endif

  call s:Swap(first, second)
  call s:JumpToItem(items, 0)
  let [_, new_items] = sideways#parsing#Parse([definition])
  call s:JumpToItem(new_items, new_active_index)

  return 1
endfunction

function! sideways#JumpLeft()
  let [_, items] = sideways#Parse()
  if empty(items)
    return 0
  end

  let last_index = len(items) - 1
  let active_index = s:FindActiveItem(items)
  if active_index < 0
    return 0
  endif

  if active_index == 0
    call s:JumpToItem(items, last_index)
  else
    call s:JumpToItem(items, active_index - 1)
  endif

  return 1
endfunction

function! sideways#JumpRight()
  let [_, items] = sideways#Parse()

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
    call s:JumpToItem(items, 0)
  else
    call s:JumpToItem(items, active_index + 1)
  endif

  return 1
endfunction

function! sideways#AroundCursor(parsed_items)
  let items = a:parsed_items
  if empty(items)
    return []
  end

  let current_index = s:FindActiveItem(items)
  let current       = items[current_index]

  if current_index <= 0
    let previous = {}
  else
    let previous = items[current_index - 1]
  endif

  if current_index >= len(items) - 1
    let next = {}
  else
    let next = items[current_index + 1]
  endif

  return [previous, current, next]
endfunction

function s:JumpToItem(items, index)
  let position = getpos('.')
  let position[1] = a:items[a:index].start_line
  let position[2] = a:items[a:index].start_col
  call setpos('.', position)
endfunction

" Swaps the a:first and a:second items in the buffer. Both first arguments are
" expected to be pairs of start and end columns. The last argument is a
" number, the new column to position the cursor on.
"
" In order to avoid having to consider eventual changes in column positions,
" a:first is expected to be positioned before a:second. Assuming that, the
" function first places the second item and then the first one, ensuring that
" the column number remain consistent until it's done.
function! s:Swap(first, second)
  let first_body  = sideways#util#GetItem(a:first)
  let second_body = sideways#util#GetItem(a:second)

  let position = getpos('.')

  call sideways#util#ReplaceItem(a:second, first_body)
  call sideways#util#ReplaceItem(a:first, second_body)

  call setpos('.', position)
endfunction

" Finds an item in the given list of column pairs, which the cursor is
" currently positioned in. Considers the space before an item a part of that
" item.
"
" Returns the index of the found item, or -1 if it's not found.
function! s:FindActiveItem(items)
  if len(a:items) == 0
    return -1
  endif

  let cursor_offset = line2byte(line('.')) + col('.') - 1
  let previous_offset = line2byte(a:items[0].start_line) + a:items[0].start_col - 1

  let index = 0
  for item in a:items
    let start_offset = previous_offset
    let end_offset   = line2byte(item.end_line)   + item.end_col   - 1

    if start_offset <= cursor_offset && cursor_offset <= end_offset
      return index
    endif

    let index += 1
    let previous_offset = end_offset
  endfor

  return -1
endfunction

" Merges a:source and a:extension definitions in that order, checking for
" duplicates based on start and end pattern.
"
" This means that patterns defined in a:source will take priority over
" a:extension.
"
function! s:ExtendDefinitions(source, extension)
  let defined = {}
  let result = []

  for d in a:source
    if has_key(defined, d.start . d.end)
      " we already have one for this start/end pair
    else
      let defined[d.start . d.end] = 1
      call add(result, d)
    endif
  endfor

  for d in a:extension
    if has_key(defined, d.start . d.end)
      " we already have one for this start/end pair
    else
      let defined[d.start . d.end] = 1
      call add(result, d)
    endif
  endfor

  return result
endfunction
