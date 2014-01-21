require 'spec_helper'

describe "jumping" do
  let(:filename) { 'test.py' }

  before :each do
    set_file_contents <<-EOF
      def function(one, two, three):
          pass
    EOF

    vim.search('one')
  end

  specify "to the left" do
    vim.jump_left.normal('~').write
    assert_file_contents <<-EOF
      def function(one, two, Three):
          pass
    EOF

    vim.jump_left.normal('~').write
    assert_file_contents <<-EOF
      def function(one, Two, Three):
          pass
    EOF

    vim.jump_left.normal('~').write
    assert_file_contents <<-EOF
      def function(One, Two, Three):
          pass
    EOF
  end

  specify "to the right" do
    vim.jump_right.normal('~').write
    assert_file_contents <<-EOF
      def function(one, Two, three):
          pass
    EOF

    vim.jump_right.normal('~').write
    assert_file_contents <<-EOF
      def function(one, Two, Three):
          pass
    EOF

    vim.jump_right.normal('~').write
    assert_file_contents <<-EOF
      def function(One, Two, Three):
          pass
    EOF
  end
end
