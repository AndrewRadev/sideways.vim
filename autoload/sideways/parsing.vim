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

  while remainder_of_line !~ '^'.end_pattern
    let [opening_bracket_match, offset] = s:BracketMatch(remainder_of_line, opening_brackets)
    let [closing_bracket_match, offset] = s:BracketMatch(remainder_of_line, closing_brackets)

    if opening_bracket_match < 0 && closing_bracket_match >= 0
      " there's an extra closing bracket from outside the list, bail out
      break
    elseif col('.') == col('$') - 1
      " then we're at the end of the line, finish up
      let current_item[1] = col('$') - 1
      break
    elseif opening_bracket_match >= 0
      " then try to jump to the closing bracket
      let opening_bracket = opening_brackets[opening_bracket_match]
      let closing_bracket = closing_brackets[opening_bracket_match]

      " first, go to the opening bracket
      if offset > 0
        exe "normal! ".offset."l"
      end

      if opening_bracket == closing_bracket
        " same bracket, search for it
        call search('\V'.closing_bracket, 'W', line('.'))
      else
        " different closing, use searchpair
        call searchpair('\V'.opening_bracket, '', '\V'.closing_bracket, 'W', '', line('.'))
      endif

      if col('.') == col('$') - 1
        " then we're at the end of the line, finish up to avoid an extra
        " bracket check
        let current_item[1] = col('$') - 1
        break
      else
        " there's still room, move rightwards
        normal! l
      endif
    elseif remainder_of_line =~ delimiter_pattern
      " then store the current item
      let current_item[1] = col('.') - 1
      call add(items, current_item)

      let match = matchstr(remainder_of_line, delimiter_pattern)
      exe 'normal! '.len(match).'l'

      " skip some whitespace TODO consider removing
      if skip_pattern != ''
        while s:RemainderOfLine() =~ skip_pattern
          normal! l
        endwhile
      endif

      " initialize a new "current item"
      let current_item = [col('.'), -1]
    else
      " move rightwards
      normal! l
    endif

    let remainder_of_line = s:RemainderOfLine()
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

    if has_key(definition, 'skip_syntax')
      let skip = s:SkipSyntax(definition.skip_syntax)
    else
      let skip = ''
    endif

    call sideways#util#PushCursor()

    if searchpair(start_pattern, '', end_pattern, 'bW', skip, line('.')) <= 0
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
  let index  = 0
  let offset = match(a:text, '^\s*\zs')
  let text   = strpart(a:text, offset)

  for char in split(a:brackets, '\zs')
    if text[0] ==# char
      return [index, offset]
    else
      let index += 1
    endif
  endfor

  return [-1, 0]
endfunction

" Returns the remainder of the line from the current cursor position to the
" end.
function! s:RemainderOfLine()
  return strpart(getline('.'), col('.') - 1)
endfunction

function! s:SkipSyntax(groups)
  let syntax_groups = a:groups
  let skip_pattern  = '\%('.join(syntax_groups, '\|').'\)'

  return "synIDattr(synID(line('.'),col('.'),1),'name') =~ '".skip_pattern."'"
endfunction

" Simple debugging
function! s:DebugItems(items)
  Decho a:items
  Decho map(copy(a:items), 'sideways#util#GetCols(v:val[0], v:val[1])')
endfunction
