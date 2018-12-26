require 'spec_helper'

describe "python imports" do
  let(:filename) { 'test.py' }

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
