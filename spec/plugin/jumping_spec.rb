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

  specify "with a count" do
    vim.jump_right(2).normal('~').write
    assert_file_contents <<-EOF
      def function(one, two, Three):
          pass
    EOF

    # TODO (2014-03-09) Operators? Would make more sense when there are
    # default mappings to avoid leaking knowledge of temporary maps in here
  end
end
