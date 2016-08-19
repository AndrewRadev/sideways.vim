require 'spec_helper'

describe "square-bracketed lists" do
  let(:filename) { 'test.py' }

  specify "simple case" do
    set_file_contents <<-EOF
      foo = [1, 2, 3]
    EOF

    vim.search('1')
    vim.right
    assert_file_contents <<-EOF
      foo = [2, 1, 3]
    EOF

    vim.search('1')
    vim.right
    assert_file_contents <<-EOF
      foo = [2, 3, 1]
    EOF

    vim.left
    assert_file_contents <<-EOF
      foo = [2, 1, 3]
    EOF
  end

  specify "with strings" do
    set_file_contents <<-EOF
      foo = ['one', 'two', 'three']
    EOF

    vim.search('one')
    vim.right
    assert_file_contents <<-EOF
      foo = ['two', 'one', 'three']
    EOF

    vim.left
    assert_file_contents <<-EOF
      foo = ['one', 'two', 'three']
    EOF
  end

  specify "multiline" do
    set_file_contents <<-EOF
      foo = [
        one, two,
        three, four
      ]
    EOF

    vim.search('four')
    vim.right
    assert_file_contents <<-EOF
      foo = [
        four, two,
        three, one
      ]
    EOF
  end
end
