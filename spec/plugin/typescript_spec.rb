require 'spec_helper'

describe "Typescript" do
  describe "enum variants" do
    let(:filename) { 'test.ts' }

    before :each do
      set_file_contents <<-EOF
        interface Status {
          code: 200 | 404 | 500;
        }
      EOF

      vim.search('code: \zs200')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        interface Status {
          code: 500 | 404 | 200;
        }
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        interface Status {
          code: 404 | 200 | 500;
        }
      EOF
    end
  end

  describe "objects" do
    let(:filename) { 'test.ts' }

    before :each do
      set_file_contents <<-EOF
        const object = { one: "two", three: "four" };
      EOF

      vim.search('one: \zs"two"')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        const object = { three: "four", one: "two" };
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        const object = { three: "four", one: "two" };
      EOF
    end
  end

  describe "function arguments" do
    let(:filename) { 'test.ts' }

    before :each do
      set_file_contents <<-EOF
        function foo(a: number, b: Type<A, B>, c: number) {
            console.log(a, b)
        }
      EOF

      vim.search('a: number')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        function foo(c: number, b: Type<A, B>, a: number) {
            console.log(a, b)
        }
      EOF

      vim.left
      assert_file_contents <<-EOF
        function foo(c: number, a: number, b: Type<A, B>) {
            console.log(a, b)
        }
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        function foo(b: Type<A, B>, a: number, c: number) {
            console.log(a, b)
        }
      EOF

      vim.right
      assert_file_contents <<-EOF
        function foo(b: Type<A, B>, c: number, a: number) {
            console.log(a, b)
        }
      EOF
    end
  end
end
