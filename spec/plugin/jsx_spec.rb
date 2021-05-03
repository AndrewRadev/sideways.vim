require 'spec_helper'

describe "JSX attributes" do
  describe "simple" do
    let(:filename) { 'test.jsx' }

    before :each do
      set_file_contents <<-EOF
        <Component.Name data-one data-two data-three />
      EOF

      vim.set 'filetype', 'javascriptreact'
      vim.search('data-one')
    end

    specify "to the left" do
      assert_file_contents <<-EOF
        <Component.Name data-one data-two data-three />
      EOF

      vim.left
      assert_file_contents <<-EOF
        <Component.Name data-three data-two data-one />
      EOF

      vim.left
      assert_file_contents <<-EOF
        <Component.Name data-three data-one data-two />
      EOF
    end

    specify "to the right" do
      assert_file_contents <<-EOF
        <Component.Name data-one data-two data-three />
      EOF

      vim.right
      assert_file_contents <<-EOF
        <Component.Name data-two data-one data-three />
      EOF

      vim.right
      assert_file_contents <<-EOF
        <Component.Name data-two data-three data-one />
      EOF
    end
  end
end
