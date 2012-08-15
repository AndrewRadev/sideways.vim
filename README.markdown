[![Build Status](https://secure.travis-ci.org/AndrewRadev/sideways.vim.png?branch=master)](http://travis-ci.org/AndrewRadev/sideways.vim)

## Usage

The plugin defines two commands, `:SidewaysLeft` and `:SidewaysRight`, which
move the item under the cursor left or right, where an "item" is defined by a
delimiter. As an example:

``` python
def function(one, two, three):
    pass
```

Placing the cursor on "two" and executing `:SidewaysLeft`, the "one" and "two"
arguments will switch their places, resulting in this:

``` python
def function(two, one, three):
    pass
```

In this case, the delimiter is a comma. The plugin currently works with
various other cases and it's intended to make the process configurable. While
this particular example is in python, this should work for arguments in many
different languages that use round braces to denote function calls.

Apart from functions, it works for square-bracket lists in dynamic languages:

``` python
list = [one, [two, four, five], three]
```

Notice that, if you experiment with this example, you'll find that you can
move the entire second list around. The plugin takes into consideration nested
structures.

Apart from functions, it works for lists in CSS declarations:

``` css
border-radius: 20px 0 0 20px;
```

And, it also works for cucumber tables:

``` cucumber
Examples:
  | input_1 | input_2 | button | output |
  | 20      | 30      | add    | 50     |
  | 2       | 5       | add    | 7      |
  | 0       | 40      | add    | 40     |
```

It's highly suggested to map the two commands to convenient keys. For example,
mapping them to `<c-h>` and `<c-l>` would look like this:

``` vim
nnoremap <c-h> :SidewaysLeft<cr>
nnoremap <c-l> :SidewaysRight<cr>
```

The plugin is intended to be highly customizable. In the future, it should be
able to work with ruby function arguments and it may also contain an "argument"
text object (since the machinery to detect arguments is already there).
