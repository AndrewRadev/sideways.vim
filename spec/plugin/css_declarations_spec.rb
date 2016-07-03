require 'spec_helper'

describe "css" do
  let(:filename) { 'test.css' }

  describe "declarations (single-line)" do
    before :each do
      set_file_contents <<-EOF
        a { color: #fff; background: blue; text-decoration: underline; }
      EOF

      vim.search('color')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        a { text-decoration: underline; background: blue; color: #fff; }
      EOF

      vim.left
      assert_file_contents <<-EOF
        a { text-decoration: underline; color: #fff; background: blue; }
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        a { background: blue; color: #fff; text-decoration: underline; }
      EOF

      vim.right
      assert_file_contents <<-EOF
        a { background: blue; text-decoration: underline; color: #fff; }
      EOF
    end
  end

  describe "declarations (multiline)" do
    before :each do
      set_file_contents <<-EOF
        a {
          color: #fff;
          background: blue;
        }
      EOF

      vim.search('color')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        a {
          background: blue;
          color: #fff;
        }
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        a {
          background: blue;
          color: #fff;
        }
      EOF
    end
  end

  describe "lists within declarations" do
    before :each do
      set_file_contents <<-EOF
        border-radius: 20px 0 0 20px;
      EOF

      vim.search('20px')
    end

    specify "to the left" do
      vim.left
      vim.left
      assert_file_contents <<-EOF
        border-radius: 20px 0 20px 0;
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        border-radius: 0 20px 0 20px;
      EOF
    end
  end
end
