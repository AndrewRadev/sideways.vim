require 'spec_helper'

describe "cpp lists" do
  let(:filename) { 'test.cpp' }

  specify "(lists)" do
    set_file_contents <<-EOF
      function_call(one<foo>(), two<bar>(), three<baz>())
    EOF

    vim.search('one')
    vim.right

    assert_file_contents <<-EOF
      function_call(two<bar>(), one<foo>(), three<baz>())
    EOF
  end

  specify "[lists]" do
    set_file_contents <<-EOF
      [one<foo>(), two<bar>(), three<baz>()];
    EOF

    vim.search('one')
    vim.right

    assert_file_contents <<-EOF
      [two<bar>(), one<foo>(), three<baz>()];
    EOF
  end

  specify "<lists>" do
    set_file_contents <<-EOF
      function_call<one<foo>, two, three>(something);
    EOF

    vim.search('one')
    vim.right

    assert_file_contents <<-EOF
      function_call<two, one<foo>, three>(something);
    EOF
  end

  specify "lists with templates including comparison" do
    set_file_contents <<-EOF
      function(1 < 2, std::unordered_map<k, v>(), arg);
    EOF

    vim.search('std::')
    vim.left

    assert_file_contents <<-EOF
      function(std::unordered_map<k, v>(), 1 < 2, arg);
    EOF
  end
end
