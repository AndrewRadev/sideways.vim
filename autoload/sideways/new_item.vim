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
