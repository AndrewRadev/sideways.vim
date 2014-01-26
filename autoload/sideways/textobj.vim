function! sideways#textobj#Argument(mode, count)
  let coordinates = sideways#AroundCursor({'count': a:count})

  if empty(coordinates)
    return
  endif

  let [previous, selected, next] = coordinates
  let first_selected = selected[0]
  let last_selected  = selected[-1]

  if a:mode == 'i'
    let [from, to] = [ first_selected[0], last_selected[1] ]
  elseif a:mode == 'a'
    if empty(next) && empty(previous)
      let [from, to] = [ first_selected[0], last_selected[1] ]
    elseif empty(next)
      let [from, to] = [ previous[1] + 1, last_selected[1] ]
    else " !empty(next)
      let [from, to] = [ first_selected[0], next[0] - 1 ]
    endif
  endif

  call s:MarkCols(from, to)
endfunction

function! s:MarkCols(start_col, end_col)
  let line_offset = line2byte('.')
  let start_byte  = line_offset + a:start_col - 1
  let end_byte    = line_offset + a:end_col - 1

  exe 'normal! '.start_byte.'gov'.end_byte.'go'
  return 1
endfunction
