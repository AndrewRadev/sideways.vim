require 'spec_helper'

describe "ruby" do
  let(:filename) { 'test.rb' }

  describe "methods" do
    describe "basic" do
      before :each do
        set_file_contents <<-EOF
          link_to 'Something', user_registration_path
        EOF

        vim.search('Something')
      end

      specify "to the left" do
        vim.left
        assert_file_contents <<-EOF
          link_to user_registration_path, 'Something'
        EOF

        vim.left
        assert_file_contents <<-EOF
          link_to 'Something', user_registration_path
        EOF
      end

      specify "to the right" do
        vim.right
        assert_file_contents <<-EOF
          link_to user_registration_path, 'Something'
        EOF

        vim.right
        assert_file_contents <<-EOF
          link_to 'Something', user_registration_path
        EOF
      end
    end

    specify "when given do blocks" do
      set_file_contents <<-EOF
        link_to 'Something', user_registration_path do |x|
          # ...
        end
      EOF

      vim.search('Something')

      vim.right
      assert_file_contents <<-EOF
        link_to user_registration_path, 'Something' do |x|
          # ...
        end
      EOF
    end

    specify "with an extra closing bracket" do
      set_file_contents <<-EOF
        foo = (link_to 'Something', user_registration_path)
      EOF

      vim.search('Something')

      vim.right
      assert_file_contents <<-EOF
        foo = (link_to user_registration_path, 'Something')
      EOF
    end

    specify "ending in a comment" do
      set_file_contents <<-EOF
        link_to '#Something', user_registration_path # comment
      EOF

      vim.search('Something')

      vim.right
      assert_file_contents <<-EOF
        link_to user_registration_path, '#Something' # comment
      EOF
    end

    specify "with a multi-word string" do
      set_file_contents <<-EOF
        link_to 'Something Else', user_registration_path
      EOF

      vim.search('Else')

      vim.right
      assert_file_contents <<-EOF
        link_to user_registration_path, 'Something Else'
      EOF
    end

    specify "multiline" do
      set_file_contents <<-EOF
        function_call(one, two,
                      three, four)
      EOF

      vim.search('three')

      vim.left
      assert_file_contents <<-EOF
        function_call(one, three,
                      two, four)
      EOF
    end
  end

  describe "lists" do
    specify "handles items with string delimiters" do
      set_file_contents <<-EOF
        method_call [%w[one two], %w[three]], four
      EOF

      vim.search('%w[one')
      vim.left

      assert_file_contents <<-EOF
        method_call [%w[three], %w[one two]], four
      EOF

      vim.search('[%w[')
      vim.left

      assert_file_contents <<-EOF
        method_call four, [%w[three], %w[one two]]
      EOF
    end
  end
end
