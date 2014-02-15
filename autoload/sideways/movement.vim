" Constructor:
" ============

" Create a new "movement" object. Its `first` attribute is the leftmost item
" of the two items affected by the movement, and `second` is the rightmost one.
"
function! sideways#movement#New(direction, items)
  let movement = {
        \ 'items':     a:items,
        \ 'direction': a:direction,
        \ 'active':    [],
        \ 'first':     [],
        \ 'second':    [],
        \ 'new_col':   -1,
        \
        \ 'IsBlank': function('sideways#movement#IsBlank'),
        \ 'Left':    function('sideways#movement#Left'),
        \ 'Right':   function('sideways#movement#Right'),
        \ 'Swap':    function('sideways#movement#Swap'),
        \ 'Jump':    function('sideways#movement#Jump'),
        \ }

  if a:direction == 'left'
    return movement.Left()
  elseif a:direction == 'right'
    return movement.Right()
  endif
endfunction

" Methods:
" ========

function! sideways#movement#IsBlank() dict
  return empty(self.items) || (empty(self.first) && empty(self.second))
endfunction

" Turn the movement into a leftwards one, based on the current cursor
" position.
"
function! sideways#movement#Left() dict
  if empty(self.items)
    return self
  end

  let last_index   = len(self.items) - 1
  let active_index = sideways#FindActiveItem(self.items)
  if active_index < 0
    return self
  endif

  if active_index == 0
    let self.first   = self.items[active_index]
    let self.second  = self.items[last_index]
    let self.new_col = self.second[0]
    let self.active  = self.first
  else
    let self.first   = self.items[active_index - 1]
    let self.second  = self.items[active_index]
    let self.new_col = self.first[0]
    let self.active  = self.second
  endif

  return self
endfunction

" Turn the movement into a rightwards one, based on the current cursor
" position.
"
function! sideways#movement#Right() dict
  if empty(self.items)
    return self
  end

  let last_index   = len(self.items) - 1
  let active_index = sideways#FindActiveItem(self.items)
  if active_index < 0
    return self
  endif

  if active_index == last_index
    let self.first   = self.items[0]
    let self.second  = self.items[last_index]
    let self.new_col = self.first[0]
    let self.active  = self.second
  else
    let self.first   = self.items[active_index]
    let self.second  = self.items[active_index + 1]
    let self.new_col = self.second[0]
    let self.active  = self.first
  endif

  return self
endfunction

" Swap the two items the movement covers. The cursor is positioned on the new
" item.
"
function! sideways#movement#Swap() dict
  let [first_start, first_end]   = self.first
  let [second_start, second_end] = self.second

  let first_body  = sideways#util#GetCols(first_start, first_end)
  let second_body = sideways#util#GetCols(second_start, second_end)

  call sideways#util#ReplaceCols(second_start, second_end, first_body)
  call sideways#util#ReplaceCols(first_start, first_end, second_body)

  let new_col = self.new_col
  if self.first == self.active
    " then we are moving towards the second one, so first one will be changed
    " and we need to compensate with the difference in lengths
    let adjustment = (self.second[1] - self.second[0]) - (self.first[1] - self.first[0])
    let new_col += adjustment
  endif

  call sideways#util#SetCol(new_col)
endfunction

" Position the cursor on the new item defined by the movement
"
function! sideways#movement#Jump() dict
  call sideways#util#SetCol(self.new_col)
endfunction
