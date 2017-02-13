require 'spec_helper'

describe "handlebars components" do
  let(:filename) { 'test.hbs' }

  describe "basic" do
    before :each do
      set_file_contents <<-EOF
        {{parent/some-component one=two three="four"
          five=(action 'six') seven='eight'}}
      EOF

      vim.set 'filetype', 'html.handlebars'
      vim.search('\<one\>')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        {{parent/some-component seven='eight' three="four"
          five=(action 'six') one=two}}
      EOF

      vim.left
      assert_file_contents <<-EOF
        {{parent/some-component seven='eight' three="four"
          one=two five=(action 'six')}}
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        {{parent/some-component three="four" one=two
          five=(action 'six') seven='eight'}}
      EOF

      vim.right
      assert_file_contents <<-EOF
        {{parent/some-component three="four" five=(action 'six')
          one=two seven='eight'}}
      EOF
    end
  end

  specify "components with quoted properties" do
    set_file_contents <<-EOF
      {{parent/some-component one 'two' three}}
    EOF

    vim.set 'filetype', 'html.handlebars'
    vim.search('\<one\>')
    vim.right

    assert_file_contents <<-EOF
      {{parent/some-component 'two' one three}}
    EOF

    vim.left
    assert_file_contents <<-EOF
      {{parent/some-component one 'two' three}}
    EOF
  end
end
