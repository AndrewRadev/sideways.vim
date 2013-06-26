" Extract column positions for "arguments" on the current line. Returns a list
" of pairs, each pair contains the start and end columns of the item
"
" Example:
"
" On the following line:
"
"   def function(one, two):
"
" The result would be:
"
"   [ [14, 16], [19, 21] ]
"
function! sideways#parsing#Parse(definitions)
  call sideways#util#PushCursor()

  let definitions = a:definitions
  let items       = []

  let definition = s:LocateBestDefinition(definitions)

  if empty(definition)
    call sideways#util#PopCursor()
    return []
  endif

  let start_pattern     = definition.start
  let end_pattern       = definition.end
  let delimiter_pattern = definition.delimiter
  let skip_pattern      = definition.skip

  let [opening_brackets, closing_brackets] = definition.brackets

  let current_item = [col('.'), -1]
  let remainder_of_line = s:RemainderOfLine()

  " TODO (2012-09-07) Figure out how to work with RemainderOfLine
  while s:RemainderOfLine() !~ '^'.end_pattern
    let remainder_of_line = s:RemainderOfLine()
    let bracket_match = s:BracketMatch(remainder_of_line, opening_brackets)

    if col('.') == col('$') - 1
      " then we're at the end of the line, finish up
      let current_item[1] = col('$') - 1
      break
    elseif bracket_match >= 0
      " then try to jump to the closing bracket
      let opening_bracket = opening_brackets[bracket_match]
      let closing_bracket = closing_brackets[bracket_match]

      call searchpair('\V'.opening_bracket, '', '\V'.closing_bracket, 'W', '', line('.'))
      " move rightwards regardless of the result
      normal! l
    elseif remainder_of_line =~ delimiter_pattern
      " then store the current item
      let current_item[1] = col('.') - 1
      call add(items, current_item)

      let match = matchstr(remainder_of_line, delimiter_pattern)
      exe 'normal! '.len(match).'l'

      " skip some whitespace TODO consider removing
      while s:RemainderOfLine() =~ skip_pattern
        normal! l
      endwhile

      " initialize a new "current item"
      let current_item = [col('.'), -1]
    else
      " move rightwards
      normal! l
    endif
  endwhile

  if current_item[1] < 0
    let current_item[1] = col('.') - 1
  endif
  call add(items, current_item)

  call sideways#util#PopCursor()
  return items
endfunction

function! s:LocateBestDefinition(definitions)
  silent! normal! zO

  let best_definition     = {}
  let best_definition_col = 0

  for definition in a:definitions
    let start_pattern = definition.start
    let end_pattern   = definition.end

    call sideways#util#PushCursor()

    if searchpair(start_pattern, '', end_pattern, 'bW', '', line('.')) <= 0
      call sideways#util#PopCursor()
      continue
    else
      call search(start_pattern, 'Wce', line('.'))
      normal! l

      if best_definition_col < col('.')
        let best_definition_col = col('.')
        let best_definition = definition
      endif
    endif

    call sideways#util#PopCursor()
  endfor

  if best_definition_col > 0
    call sideways#util#SetCol(best_definition_col)
    return best_definition
  else
    return {}
  endif
endfunction

function! s:BracketMatch(text, brackets)
  let index = 0
  for char in split(a:brackets, '\zs')
    if a:text[0] ==# char
      return index
    else
      let index += 1
    endif
  endfor

  return -1
endfunction

" Returns the remainder of the line from the current cursor position to the
" end.
function! s:RemainderOfLine()
  return strpart(getline('.'), col('.') - 1)
endfunction

" Simple debugging
function! s:DebugItems(items)
  Decho a:items
  Decho map(copy(a:items), 'sideways#util#GetCols(v:val[0], v:val[1])')
endfunction
