require 'spec_helper'

describe "multi-line args" do
  let(:filename) { 'test.rb' }

  specify "a single argument on multiple lines" do
    set_file_contents <<-EOF
      function_call(one, two, three(
        "four", "five"
      ), six)
    EOF

    vim.search 'two'
    vim.right

    assert_file_contents <<-EOF
      function_call(one, three(
        "four", "five"
      ), two, six)
    EOF

    vim.left

    assert_file_contents <<-EOF
      function_call(one, two, three(
        "four", "five"
      ), six)
    EOF
  end

  specify "the last argument, on multiple lines" do
    set_file_contents <<-EOF
      function_call(one, two, six, three(
        "four", "five"
      ))
    EOF

    vim.search 'six'
    vim.right

    assert_file_contents <<-EOF
      function_call(one, two, three(
        "four", "five"
      ), six)
    EOF

    vim.left

    assert_file_contents <<-EOF
      function_call(one, two, six, three(
        "four", "five"
      ))
    EOF
  end
end
