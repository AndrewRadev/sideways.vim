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

For ruby and eruby, it detects method calls without braces as well:
``` ruby
link_to user_registration_path, 'Something'
# changes to:
link_to 'Something', user_registration_path
```

Apart from functions, it works for square-bracket lists in dynamic languages:

``` python
list = [one, [two, four, five], three]
```

If you experiment with this example, you'll find that you can move the entire
second list around, as long as the cursor is on one of the inner brackets. The
plugin takes into consideration nested structures.

It works for lists in CSS declarations:

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

It's highly recommended to map the two commands to convenient keys. For
example, mapping them to `<c-h>` and `<c-l>` would look like this:

``` vim
nnoremap <c-h> :SidewaysLeft<cr>
nnoremap <c-l> :SidewaysRight<cr>
```

The plugin is intended to be customizable, though at this point you'd need to
look at the source to do this.

## Bonus functionality

The plugin's machinery makes it easy to implement an "argument" text object.
There are two mappings provided:

    <Plug>SidewaysArgumentTextobjA
    <Plug>SidewaysArgumentTextobjI

These are the outer and inner text objects, respectively. To use them, you
need to create mappings in your configuration files. Something like this:

``` vim
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI
```

This will map the "a" text object to operate on an "argument". So, you can
perform `daa` to delete an argument, `cia` to change an argument, and so on.
See `:help text-objects` for more information.
