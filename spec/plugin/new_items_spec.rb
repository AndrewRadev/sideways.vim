require 'spec_helper'

describe "adding new items" do
  describe "with commas" do
    let(:filename) { 'test.rb' }

    specify "insert before item" do
      set_file_contents <<~EOF
        function_call(one, two, three)
      EOF

      vim.search('t\zswo')
      vim.feedkeys ',ia'
      vim.feedkeys 'new'
      vim.write

      assert_file_contents <<~EOF
        function_call(one, new, two, three)
      EOF
    end

    specify "append after item" do
      set_file_contents <<~EOF
        function_call(one, two, three)
      EOF

      vim.search('t\zswo')
      vim.feedkeys ',aa'
      vim.feedkeys 'new'
      vim.write

      assert_file_contents <<~EOF
        function_call(one, two, new, three)
      EOF
    end

    specify "insert at start" do
      set_file_contents <<~EOF
        function_call(one, two, three)
      EOF

      vim.search('t\zswo')
      vim.feedkeys ',Ia'
      vim.feedkeys 'new'
      vim.write

      assert_file_contents <<~EOF
        function_call(new, one, two, three)
      EOF
    end

    specify "append at end" do
      set_file_contents <<~EOF
        function_call(one, two, three)
      EOF

      # At end of list
      vim.search('t\zswo')
      vim.feedkeys ',Aa'
      vim.feedkeys 'new'
      vim.write

      assert_file_contents <<~EOF
        function_call(one, two, three, new)
      EOF
    end
  end

  describe "with spaces" do
    let(:filename) { 'test.html' }

    specify "insert before item" do
      set_file_contents <<~EOF
        <div one="1" two="2" three="3"></div>
      EOF

      vim.search('two')
      vim.feedkeys ',ia'
      vim.feedkeys 'new="N"'
      vim.write

      assert_file_contents <<~EOF
        <div one="1" new="N" two="2" three="3"></div>
      EOF
    end
  end
end
