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
      pending "No typescript syntax on CI" if ENV['CI']

      vim.left
      assert_file_contents <<-EOF
        const object = { three: "four", one: "two" };
      EOF
    end

    specify "to the right" do
      pending "No typescript syntax on CI" if ENV['CI']

      vim.right
      assert_file_contents <<-EOF
        const object = { three: "four", one: "two" };
      EOF
    end
  end
end
