require 'spec_helper'

describe "rust" do
  let(:filename) { 'test.rs' }

  describe "single-line lambdas as function call arguments" do
    before :each do
      set_file_contents <<-EOF
        function_call(|x| x.to_string(), y)
      EOF

      vim.set 'filetype', 'rust'
      vim.search('|x|')
    end

    specify "to the left" do
      vim.left

      assert_file_contents <<-EOF
        function_call(y, |x| x.to_string())
      EOF
    end

    specify "to the right" do
      vim.right

      assert_file_contents <<-EOF
        function_call(y, |x| x.to_string())
      EOF
    end
  end

  describe "multiline lambdas as function call arguments" do
    before :each do
      set_file_contents <<-EOF
        function_call(|x, z| {
          x.to_string()
        }, y)
      EOF

      vim.set 'filetype', 'rust'
      vim.search('|x')
    end

    specify "to the left" do
      vim.left

      assert_file_contents <<-EOF
        function_call(y, |x, z| {
          x.to_string()
        })
      EOF
    end

    specify "to the right" do
      vim.right

      assert_file_contents <<-EOF
        function_call(y, |x, z| {
          x.to_string()
        })
      EOF
    end
  end

  describe "lambda params" do
    before :each do
      set_file_contents <<-EOF
        iterator.map(|_, mut v: Vec<_>| {
            v.sort_unstable();
            v
        })
      EOF

      vim.set 'filetype', 'rust'
      vim.search('_,')
    end

    specify "to the left" do
      vim.left

      assert_file_contents <<-EOF
        iterator.map(|mut v: Vec<_>, _| {
            v.sort_unstable();
            v
        })
      EOF
    end

    specify "to the right" do
      vim.right

      assert_file_contents <<-EOF
        iterator.map(|mut v: Vec<_>, _| {
            v.sort_unstable();
            v
        })
      EOF
    end
  end

  describe "template args in types" do
    before :each do
      set_file_contents <<-EOF
        let dict = HashSet<String, Vec<String>>::new();
      EOF

      vim.set 'filetype', 'rust'
      vim.search('String,')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        let dict = HashSet<Vec<String>, String>::new();
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        let dict = HashSet<Vec<String>, String>::new();
      EOF
    end
  end

  describe "template args in a turbofish" do
    before :each do
      set_file_contents <<-EOF
        let list = iterator.collect::<Vec<String>, ()>();
      EOF

      vim.set 'filetype', 'rust'
      vim.search('Vec')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        let list = iterator.collect::<(), Vec<String>>();
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        let list = iterator.collect::<(), Vec<String>>();
      EOF
    end
  end

  describe "text object for a result" do
    before :each do
      set_file_contents <<-EOF
        fn example() -> Result<String, String> {
        }
      EOF

      vim.set 'filetype', 'rust'
      vim.search('Result')
    end

    specify "change result type" do
      vim.feedkeys 'ciaOption<String>'
      vim.write
      assert_file_contents <<-EOF
        fn example() -> Option<String> {
        }
      EOF
    end
  end
end
