require 'spec_helper'

describe "handlebars components" do
  let(:filename) { 'test.hbs' }

  before :each do
    set_file_contents <<-EOF
      {{parent/some-component one=two three="four" five=(action 'six')}}
    EOF

    vim.set 'filetype', 'html.handlebars'
    vim.search('\<one\>')
  end

  specify "to the left" do
    vim.left
    assert_file_contents <<-EOF
      {{parent/some-component five=(action 'six') three="four" one=two}}
    EOF

    vim.left
    assert_file_contents <<-EOF
      {{parent/some-component five=(action 'six') one=two three="four"}}
    EOF
  end

  specify "to the right" do
    vim.right
    assert_file_contents <<-EOF
      {{parent/some-component three="four" one=two five=(action 'six')}}
    EOF

    vim.right
    assert_file_contents <<-EOF
      {{parent/some-component three="four" five=(action 'six') one=two}}
    EOF
  end
end
