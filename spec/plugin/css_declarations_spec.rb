require 'spec_helper'

describe "css declarations" do
  let(:filename) { 'test.css' }

  describe "basic" do
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

  describe "multiline" do
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
end
