require 'spec_helper'

describe "textobj mapping" do
  let(:filename) { 'test.py' }

  before :each do
    set_file_contents <<-EOF
      def func(one, two, three):
        pass
    EOF
  end

  specify "first argument" do
    vim.search('one')
    vim.feedkeys 'daa'
    vim.write

    assert_file_contents <<-EOF
      def func(two, three):
        pass
    EOF

    vim.feedkeys 'ciachanged'
    vim.write

    assert_file_contents <<-EOF
      def func(changed, three):
        pass
    EOF
  end

  specify "delete middle argument" do
    vim.search('two')
    vim.feedkeys 'daa'
    vim.write

    assert_file_contents <<-EOF
      def func(one, three):
        pass
    EOF
  end

  specify "change middle argument" do
    vim.search('two')
    vim.feedkeys 'ciachanged'
    vim.write

    assert_file_contents <<-EOF
      def func(one, changed, three):
        pass
    EOF
  end

  specify "last argument" do
    vim.search('three')
    vim.feedkeys 'daa'
    vim.write

    assert_file_contents <<-EOF
      def func(one, two):
        pass
    EOF

    vim.feedkeys 'ciachanged'
    vim.write

    assert_file_contents <<-EOF
      def func(one, changed):
        pass
    EOF
  end
end
