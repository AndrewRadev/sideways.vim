require 'spec_helper'

describe "regression tests" do
  let(:filename) { 'test.py' }

  specify "brackets inside parentheses" do
    # See https://github.com/AndrewRadev/sideways.vim/issues/4
    set_file_contents <<-EOF
      foo([ 'bar', 'baz', 'quux' ])
    EOF

    vim.search('baz')
    vim.left

    assert_file_contents <<-EOF
      foo([ 'baz', 'bar', 'quux' ])
    EOF
  end
end
