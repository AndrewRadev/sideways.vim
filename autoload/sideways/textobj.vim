function! sideways#textobj#Argument(mode)
  let coordinates = sideways#AroundCursor()
  if empty(coordinates)
    return
  endif

  " coordinates have the form [line, start_col, end_col]
  let [previous, current, next] = coordinates

  if a:mode == 'i'
    call s:MarkCols([current[0], current[1]], [current[0], current[2]])
  elseif a:mode == 'a'
    if !empty(previous)
      if previous[0] < current[0]
        if !empty(next) && next[0] == current[0]
          " this is a new line with a next item on the same line, delete to
          " that next item instead
          call s:MarkCols([current[0], current[1]], [next[0], next[1] - 1])
        else
          " this is a new line with no next, delete till previous, remove
          " newline
          call s:MarkCols([previous[0], previous[2] + 1], [current[0], current[2]])
        endif
      else
        " there are other things on the line
        call s:MarkCols([previous[0], previous[2] + 1], [current[0], current[2]])
      endif
    elseif !empty(next)
      call s:MarkCols([current[0], current[1]], [next[0], next[1] - 1])
    else
      call s:MarkCols([current[0], current[1]], [current[0], current[2]])
    endif
  endif
endfunction

function! s:MarkCols(start_coords, end_coords)
  let start_byte  = line2byte(a:start_coords[0]) + a:start_coords[1] - 1
  let end_byte    = line2byte(a:end_coords[0]) + a:end_coords[1] - 1

  if &selection == "exclusive"
    exe 'normal! '.start_byte.'gov'.(end_byte + 1).'go'
  else
    exe 'normal! '.start_byte.'gov'.end_byte.'go'
  endif

  return 1
endfunction
