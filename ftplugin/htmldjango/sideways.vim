if exists('b:sideways_definitions')
  finish
endif

let b:sideways_definitions = [
      \   sideways#html#Definition('tag_attributes', {}),
      \   sideways#html#Definition('double_quoted_class', {}),
      \   sideways#html#Definition('single_quoted_class', {}),
      \   sideways#html#Definition('double_quoted_style', {}),
      \   sideways#html#Definition('single_quoted_style', {}),
      \ ]
