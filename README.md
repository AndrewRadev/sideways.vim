[![Build Status](https://secure.travis-ci.org/AndrewRadev/sideways.vim.svg?branch=master)](http://travis-ci.org/AndrewRadev/sideways.vim)

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

For ruby and eruby, it detects **method calls without braces** as well:

``` ruby
link_to user_registration_path, 'Something'
# changes to:
link_to 'Something', user_registration_path
```

Apart from functions, it works for **square-bracket lists** in dynamic languages:

``` python
list = [one, [two, four, five], three]
```

If you experiment with this example, you'll find that you can move the entire
second list around, as long as the cursor is on one of the inner brackets. The
plugin takes into consideration nested structures.

It also works for multiline lists. Try experimenting with this example:

``` html
<div class="example"
     style="color: red;"
     something="other">
  Example
</div>
```

It's highly recommended to map the two main commands to convenient keys. For
example, mapping them to `<c-h>` and `<c-l>` would look like this:
``` vim
nnoremap <c-h> :SidewaysLeft<cr>
nnoremap <c-l> :SidewaysRight<cr>
```

The plugin also provides the commands `:SidewaysJumpLeft` and
`:SidewaysJumpRight`, which move the cursor left and right by items.

Other things that sideways works for:

**CSS declarations**:
``` css
a { color: #fff; background: blue; text-decoration: underline; }
```

**Lists within CSS declarations**:
``` css
border-radius: 20px 0 0 20px;
```

**HTML attributes**:
``` html
<input name="one" id="two" class="three" />
```

**Handlebars components**:
``` handlebars
{{parent/some-component one=two three="four" five=(action 'six')}}
```

**Cucumber tables**:
``` cucumber
Examples:
  | input_1 | input_2 | button | output |
  | 20      | 30      | add    | 50     |
  | 2       | 5       | add    | 7      |
  | 0       | 40      | add    | 40     |
```

**Rust template arguments**:

``` rust
let dict = Hash<String, Vec<String>>::new();
```

**Rust return type** (a special case since there's always just one, useful as a text object):

``` rust
fn example() -> Result<String, String> {
```

**Go lists**:
``` go
[]string{"One", "Two", "Three"}
```

**C++ templates**:

``` cpp
/*
 * Relies on "<" being surrounded by non-whitespace, or considers it a
 * comparison. Parsing C++ is tricky.
 */
std::unordered_map<k, v>()
```

**Javascript-like objects**:
``` python
dict = {one: 1, two: 2, three: 3}
```

**OCaml lists**:
``` ocaml
let xs = [1;2;3]
```

The plugin is intended to be customizable, though at this point you'd need to
look at the source to do this.

## Bonus functionality

### Text objects

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

Also, a useful plugin to use alongside sideways is
[fieldtrip](https://github.com/tek/vim-fieldtrip). This defines a
[submode](https://github.com/kana/vim-submode) for sideways.vim.

### Adding items

The plugin defines mappings to add new items to the list as well. There's four of them that mirror the `i`, `a`, `I`, and `A` built-in keybindings:

```
<Plug>SidewaysArgumentInsertBefore
<Plug>SidewaysArgumentAppendAfter
<Plug>SidewaysArgumentInsertFirst
<Plug>SidewaysArgumentAppendLast
```

However, they're not mapped by default and you need to pick ones that are convenient for you. As an example:

``` vim
nmap <leader>si <Plug>SidewaysArgumentInsertBefore
nmap <leader>sa <Plug>SidewaysArgumentAppendAfter
nmap <leader>sI <Plug>SidewaysArgumentInsertFirst
nmap <leader>sA <Plug>SidewaysArgumentAppendLast
```

The mnemonic in this case would be `leader-"sideways"-action`. Given the following simple example in ruby:

``` ruby
function_call(one, two, three)
```

With the cursor on "two", you can insert a new argument before the current item by using `<Plug>SidewaysArgumentInsertBefore`:

``` ruby
function_call(one, NEW, two, three)
```

Add an item after the current one by using `<Plug>SidewaysArgumentAppendAfter`:

``` ruby
function_call(one, two, NEW, three)
```

Prepend an item to the start of the list with `<Plug>SidewaysArgumentInsertFirst`:

``` ruby
function_call(NEW, one, two, three)
```

Push an item at the end with `<Plug>SidewaysArgumentAppendLast`:

``` ruby
function_call(one, two, three, NEW)
```

This should work for all lists that are supported for the plugin, including HTML attributes, semicolon-separated CSS declarations, etc. If each existing list item is on a separate line (and there's at least two), the plugin assumes the new item should be on a new line as well:

``` ruby
function_call(
  one,
  two,
  three
)

# Append an item at the end:
function_call(
  one,
  two,
  three,
  NEW
)
```

Again, these mappings are not created by default -- copy the suggested ones to your vimrc, or create your own.

If you set `g:sideways_add_item_cursor_restore` to 1 and your vim has the `+textprop` feature, the plugin will jump back to where you triggered the mapping when you leave insert mode.

Note, however, that this relies on the `InsertLeave` autocommand, so if you exit insert mode via `Ctrl+C` (which doesn't trigger it), it won't jump until the next time you leave insert mode normally. If exiting via `Ctrl+C` is a part of your workflow, it's recommended you keep this setting off.
