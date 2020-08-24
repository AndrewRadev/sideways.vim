function! sideways#new_item#Add(mode)
  let [definition, items] = sideways#Parse()
  if empty(items)
    return
  endif

  let coordinates      = sideways#AroundCursor(items)
  let delimiter_string = s:BuildDelimiterString(definition)
  let new_line         = s:DecideNewLine(items)

  " coordinates have the form {start_line, start_col, end_line, end_col}
  let [_, current, _] = coordinates

  if a:mode == 'i'
    call s:InsertBefore(current, delimiter_string, new_line)
  elseif a:mode == 'a'
    call s:InsertAfter(current, delimiter_string, new_line)
  endif
endfunction

function! sideways#new_item#AddFirst()
  let [definition, items] = sideways#Parse()
  if empty(items)
    return
  endif

  let delimiter_string = s:BuildDelimiterString(definition)
  let new_line         = s:DecideNewLine(items)

  let first_item = items[0]
  call s:InsertBefore(first_item, delimiter_string, new_line)
endfunction

function! sideways#new_item#AddLast()
  let [definition, items] = sideways#Parse()
  if empty(items)
    return
  endif

  let delimiter_string = s:BuildDelimiterString(definition)
  let new_line         = s:DecideNewLine(items)

  let last_item = items[len(items) - 1]
  call s:InsertAfter(last_item, delimiter_string, new_line)
endfunction

function! s:InsertBefore(item, delimiter_string, new_line)
  let item             = a:item
  let delimiter_string = a:delimiter_string
  let new_line         = a:new_line

  call sideways#util#SetPos(item.start_line, item.start_col)

  " Blank lines need the extra whitespace inserted after opening the line, and
  " before entering insert mode again:
  let whitespace = ''

  if new_line
    let delimiter_string = sideways#util#Rtrim(delimiter_string)
    if empty(delimiter_string)
      " then this line will be blank, we'll need to enter the needed
      " whitespace manually:
      let whitespace = matchstr(getline('.'), '^\s*')
    endif

    exe 'normal! O'.delimiter_string
  else
    exe 'normal! i'.delimiter_string
  endif

  call sideways#util#SetPos(item.start_line, item.start_col)
  call feedkeys('i'.whitespace, 'n')
endfunction

function! s:InsertAfter(item, delimiter_string, new_line)
  let item             = a:item
  let delimiter_string = a:delimiter_string
  let new_line         = a:new_line

  call sideways#util#SetPos(item.end_line, item.end_col)

  if new_line
    exe "normal! a".sideways#util#Trim(delimiter_string)."\<cr>\<esc>"

    if getline('.') == ''
      call feedkeys('cc', 'n')
    else
      call feedkeys('I', 'n')
    endif
  else
    exe 'normal! a'.delimiter_string
    call feedkeys('a', 'n')
  endif
endfunction

function! s:BuildDelimiterString(definition)
  let definition = a:definition

  if has_key(definition, 'delimited_by_whitespace')
    return ' '
  else
    let delimiter_pattern = definition.delimiter
    return substitute(delimiter_pattern, '\\_\=s\*\=', ' ', 'g')
  endif
endfunction

function! s:DecideNewLine(items)
  let items = a:items

  if len(items) <= 1
    " only one item, let's assume no new lines:
    return 0
  endif

  let start_lines = sort(map(copy(items), 'v:val.start_line'))
  if len(start_lines) == len(sideways#util#Uniq(start_lines))
    " then all the items are on separate lines, so this one should be as well:
    return 1
  else
    return 0
  endif
endfunction
