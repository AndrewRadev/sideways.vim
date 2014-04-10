require 'spec_helper'

describe "haml" do
  let(:filename) { 'test.haml' }

  before :each do
    set_file_contents <<-EOF
      def function(one, two, three):
          pass
    EOF

    vim.search('one')
  end

  specify "classes" do
    set_file_contents <<-EOF
      %.one.two.three{four: 'five}
    EOF

    vim.search('one').right
    assert_file_contents <<-EOF
      %.two.one.three{four: 'five}
    EOF

    vim.right
    assert_file_contents <<-EOF
      %.two.three.one{four: 'five}
    EOF

    vim.right
    assert_file_contents <<-EOF
      %.one.three.two{four: 'five}
    EOF
  end
end
