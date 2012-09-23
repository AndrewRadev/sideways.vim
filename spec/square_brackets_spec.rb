require 'spec_helper'

describe "square-bracketed lists" do
  let(:filename) { 'test.py' }

  specify "simple case" do
    set_file_contents <<-EOF
      foo = [one, two, three]
    EOF

    vim.search('one')
    vim.right
    assert_file_contents <<-EOF
      foo = [two, one, three]
    EOF

    vim.left
    assert_file_contents <<-EOF
      foo = [one, two, three]
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
end
