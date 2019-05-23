require 'spec_helper'

describe "jumping" do
  let(:filename) { 'test.py' }

  before :each do
    set_file_contents <<-EOF
      def function(one, two, three, four):
          pass
    EOF

    vim.search('one')
  end

  specify "to the left" do
    vim.jump_left.normal('~').write
    assert_file_contents <<-EOF
      def function(one, two, three, Four):
          pass
    EOF

    vim.jump_left.normal('~').write
    assert_file_contents <<-EOF
      def function(one, two, Three, Four):
          pass
    EOF

    vim.jump_left.normal('~').write
    assert_file_contents <<-EOF
      def function(one, Two, Three, Four):
          pass
    EOF
  end

  specify "to the right" do
    vim.jump_right.normal('~').write
    assert_file_contents <<-EOF
      def function(one, Two, three, four):
          pass
    EOF

    vim.jump_right.normal('~').write
    assert_file_contents <<-EOF
      def function(one, Two, Three, four):
          pass
    EOF

    vim.jump_right.jump_right.normal('~').write
    assert_file_contents <<-EOF
      def function(One, Two, Three, four):
          pass
    EOF
  end

  describe "with a count" do
    # TODO (2014-03-09) Operators? Would make more sense when there are
    # default mappings to avoid leaking knowledge of temporary maps in here

    specify "in normal mode" do
      vim.jump_right(2).normal('~').write
      assert_file_contents <<-EOF
        def function(one, two, Three, four):
            pass
      EOF

      vim.jump_right(3).normal('~').write
      assert_file_contents <<-EOF
        def function(one, Two, Three, four):
            pass
      EOF
    end

    specify "in visual mode" do
      vim.search('one')
      vim.feedkeys('v')
      vim.jump_right(2).feedkeys('e~')
      vim.write
      assert_file_contents <<-EOF
        def function(ONE, TWO, THREE, four):
            pass
      EOF
    end
  end
end
