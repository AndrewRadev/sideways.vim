function! sideways#new_item#Add(mode)
  let [definition, coordinates] = sideways#AroundCursor()
  if empty(coordinates)
    return
  endif

  if has_key(definition, 'delimited_by_whitespace')
    let delimiter_string = ' '
  else
    let delimiter_pattern = definition.delimiter
    let delimiter_string = substitute(delimiter_pattern, '\\_\=s\*\=', ' ', 'g')
  endif

  " coordinates have the form {start_line, start_col, end_line, end_col}
  let [_, current, _] = coordinates

  if a:mode == 'i'
    call s:InsertBefore(delimiter_string, current)
  elseif a:mode == 'a'
    call s:InsertAfter(delimiter_string, current)
  endif
endfunction

function! sideways#new_item#AddFirst()
  let [definition, items] = sideways#Parse()
  if empty(items)
    return
  endif

  if has_key(definition, 'delimited_by_whitespace')
    let delimiter_string = ' '
  else
    let delimiter_pattern = definition.delimiter
    let delimiter_string = substitute(delimiter_pattern, '\\_\=s\*\=', ' ', 'g')
  endif

  let first_item = items[0]
  call s:InsertBefore(delimiter_string, first_item)
endfunction

function! sideways#new_item#AddLast()
  let [definition, items] = sideways#Parse()
  if empty(items)
    return
  endif

  if has_key(definition, 'delimited_by_whitespace')
    let delimiter_string = ' '
  else
    let delimiter_pattern = definition.delimiter
    let delimiter_string = substitute(delimiter_pattern, '\\_\=s\*\=', ' ', 'g')
  endif

  let last_item = items[len(items) - 1]
  call s:InsertAfter(delimiter_string, last_item)
endfunction

function! s:InsertBefore(delimiter_string, item)
  let item = a:item
  let delimiter_string = a:delimiter_string

  call sideways#util#SetPos(item.start_line, item.start_col)
  exe 'normal! i'.delimiter_string
  call sideways#util#SetPos(item.start_line, item.start_col)
  call feedkeys('i', 'n')
endfunction

function! s:InsertAfter(delimiter_string, item)
  let item = a:item
  let delimiter_string = a:delimiter_string

  call sideways#util#SetPos(item.end_line, item.end_col)
  exe 'normal! a'.delimiter_string
  call feedkeys('a', 'n')
endfunction
