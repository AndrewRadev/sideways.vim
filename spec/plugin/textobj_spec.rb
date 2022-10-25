require 'spec_helper'

describe "textobj mapping" do
  describe "single-line" do
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

    specify "delete before argument" do
      vim.search(' two')
      vim.feedkeys 'daa'
      vim.write

      assert_file_contents <<-EOF
        def func(one, three):
          pass
      EOF

      vim.search(' three')
      vim.feedkeys 'daa'
      vim.write

      assert_file_contents <<-EOF
        def func(one):
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

      vim.search('two')
      vim.feedkeys 'ciachanged'
      vim.write

      assert_file_contents <<-EOF
        def func(one, changed):
          pass
      EOF
    end
  end

  describe "multiline" do
    let(:filename) { 'test.js' }

    specify "outer argument, with two items on second line" do
      set_file_contents <<-EOF
        function(one, two,
          three, four) { }
      EOF

      vim.search('three,')
      vim.feedkeys 'daa'
      vim.write

      assert_file_contents <<-EOF
        function(one, two,
          four) { }
      EOF
    end

    specify "outer argument, with one item on second line" do
      set_file_contents <<-EOF
        function(one, two,
          three) { }
      EOF

      vim.search('three)')
      vim.feedkeys 'daa'
      vim.write

      assert_file_contents <<-EOF
        function(one, two) { }
      EOF
    end
  end

  describe "prefix delimiters" do
    let(:filename) { 'test.rb' }

    after :each do
      vim.command('set selection&')
    end

    it "works in selection=inclusive mode" do
      vim.command('set selection=inclusive')

      set_file_contents <<-EOF
        ( ab
        , cd
        , ef
        )
      EOF

      vim.search('cd')
      vim.feedkeys 'daa'
      vim.write

      assert_file_contents <<-EOF
        ( ab
        , ef
        )
      EOF
    end

    it "works in selection=exclusive mode" do
      vim.command('set selection=exclusive')

      set_file_contents <<-EOF
        ( ab
        , cd
        , ef
        )
      EOF

      vim.search('cd')
      vim.feedkeys 'daa'
      vim.write

      assert_file_contents <<-EOF
        ( ab
        , ef
        )
      EOF
    end
  end
end
