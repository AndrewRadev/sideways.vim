" Performs an operator on an item in the list.
"
" Given a count, looks for "outer" lists to work with. This only makes sense
" when there are multiple lists around the cursor and we're in an inner one.
"
function! sideways#textobj#Argument(mode, count)
  let items = sideways#Parse()
  if empty(items)
    return 0
  endif

  let coordinates = sideways#AroundCursor(items)
  if empty(coordinates)
    return 0
  endif

  if items[0][0] > 1 && a:count > 1
    " try to look for an outer argument list
    call sideways#util#SetCol(items[0][0] - 1)

    if sideways#textobj#Argument(a:mode, a:count - 1)
      return 1
    endif
  endif

  let [previous, current, next] = coordinates

  if a:mode == 'i'
    let [from, to] = [ current[0], current[1] ]
  elseif a:mode == 'a'
    if empty(next) && empty(previous)
      let [from, to] = [ current[0], current[1] ]
    elseif empty(next)
      let [from, to] = [ previous[1] + 1, current[1] ]
    else " !empty(next)
      let [from, to] = [ current[0], next[0] - 1 ]
    endif
  endif

  call s:MarkCols(from, to)
  return 1
endfunction

function! s:MarkCols(start_col, end_col)
  let line_offset = line2byte('.')
  let start_byte  = line_offset + a:start_col - 1
  let end_byte    = line_offset + a:end_col - 1

  exe 'normal! '.start_byte.'gov'.end_byte.'go'
  return 1
endfunction
