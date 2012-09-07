require 'spec_helper'

describe "python functions" do
  let(:filename) { 'test.py' }

  before :each do
    set_file_contents <<-EOF
      def function(one, two, three):
          pass
    EOF

    vim.search('one')
  end

  specify "to the left" do
    vim.left
    assert_file_contents <<-EOF
      def function(three, two, one):
          pass
    EOF

    vim.left
    assert_file_contents <<-EOF
      def function(three, one, two):
          pass
    EOF

    vim.left
    assert_file_contents <<-EOF
      def function(one, three, two):
          pass
    EOF
  end

  specify "to the right" do
    vim.right
    assert_file_contents <<-EOF
      def function(two, one, three):
          pass
    EOF

    vim.right
    assert_file_contents <<-EOF
      def function(two, three, one):
          pass
    EOF

    vim.right
    assert_file_contents <<-EOF
      def function(one, three, two):
          pass
    EOF
  end

  specify "incomplete function call" do
    set_file_contents <<-EOF
      def function(one, two, three
          pass
    EOF

    vim.search('one')
    vim.right
    assert_file_contents <<-EOF
      def function(two, one, three
          pass
    EOF
  end

  specify "extra whitespace" do
    set_file_contents <<-EOF
      def function( one, two, three ):
          pass
    EOF

    vim.search('one')
    vim.right
    assert_file_contents <<-EOF
      def function( two, one, three ):
          pass
    EOF
  end

  specify "complicated function call" do
    set_file_contents <<-EOF
      foo(bar, baz(foobar(), foobaz))
    EOF

    vim.search('bar')
    vim.right

    assert_file_contents <<-EOF
      foo(baz(foobar(), foobaz), bar)
    EOF
  end
end
