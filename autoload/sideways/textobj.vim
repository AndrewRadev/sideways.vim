function! sideways#textobj#Argument(mode)
  let coordinates = sideways#AroundCursor(sideways#Definitions())
  if empty(coordinates)
    return
  endif

  let [previous, current, next] = coordinates

  if a:mode == 'i'
    call s:MarkCols(current[0], current[1])
  elseif a:mode == 'a'
    if empty(next)
      call s:MarkCols(previous[1] + 1, current[1])
    else
      call s:MarkCols(current[0], next[0] - 1)
    endif
  endif
endfunction

function! s:MarkCols(start_col, end_col)
  let start = a:start_col - 1
  let end   = a:end_col - 1

  let interval = end - start

  if start == 0
    exe 'normal! 0v'.interval.'l'
  else
    exe 'normal! 0'.start.'lv'.interval.'l'
  endif
endfunction
