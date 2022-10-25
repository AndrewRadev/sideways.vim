require 'spec_helper'

describe "LaTeX support" do
  let(:filename) { 'test.tex' }

  specify "tabular" do
    set_file_contents <<-EOF
      \\begin{tabular}{ll}
        a & b \\\\
        c & d
      \\end{tabular}
    EOF
    vim.command('set filetype=tex')

    vim.search('a &')
    vim.right

    assert_file_contents <<-EOF
      \\begin{tabular}{ll}
        b & a \\\\
        c & d
      \\end{tabular}
    EOF
  end

  specify "equations" do
    set_file_contents <<-EOF
      \\[ e^{i \\pi} + 1 = 0 \\]
    EOF
    vim.command('set filetype=tex')

    vim.search('e^')
    vim.right

    assert_file_contents <<-EOF
      \\[ 1 = 0 + e^{i \\pi} \\]
    EOF
  end
end
