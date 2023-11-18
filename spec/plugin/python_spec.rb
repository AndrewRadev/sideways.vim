require 'spec_helper'

describe "python" do
  let(:filename) { 'test.py' }

  describe "functions" do
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

  describe "imports" do
    specify "basic import" do
      set_file_contents <<-EOF
        import foo, bar as b, baz
      EOF

      vim.search('foo')

      vim.left
      assert_file_contents <<-EOF
        import baz, bar as b, foo
      EOF

      vim.right
      assert_file_contents <<-EOF
        import foo, bar as b, baz
      EOF
    end

    specify "import with from" do
      set_file_contents <<-EOF
        from some_package import Foo, Bar
      EOF

      vim.search('Foo')

      vim.left
      assert_file_contents <<-EOF
        from some_package import Bar, Foo
      EOF

      vim.right
      assert_file_contents <<-EOF
        from some_package import Foo, Bar
      EOF
    end
  end

  describe "for loops" do
    specify "basic for loop" do
      set_file_contents <<-EOF
        for index, value in enumerate(items):
            pass
      EOF

      vim.search('index')

      vim.left
      assert_file_contents <<-EOF
        for value, index in enumerate(items):
            pass
      EOF

      vim.right
      assert_file_contents <<-EOF
        for index, value in enumerate(items):
            pass
      EOF
    end
  end
end
