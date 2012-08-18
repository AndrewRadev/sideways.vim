require 'spec_helper'

describe "python functions" do
  let(:filename) { 'test.py' }

  before :each do
    set_file_contents <<-EOF
      def function(one, two, three):
          pass
    EOF

    VIM.search('one')
  end

  specify "to the left" do
    VIM.left
    assert_file_contents <<-EOF
      def function(three, two, one):
          pass
    EOF

    VIM.left
    assert_file_contents <<-EOF
      def function(three, one, two):
          pass
    EOF

    VIM.left
    assert_file_contents <<-EOF
      def function(one, three, two):
          pass
    EOF
  end

  specify "to the right" do
    VIM.right
    assert_file_contents <<-EOF
      def function(two, one, three):
          pass
    EOF

    VIM.right
    assert_file_contents <<-EOF
      def function(two, three, one):
          pass
    EOF

    VIM.right
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

    VIM.search('one')
    VIM.right
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

    VIM.search('one')
    VIM.right
    assert_file_contents <<-EOF
      def function( two, one, three ):
          pass
    EOF
  end
end
