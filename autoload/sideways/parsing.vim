" Extract column positions for "arguments" on the current line. Returns the
" used definition, and a list of objects, each one containing the start and
" end positions of the item:
"
" {
"   start_line: 3, end_line: 3,
"   start_col: 12, end_col: 17
" }
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
"   [
"     { start: '(\_s*', end: ')', ... },
"     [
"       {start_line: 1, end_line: 1, start_col: 14, end_col: 16},
"       {start_line: 1, end_line: 1, start_col: 19, end_col: 21},
"       {start_line: 2, end_line: 2, start_col: 3, end_col: 7},
"     ]
"   ]
"
function! sideways#parsing#Parse(definitions)
  let definitions = a:definitions

  let viewpos     = winsaveview()
  let cursor_line = line('.')
  let cursor_col  = col('.')

  let valid_definitions = s:LocateValidDefinitions(definitions)
  call sort(valid_definitions, function('s:CompareDefinitionStarts'))

  " call s:DebugValidDefinitions(valid_definitions)

  for [start_line, start_col, definition] in valid_definitions
    let items = s:ParseItems(definition, start_line, start_col)
    if len(items) == 0
      continue
    endif

    let first_item = items[0]
    let last_item  = items[len(items) - 1]

    if s:Between(
          \ [cursor_line, cursor_col],
          \ [first_item.start_line, first_item.start_col],
          \ [last_item.end_line, last_item.end_col]
          \ )
      call winrestview(viewpos)
      return [definition, items]
    endif
  endfor

  call winrestview(viewpos)
  return [{}, []]
endfunction

" Compares lines, columns of a definition -- later positions are first.
"
function! s:CompareDefinitionStarts(first, second)
  let [first_line, first_col, _d1]   = a:first
  let [second_line, second_col, _d2] = a:second

  if first_line > second_line || (first_line == second_line && first_col > second_col)
    return -1
  elseif second_line > first_line || (second_line == first_line && second_col > first_col)
    return 1
  else
    return 0
  endif
endfunction

" Tries to parse items according to the given definition. Returns [] if it
" fails.
"
function! s:ParseItems(definition, start_line, start_col)
  let definition = a:definition
  call sideways#util#SetPos(a:start_line, a:start_col)

  let viewpos     = winsaveview()
  let cursor_line = line('.')
  let items       = []

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

    if remainder_of_line =~ '^'.delimiter_pattern && !eval(skip_expression)
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
        if eval(skip_expression)
          " then we're currently in something that's sort of a string, don't
          " consider the skip expression.
          "
          " Example: ruby's %q{...}
          call searchpair('\V'.opening_bracket, '', '\V'.closing_bracket, 'W')
        else
          call searchpair('\V'.opening_bracket, '', '\V'.closing_bracket, 'W', skip_expression)
        endif
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

    if single_line && line('.') > cursor_line
      " no point in continuing, this is not a valid definition
      return []
    endif

    let remainder_of_line = s:RemainderOfLine()
  endwhile

  let &whichwrap = original_whichwrap

  if current_item.end_col < 0
    " parsing ended before current item was finalized
    let current_item.end_col = col('.') - 1
    let current_item.end_line = line('.')
  endif

  if current_item.start_line < current_item.end_line ||
        \ (
        \   current_item.start_line == current_item.end_line &&
        \   current_item.start_col  <= current_item.end_col
        \ )
    call add(items, current_item)
  else
    " it's an invalid item, ignore it
  endif

  " call s:DebugItems(definition, items)

  call winrestview(viewpos)
  return items
endfunction

function! s:LocateValidDefinitions(definitions)
  silent! normal! zO

  let cursor_line = line('.')
  let cursor_col  = col('.')
  let results     = []

  for definition in a:definitions
    let start_pattern = definition.start
    let end_pattern   = definition.end

    if get(definition, 'single_line', 0)
      let stopline = line('.')
    else
      let stopline = 0
    endif

    let skip_expression = s:SkipSyntaxExpression(definition)
    call sideways#util#PushCursor()

    let pair_search_result = searchpair(start_pattern, '', end_pattern, 'bW',
          \ skip_expression, stopline, g:sideways_search_timeout)
    if pair_search_result <= 0
      let start_search_result = sideways#util#SearchSkip(start_pattern, 'bW',
            \ skip_expression, stopline, g:sideways_search_timeout)
    else
      let start_search_result = 0
    endif

    if pair_search_result <= 0 && start_search_result <= 0
      call sideways#util#PopCursor()
      continue
    else
      call sideways#util#SearchSkip(start_pattern, 'Wce', skip_expression, line('.'))
      let match_start_line = line('.')
      let match_start_col  = col('.') + 1

      if cursor_line < match_start_line || (cursor_line == match_start_line && cursor_col < match_start_col)
        call sideways#util#PopCursor()
        continue
      endif

      call add(results, [match_start_line, match_start_col, definition])
    endif

    call sideways#util#PopCursor()
  endfor

  return results
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
  let a:current_item.end_line = line('.')
  let a:current_item.end_col = a:final_col

  call add(a:items, a:current_item)
endfunction

" Initialize a brand new item, starting at the current position
function! s:NewItem()
  return {
        \   'start_line': line('.'), 'end_line': line('.'),
        \   'start_col':  col('.'),  'end_col':  -1,
        \ }
endfunction

function! s:Between(position, start, end)
  let [line, col]             = a:position
  let [start_line, start_col] = a:start
  let [end_line, end_col]     = a:end

  if line < start_line  || line > end_line  | return 0 | endif
  if line == start_line && col  < start_col | return 0 | endif
  if line == end_line   && col  > end_col   | return 0 | endif

  return 1
endfunction

function! s:SkipSyntaxExpression(definition)
  if !g:sideways_skip_strings_and_comments
    return ''
  endif

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
function! s:DebugItems(definition, items)
  Decho "Start: ".a:definition.start

  for item in a:items
    let text = sideways#util#GetItem(item)
    Decho string([
          \   string(item.start_line).":".string(item.start_col),
          \   string(item.end_line).":".string(item.end_col),
          \   text
          \ ])
  endfor
endfunction

function! s:DebugValidDefinitions(valid_definitions)
  for item in map(copy(a:valid_definitions), 'v:val[0]."/".v:val[1].": ".v:val[2].start')
    Decho item
  endfor
endfunction
