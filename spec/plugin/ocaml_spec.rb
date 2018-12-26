require 'spec_helper'

describe "ocaml lists" do
  let(:filename) { 'test.ml' }

  specify "[lists]" do
    set_file_contents <<-EOF
      let xs = [1;2;3]
    EOF

    vim.search('2')
    vim.right

    assert_file_contents <<-EOF
      let xs = [1;3;2]
    EOF
  end

  specify "[|arrays|]" do
    set_file_contents <<-EOF
      let xs = [|1;2;3|]
    EOF

    vim.search('2')
    vim.right

    assert_file_contents <<-EOF
      let xs = [|1;3;2|]
    EOF
  end

  specify "[|arrays with tuples|]" do
    set_file_contents <<-EOF
      let xs = [|1, 2; 3, 4|]
    EOF

    vim.search('2')
    vim.right

    assert_file_contents <<-EOF
      let xs = [|3, 4; 1, 2|]
    EOF
  end
end
