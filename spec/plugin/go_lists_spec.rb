require 'spec_helper'

describe "go lists" do
  let(:filename) { 'test.go' }

  describe "simple" do
    before :each do
      set_file_contents <<-EOF
        []string{"One", "Two", "Three"}
      EOF

      vim.set 'filetype', 'go'
      vim.search('One')
    end

    specify "to the left" do
      assert_file_contents <<-EOF
        []string{"One", "Two", "Three"}
      EOF

      vim.left
      assert_file_contents <<-EOF
        []string{"Three", "Two", "One"}
      EOF

      vim.left
      assert_file_contents <<-EOF
        []string{"Three", "One", "Two"}
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        []string{"Two", "One", "Three"}
      EOF

      vim.right
      assert_file_contents <<-EOF
        []string{"Two", "Three", "One"}
      EOF
    end
  end

  specify "multiline" do
    set_file_contents <<-EOF
      []string{"One", "Two",
        "Three"}
    EOF

    vim.set 'filetype', 'go'
    vim.search('Two')
    vim.right
    assert_file_contents <<-EOF
      []string{"One", "Three",
        "Two"}
    EOF
  end
end
