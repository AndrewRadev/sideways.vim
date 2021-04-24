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
    call s:SetRepeatAutocommand('SidewaysArgumentInsertBefore')
  elseif a:mode == 'a'
    call s:InsertAfter(current, delimiter_string, new_line)
    call s:SetRepeatAutocommand('SidewaysArgumentAppendAfter')
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
  call s:SetRepeatAutocommand('SidewaysArgumentInsertFirst')
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
  call s:SetRepeatAutocommand('SidewaysArgumentAppendLast')
endfunction

function! sideways#new_item#Repeat(action, text)
  let b:sideways_repeat_new_item = a:text
  exe "normal \<Plug>".a:action
  unlet b:sideways_repeat_new_item
endfunction

function! s:InsertBefore(item, delimiter_string, new_line)
  let item             = a:item
  let delimiter_string = a:delimiter_string
  let new_line         = a:new_line
  let repeat_text      = get(b:, 'sideways_repeat_new_item', '')

  if g:sideways_add_item_cursor_restore && has('textprop')
    call s:StorePosition()
  endif

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
  if g:sideways_add_item_cursor_restore && has('textprop')
    call s:SetupRestorePosition()
  endif

  call feedkeys('i' . whitespace . repeat_text, 'n')
endfunction

function! s:InsertAfter(item, delimiter_string, new_line)
  let item             = a:item
  let delimiter_string = a:delimiter_string
  let new_line         = a:new_line
  let repeat_text      = get(b:, 'sideways_repeat_new_item', '')

  if g:sideways_add_item_cursor_restore && has('textprop')
    call s:StorePosition()
  endif

  call sideways#util#SetPos(item.end_line, item.end_col)

  if new_line
    exe "normal! a".sideways#util#Trim(delimiter_string)."\<cr>\<esc>"

    if getline('.') == ''
      call feedkeys('cc' . repeat_text, 'n')
    else
      call feedkeys('I' . repeat_text, 'n')
    endif
  else
    exe 'normal! a'.delimiter_string
    call feedkeys('a' . repeat_text, 'n')
  endif

  if g:sideways_add_item_cursor_restore && has('textprop')
    call s:SetupRestorePosition()
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

function! s:StorePosition()
  " Define new prop type we'll be working with
  if empty(prop_type_get('sideways_saved_position', {'bufnr': bufnr()}))
    call prop_type_add('sideways_saved_position', {'bufnr': bufnr()})
  endif

  let b:sideways_changedtick = b:changedtick
  call prop_add(line('.'), col('.'), {
        \ 'id': b:sideways_changedtick,
        \ 'type': 'sideways_saved_position',
        \ 'length': 0,
        \ })
endfunction

function! s:SetupRestorePosition()
  exe "augroup sideways_add_item_cursor_restore_".bufnr('%')
    autocmd!

    autocmd InsertLeave <buffer> call s:JumpToSavedPosition()
    autocmd InsertLeave <buffer> call s:ClearSavedPosition()
  augroup END
endfunction

function! s:JumpToSavedPosition()
  if exists('b:sideways_changedtick')
    let position = prop_find({'id': b:sideways_changedtick}, 'f')
    if empty(position)
      let position = prop_find({'id': b:sideways_changedtick}, 'b')
    endif

    if has_key(position, 'lnum')
      let view = winsaveview()
      let view.lnum = position.lnum
      " note for winsaveview, the first column is 0
      let view.col = position.col - 1
      call winrestview(view)
    endif

    unlet b:sideways_changedtick
  endif
endfunction

function! s:ClearSavedPosition()
  " clear everything
  exe "augroup sideways_add_item_cursor_restore_".bufnr('%')
    autocmd!
  augroup END

  call prop_remove({'type': 'sideways_saved_position', 'all': 1})
endfunction

function! s:SetRepeatAutocommand(action)
  if !g:sideways_add_item_repeat
    return
  endif

  if !(has('patch-8.1.1113') || has('nvim-0.4.0'))
    " then ++once is not available
    return
  endif

  exe 'autocmd InsertLeavePre <buffer> ++once call s:SetRepeatInvocation("'.a:action.'")'
endfunction

function! s:SetRepeatInvocation(action)
  let last_insert = @.
  let repeat_invocation = ":call sideways#new_item#Repeat(\"" . a:action . "\", \"". escape(last_insert, '"\') . "\")\<cr>"

  silent! call repeat#set(repeat_invocation)
endfunction
