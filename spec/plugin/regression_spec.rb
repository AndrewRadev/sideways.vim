require 'spec_helper'

describe "regression tests" do
  describe "python" do
    let(:filename) { 'test.py' }

    specify "brackets inside parentheses" do
      # See https://github.com/AndrewRadev/sideways.vim/issues/4
      set_file_contents <<-EOF
        foo([ 'bar', 'baz', 'quux' ])
      EOF

      vim.search('baz')
      vim.left

      assert_file_contents <<-EOF
        foo([ 'baz', 'bar', 'quux' ])
      EOF
    end
  end

  describe "coffee" do
    let(:filename) { 'test.coffee' }

    specify "nested curly brackets" do
      set_file_contents <<-EOF
        foo = { one: two, three: { four: five } }
      EOF

      vim.search('three')
      vim.left

      assert_file_contents <<-EOF
        foo = { three: { four: five }, one: two }
      EOF
    end
  end

  describe "ruby" do
    let(:filename) { 'test.rb' }

    specify "default arguments" do
      set_file_contents <<-EOF
        def initialize(attributes = {}, options = {})
      EOF

      vim.search('options')
      vim.left

      assert_file_contents <<-EOF
        def initialize(options = {}, attributes = {})
      EOF
    end
  end
end
