require 'spec_helper'

describe "haskell" do
  let(:filename) { 'test.hs' }

  specify "function type definition" do
    set_file_contents <<-EOF
      function :: X -> Y -> Integer
      function x y = 13
    EOF

    vim.search('X')
    vim.right
    assert_file_contents <<-EOF
      function :: Y -> X -> Integer
      function x y = 13
    EOF

    vim.left
    assert_file_contents <<-EOF
      function :: X -> Y -> Integer
      function x y = 13
    EOF
  end

  specify "lambda function arguments" do
    set_file_contents <<-EOF
      let l = \\x y z -> 13
    EOF

    vim.search('x')
    vim.right
    assert_file_contents <<-EOF
      let l = \\y x z -> 13
    EOF

    vim.right
    assert_file_contents <<-EOF
      let l = \\y z x -> 13
    EOF

    vim.right
    assert_file_contents <<-EOF
      let l = \\x z y -> 13
    EOF
  end

  specify "function definitions" do
    set_file_contents <<-EOF
      add x y = x + y
    EOF

    vim.search('add \zsx')
    vim.right
    assert_file_contents <<-EOF
      add y x = x + y
    EOF

    vim.right
    assert_file_contents <<-EOF
      add x y = x + y
    EOF
  end
end
