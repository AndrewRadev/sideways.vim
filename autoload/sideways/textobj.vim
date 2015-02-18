function! sideways#textobj#Argument(mode)
  let coordinates = sideways#AroundCursor()
  if empty(coordinates)
    return
  endif

  let [previous, current, next] = coordinates

  if a:mode == 'i'
    call s:MarkCols(current[0], current[1])
  elseif a:mode == 'a'
    if !empty(previous)
      call s:MarkCols(previous[1] + 1, current[1])
    elseif !empty(next)
      call s:MarkCols(current[0], next[0] - 1)
    else
      call s:MarkCols(current[0], current[1])
    endif
  endif
endfunction

function! s:MarkCols(start_col, end_col)
  let line_offset = line2byte('.')
  let start_byte  = line_offset + a:start_col - 1
  let end_byte    = line_offset + a:end_col - 1

  if &selection == "exclusive"
    exe 'normal! '.start_byte.'gov'.(end_byte + 1).'go'
  else
    exe 'normal! '.start_byte.'gov'.end_byte.'go'
  endif

  return 1
endfunction
