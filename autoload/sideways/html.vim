let s:definitions = {
      \   'tag_attributes': {
      \     'start':                   '<\%(\k\|\.\)\+\_s\+',
      \     'end':                     '\s*/\?>',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['"''', '"'''],
      \   },
      \   'double_quoted_class': {
      \     'skip_syntax':             [],
      \     'start':                   '\<class="',
      \     'end':                     '"',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['', ''],
      \   },
      \   'single_quoted_class': {
      \     'skip_syntax':             [],
      \     'start':                   '\<class=''',
      \     'end':                     "'",
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['', ''],
      \   },
      \   'double_quoted_style': {
      \     'skip_syntax':       [],
      \     'start':             '\<style="',
      \     'end':               '"',
      \     'delimiter':         ';\_s*',
      \     'brackets':          ['', ''],
      \   },
      \   'single_quoted_style': {
      \     'skip_syntax':       [],
      \     'start':             '\<style=''',
      \     'end':               "'",
      \     'delimiter':         ';\_s*',
      \     'brackets':          ['', ''],
      \   },
      \ }

function! sideways#html#Definition(key, overrides)
  return extend(copy(s:definitions[a:key]), a:overrides)
endfunction
