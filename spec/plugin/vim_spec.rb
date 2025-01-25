require 'spec_helper'

describe "Vimscript" do
  let(:filename) { 'test.vim' }

  specify "settings" do
    set_file_contents <<~EOF
      set spelllang=en,bg,programming
    EOF

    vim.search('bg')
    vim.right

    assert_file_contents <<~EOF
      set spelllang=en,programming,bg
    EOF

    vim.right

    assert_file_contents <<~EOF
      set spelllang=bg,programming,en
    EOF
  end
end
