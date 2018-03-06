" Extract column positions for "arguments" on the current line. Returns a list
" of triplets, each triplet contains the line and start and end columns of the
" item.
"
" Example:
"
" On the following line:
"
"   def function(one, two,
"     three):
"
" The result would be:
"
"   [ [1, 14, 16], [1, 19, 21], [2, 3, 7] ]
"
function! sideways#parsing#Parse(definitions)
  let viewpos = winsaveview()

  let definitions = a:definitions
  let items       = []

  let definition = s:LocateBestDefinition(definitions)

  if empty(definition)
    call winrestview(viewpos)
    return []
  endif

  let start_pattern           = definition.start
  let end_pattern             = definition.end
  let delimited_by_whitespace = get(definition, 'delimited_by_whitespace', 0)
  let single_line             = get(definition, 'single_line', 0)

  if delimited_by_whitespace
    let delimiter_pattern = '\s\+'
  else
    let delimiter_pattern = definition.delimiter
  endif

  let skip_expression = s:SkipSyntaxExpression(definition)
  let [opening_brackets, closing_brackets] = definition.brackets

  let current_item = s:NewItem()
  let remainder_of_line = s:RemainderOfLine()

  let original_whichwrap = &whichwrap
  set whichwrap+=l

  while remainder_of_line !~ '^'.end_pattern
    let [opening_bracket_match, offset] = s:BracketMatch(remainder_of_line, opening_brackets)
    let [closing_bracket_match, _]      = s:BracketMatch(remainder_of_line, closing_brackets)

    if remainder_of_line =~ '^'.delimiter_pattern
      " then store the current item, and find the next one
      call s:PushItem(items, current_item, col('.') - 1)
      let match = matchstr(remainder_of_line, '^'.delimiter_pattern)
      exe 'normal! '.len(match).'l'
      call s:SkipWhitespace()
      let current_item = s:NewItem()
    elseif opening_bracket_match < 0 && closing_bracket_match >= 0
      " there's an extra closing bracket from outside the list, bail out
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
        " same bracket (quote), search for it, unless it's escaped
        call search('\\\@<!\V'.closing_bracket, 'W')
      else
        " different closing, use searchpair
        call searchpair('\V'.opening_bracket, '', '\V'.closing_bracket, 'W', skip_expression)
      endif

      if col('.') == col('$') - 1
        " then we're at the end of the line, finish up to avoid an extra
        " bracket check
        call s:PushItem(items, current_item, col('$') - 1)

        if delimited_by_whitespace && !single_line
          " there should be something on the next line, keep going
          normal! l
          call s:SkipWhitespace()
          let current_item = s:NewItem()
        elseif search('^\s*'.delimiter_pattern.'\zs', '', nextnonblank(line('.') + 1))
          " the next line starts with a delimiter, skip over it and keep going
          let current_item = s:NewItem()
        else
          " no need to try to continue, reset current item and bail out
          let current_item = s:NewItem()
          break
        endif
      else
        " not at the end of the line, keep going
        normal! l
      endif
    elseif col('.') == col('$') - 1
      " then we're at the end of the line, but not due to a delimiter --
      " finish up with this item
      call s:PushItem(items, current_item, col('$') - 1)
      let current_item = s:NewItem()

      if delimited_by_whitespace && !single_line
        " try to continue after the end of this line
        normal! l
        call s:SkipWhitespace()
        let current_item = s:NewItem()
      elseif search('^\s*'.delimiter_pattern.'\zs', '', nextnonblank(line('.') + 1))
        " the next line starts with a delimiter, skip over it and keep going
        let current_item = s:NewItem()
      else
        break
      endif
    else
      " move rightwards
      normal! l
    endif

    let remainder_of_line = s:RemainderOfLine()
  endwhile

  let &whichwrap = original_whichwrap

  if current_item[2] < 0
    " parsing ended before current item was finalized
    let current_item[2] = col('.') - 1
  endif

  if current_item[1] <= current_item[2]
    call add(items, current_item)
  else
    " it's an invalid item, ignore it
  endif

  " call s:DebugItems(items)

  call winrestview(viewpos)
  return items
endfunction

function! s:LocateBestDefinition(definitions)
  silent! normal! zO

  let best_definition      = {}
  let best_definition_col  = 0
  let best_definition_line = -1

  for definition in a:definitions
    let start_pattern = definition.start
    let end_pattern   = definition.end

    let skip_expression = s:SkipSyntaxExpression(definition)
    call sideways#util#PushCursor()

    if searchpair(start_pattern, '', end_pattern, 'bW', skip_expression) <= 0
      call sideways#util#PopCursor()
      continue
    else
      call sideways#util#SearchSkip(start_pattern, skip_expression, 'Wce', line('.'))
      normal! l

      let match_line = line('.')
      let match_col = col('.')

      if match_line > best_definition_line ||
            \ (match_line == best_definition_line && match_col > best_definition_col)
        let best_definition_line = match_line
        let best_definition_col  = match_col
        let best_definition      = definition
      endif
    endif

    call sideways#util#PopCursor()
  endfor

  if best_definition_col > 0
    call sideways#util#SetPos(best_definition_line, best_definition_col)
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

function! s:SkipWhitespace()
  let whitespace = matchstr(s:RemainderOfLine(), '^\s\+')
  if len(whitespace) > 0
    exe 'normal! '.len(whitespace).'l'
  endif
endfunction

" Finalize the current item and push it to the store
function! s:PushItem(items, current_item, final_col)
  let a:current_item[0] = line('.')
  let a:current_item[2] = a:final_col

  call add(a:items, a:current_item)
endfunction

" Initialize a brand new item, starting at the current position
function! s:NewItem()
  return [line('.'), col('.'), -1]
endfunction

function! s:SkipSyntaxExpression(definition)
  if has_key(a:definition, 'skip_syntax')
    let syntax_groups = a:definition.skip_syntax
  elseif exists('b:sideways_skip_syntax')
    let syntax_groups = b:sideways_skip_syntax
  else
    " By default, try to skip comments and strings
    let syntax_groups = ['Comment', 'String']
  endif

  if len(syntax_groups) == 0
    return ''
  endif

  let skip_pattern  = '\%('.join(syntax_groups, '\|').'\)'

  return "synIDattr(synID(line('.'),col('.'),1),'name') =~# '".skip_pattern."'"
endfunction

" Simple debugging
function! s:DebugItems(items)
  Decho a:items
  Decho map(copy(a:items), 'sideways#util#GetCols(v:val[0], v:val[1], v:val[2])')
endfunction
