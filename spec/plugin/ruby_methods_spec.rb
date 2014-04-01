require 'spec_helper'

describe "ruby methods" do
  let(:filename) { 'test.rb' }

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
end
