require 'spec_helper'

describe "curly-bracketed lists/dictionaries" do
  let(:filename) { 'test.py' }

  specify "simple case" do
    set_file_contents <<-EOF
      foo = {one: 1, two: 2, three: 3}
    EOF

    vim.search('one')
    vim.right
    assert_file_contents <<-EOF
      foo = {two: 2, one: 1, three: 3}
    EOF

    vim.left
    assert_file_contents <<-EOF
      foo = {one: 1, two: 2, three: 3}
    EOF
  end
end
