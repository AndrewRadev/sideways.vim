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
function! sideways#parsing#Parse()
  let definitions =
        \ [
        \   {
        \     'start':     '(\s*',
        \     'end':       '\s*)',
        \     'delimiter': '^,\s*',
        \     'skip':      '^\s',
        \     'brackets':  ['([''"', ')]''"']
        \   },
        \   {
        \     'start':     '\[\s*',
        \     'end':       '\s*\]',
        \     'delimiter': '^,\s*',
        \     'skip':      '^\s',
        \     'brackets':  ['([''"', ')]''"']
        \   },
        \   {
        \     'start':     '\k:\s*',
        \     'end':       ';',
        \     'delimiter': '^\s',
        \     'skip':      '^\s',
        \     'brackets':  ['(''"', ')''"']
        \   },
        \   {
        \     'start':     '^\s*|',
        \     'end':       '|$',
        \     'delimiter': '^|',
        \     'skip':      '^$',
        \     'brackets':  ['(''"', ')''"']
        \   },
        \ ]

  let items = []

  for definition in definitions
    let start_pattern     = definition.start
    let end_pattern       = definition.end
    let delimiter_pattern = definition.delimiter
    let skip_pattern      = definition.skip

    let [opening_brackets, closing_brackets] = definition.brackets

    normal! zR
    call sideways#util#PushCursor()

    if searchpair(start_pattern, '', end_pattern, 'bW', '', line('.')) <= 0
      call sideways#util#PopCursor()
      continue
    else
      call search(start_pattern, 'Wce', line('.'))
    endif

    normal! l

    let current_item = [col('.'), -1]

    let remainder_of_line = s:RemainderOfLine()

    while s:RemainderOfLine() !~ '^'.end_pattern
      let remainder_of_line = s:RemainderOfLine()
      let bracket_match = s:BracketMatch(remainder_of_line, opening_brackets)

      if bracket_match >= 0
        let closing_bracket = closing_brackets[bracket_match]

        if search('\V'.closing_bracket, 'W', line('.')) <= 0
          continue
        else
          normal! l
        endif
      elseif remainder_of_line =~ delimiter_pattern
        let current_item[1] = col('.') - 1
        call add(items, current_item)

        normal! l
        while s:RemainderOfLine() =~ skip_pattern
          normal! l
        endwhile
        let current_item = [col('.'), -1]
      elseif col('.') == col('$') - 1
        let current_item[1] = col('$') - 1
        break
      else
        normal! l
      endif
    endwhile

    if current_item[1] < 0
      let current_item[1] = col('.') - 1
    endif
    call add(items, current_item)

    if !empty(items)
      call sideways#util#PopCursor()
      break
    endif

    call sideways#util#PopCursor()
  endfor

  return items
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
