require 'spec_helper'

describe "Markdown" do
  let(:filename) { 'test.markdown' }

  specify "basic tables" do
    set_file_contents <<~EOF
      | One | Two | Three |
    EOF

    vim.search 'Two'
    vim.right

    assert_file_contents <<~EOF
      | One | Three | Two |
    EOF

    vim.right
    assert_file_contents <<~EOF
      | Two | Three | One |
    EOF
  end

  specify "table with an empty space" do
    set_file_contents <<~EOF
      | One |     | Three |
    EOF

    vim.search 'One'
    vim.right

    assert_file_contents <<~EOF
      |     | One | Three |
    EOF
  end

  specify "table with a markdown link" do
    set_file_contents <<~EOF
      | One | [Two|Four](https://foo) | Three |
    EOF

    vim.search 'One'
    vim.right

    assert_file_contents <<~EOF
      | [Two|Four](https://foo) | One | Three |
    EOF
  end
end
