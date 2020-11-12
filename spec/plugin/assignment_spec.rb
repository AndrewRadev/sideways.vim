require 'spec_helper'

describe "variable assignment" do
  let(:filename) { 'test.rb' }

  specify "left-hand side" do
    set_file_contents <<-EOF
      one, two, three = 1, 2, 3
    EOF

    vim.search('one')
    vim.right

    assert_file_contents <<-EOF
      two, one, three = 1, 2, 3
    EOF

    vim.search('two')
    vim.left

    assert_file_contents <<-EOF
      three, one, two = 1, 2, 3
    EOF
  end

  specify "right-hand side" do
    set_file_contents <<-EOF
      one, two, three = 1, 2, 3
    EOF

    vim.search('1')
    vim.right

    assert_file_contents <<-EOF
      one, two, three = 2, 1, 3
    EOF

    vim.search('2')
    vim.left

    assert_file_contents <<-EOF
      one, two, three = 3, 1, 2
    EOF
  end
end
