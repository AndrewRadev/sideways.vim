require 'spec_helper'

describe "elixir" do
  let(:filename) { 'test.ex' }

  describe "methods" do
    describe "basic" do
      before :each do
        set_file_contents <<-EOF
          String.ends_with? "Period.", "."
        EOF

        vim.search('Period')
      end

      specify "to the left" do
        vim.left
        assert_file_contents <<-EOF
          String.ends_with? ".", "Period."
        EOF

        vim.left
        assert_file_contents <<-EOF
          String.ends_with? "Period.", "."
        EOF
      end

      specify "to the right" do
        vim.right
        assert_file_contents <<-EOF
          String.ends_with? ".", "Period."
        EOF

        vim.right
        assert_file_contents <<-EOF
          String.ends_with? "Period.", "."
        EOF
      end
    end

    specify "when given do blocks" do
      set_file_contents <<-EOF
        if String.ends_with? "Period.", "." do
          # ...
        end
      EOF

      vim.search('Period')

      vim.right
      assert_file_contents <<-EOF
        if String.ends_with? ".", "Period." do
          # ...
        end
      EOF
    end

    specify "with an extra closing bracket" do
      set_file_contents <<-EOF
        ok = (String.ends_with? ".", "Period.")
      EOF

      vim.search('Period')

      vim.right
      assert_file_contents <<-EOF
        ok = (String.ends_with? "Period.", ".")
      EOF
    end

    specify "ending in a comment" do
      set_file_contents <<-EOF
        String.ends_with? "#Period.", "." # comment
      EOF

      vim.search('Period')

      vim.right
      assert_file_contents <<-EOF
        String.ends_with? ".", "#Period." # comment
      EOF
    end
  end
end
