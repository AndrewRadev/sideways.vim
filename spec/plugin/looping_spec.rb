require 'spec_helper'

describe "looping" do
  let(:filename) { 'test.py' }

  describe "jumping" do
    before :each do
      set_file_contents <<-EOF
        def function(one, two, three):
            pass
      EOF
    end

    after :each do
      vim.command('let g:sideways_loop_jump = 1')
    end

    specify "active by default" do
      vim.search('one')
      vim.jump_left.normal('~').write
      assert_file_contents <<-EOF
        def function(one, two, Three):
            pass
      EOF

      vim.jump_right.normal('~').write
      assert_file_contents <<-EOF
        def function(One, two, Three):
            pass
      EOF
    end

    specify "can be disabled" do
      vim.command('let g:sideways_loop_jump = 0')

      vim.search('one')
      vim.jump_left.normal('~').write
      assert_file_contents <<-EOF
        def function(One, two, three):
            pass
      EOF

      vim.search('three')
      vim.jump_right.normal('~').write
      assert_file_contents <<-EOF
        def function(One, two, Three):
            pass
      EOF

      vim.jump_left.normal('~').write
      assert_file_contents <<-EOF
        def function(One, Two, Three):
            pass
      EOF
    end
  end

  describe "moving" do
    before :each do
      set_file_contents <<-EOF
        def function(one, two, three):
            pass
      EOF
    end

    after :each do
      vim.command('let g:sideways_loop_move = 1')
    end

    specify "active by default" do
      vim.search('one')
      vim.left.write
      assert_file_contents <<-EOF
        def function(three, two, one):
            pass
      EOF

      vim.right.write
      assert_file_contents <<-EOF
        def function(one, two, three):
            pass
      EOF
    end

    specify "can be disabled" do
      vim.command('let g:sideways_loop_move = 0')

      vim.search('one')
      vim.left.write
      assert_file_contents <<-EOF
        def function(one, two, three):
            pass
      EOF

      vim.search('three')
      vim.right.write
      assert_file_contents <<-EOF
        def function(one, two, three):
            pass
      EOF

      vim.search('two')
      vim.right.write
      assert_file_contents <<-EOF
        def function(one, three, two):
            pass
      EOF
    end
  end
end
