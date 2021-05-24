require 'spec_helper'

describe "ERB" do
  let(:filename) { 'test.erb' }

  describe "methods" do
    describe "basic" do
      before :each do
        set_file_contents <<-EOF
          <div><%= link_to 'Something', user_registration_path %></div>
        EOF

        vim.search('Something')
      end

      specify "to the left" do
        vim.left
        assert_file_contents <<-EOF
          <div><%= link_to user_registration_path, 'Something' %></div>
        EOF

        vim.left
        assert_file_contents <<-EOF
          <div><%= link_to 'Something', user_registration_path %></div>
        EOF
      end

      specify "to the right" do
        vim.right
        assert_file_contents <<-EOF
          <div><%= link_to user_registration_path, 'Something' %></div>
        EOF

        vim.right
        assert_file_contents <<-EOF
          <div><%= link_to 'Something', user_registration_path %></div>
        EOF
      end
    end
  end
end
