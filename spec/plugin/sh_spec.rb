require 'spec_helper'

describe "shell scripts" do
  let(:filename) { 'test.sh' }

  specify "simple case" do
    set_file_contents <<-EOF
      command subcommand --one --two=three -- filename | vim - -R
    EOF

    vim.search('subcommand')
    vim.right
    assert_file_contents <<-EOF
      command --one subcommand --two=three -- filename | vim - -R
    EOF

    vim.search('subcommand')
    vim.left
    assert_file_contents <<-EOF
      command subcommand --one --two=three -- filename | vim - -R
    EOF

    vim.search('subcommand')
    vim.left
    assert_file_contents <<-EOF
      command filename --one --two=three -- subcommand | vim - -R
    EOF
  end
end
