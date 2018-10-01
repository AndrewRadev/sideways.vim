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

  describe "java" do
    let(:filename) { 'test.java' }

    # See https://github.com/AndrewRadev/sideways.vim/issues/24
    specify "unbalanced brackets in strings" do
      set_file_contents <<-EOF
        Debug.Log(string.Format("1) Item: {0}"), item);
      EOF

      vim.search('item')
      vim.right

      assert_file_contents <<-EOF
        Debug.Log(item, string.Format("1) Item: {0}"));
      EOF
    end

    # See https://github.com/AndrewRadev/sideways.vim/issues/24
    specify "escaped quotes" do
      set_file_contents <<-EOF
        Debug.Log(string.Format("1\\" Item: {0}"), item);
      EOF

      vim.search('item')
      vim.right

      assert_file_contents <<-EOF
        Debug.Log(item, string.Format("1\\" Item: {0}"));
      EOF
    end

    # See https://github.com/AndrewRadev/sideways.vim/issues/24
    specify "empty quotes" do
      set_file_contents <<-EOF
        Debug.Log(
          "",
          one,
          two);
        return "";
      EOF

      vim.search('one')
      vim.left

      assert_file_contents <<-EOF
        Debug.Log(
          one,
          "",
          two);
        return "";
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

    specify "delimiters on next line" do
      set_file_contents <<-EOF
        foo = [ one
              , two
              , three
              ]
      EOF

      vim.search('two')
      vim.left

      assert_file_contents <<-EOF
      foo = [ two
            , one
            , three
            ]
      EOF
    end
  end

  describe "javascript" do
    let(:filename) { 'test.js' }

    # See https://github.com/AndrewRadev/sideways.vim/issues/31
    specify "empty () after opening (" do
      set_file_contents <<-EOF
        foo(() => { bar(baz); }, qwe);
      EOF

      vim.search('qwe')
      vim.left

      assert_file_contents <<-EOF
        foo(qwe, () => { bar(baz); });
      EOF
    end
  end
end
