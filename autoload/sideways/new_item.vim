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
    call sideways#util#SetPos(current.start_line, current.start_col)
    exe 'normal! i'.delimiter_string
    call sideways#util#SetPos(current.start_line, current.start_col)
    call feedkeys('i', 'n')
  elseif a:mode == 'a'
    call sideways#util#SetPos(current.end_line, current.end_col)
    exe 'normal! a'.delimiter_string
    call feedkeys('a', 'n')
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

  call sideways#util#SetPos(first_item.start_line, first_item.start_col)
  exe 'normal! i'.delimiter_string
  call sideways#util#SetPos(first_item.start_line, first_item.start_col)
  call feedkeys('i', 'n')
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

  call sideways#util#SetPos(last_item.end_line, last_item.end_col)
  exe 'normal! a'.delimiter_string
  call feedkeys('a', 'n')
endfunction
