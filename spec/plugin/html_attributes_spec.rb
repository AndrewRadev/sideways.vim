require 'spec_helper'

describe "html attributes" do
  describe "simple" do
    let(:filename) { 'test.html' }

    before :each do
      set_file_contents <<-EOF
        <i data-one data-two data-three></i>
      EOF

      vim.set 'filetype', 'html'
      vim.search('one')
    end

    specify "to the left" do
      assert_file_contents <<-EOF
        <i data-one data-two data-three></i>
      EOF

      vim.left
      assert_file_contents <<-EOF
        <i data-three data-two data-one></i>
      EOF

      vim.left
      assert_file_contents <<-EOF
        <i data-three data-one data-two></i>
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        <i data-two data-one data-three></i>
      EOF

      vim.right
      assert_file_contents <<-EOF
        <i data-two data-three data-one></i>
      EOF
    end
  end

  describe "containing whitespace" do
    let(:filename) { 'test.html' }

    before :each do
      set_file_contents <<-EOF
        <i data-one="the value" data-two="the value" data-three></i>
      EOF

      vim.set 'filetype', 'html'
      vim.search('one')
    end

    specify "to the left" do
      assert_file_contents <<-EOF
        <i data-one="the value" data-two="the value" data-three></i>
      EOF

      vim.left
      assert_file_contents <<-EOF
        <i data-three data-two="the value" data-one="the value"></i>
      EOF

      vim.left
      assert_file_contents <<-EOF
        <i data-three data-one="the value" data-two="the value"></i>
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        <i data-two="the value" data-one="the value" data-three></i>
      EOF

      vim.right
      assert_file_contents <<-EOF
        <i data-two="the value" data-three data-one="the value"></i>
      EOF
    end
  end

  describe "self-closing tags" do
    let(:filename) { 'test.html' }

    before :each do
      set_file_contents <<-EOF
        <link type="one" rel="two" href="three" />
      EOF

      vim.set 'filetype', 'html'
      vim.search('one')
    end

    specify "to the left" do
      assert_file_contents <<-EOF
        <link type="one" rel="two" href="three" />
      EOF

      vim.left
      assert_file_contents <<-EOF
        <link href="three" rel="two" type="one" />
      EOF

      vim.left
      assert_file_contents <<-EOF
        <link href="three" type="one" rel="two" />
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        <link rel="two" type="one" href="three" />
      EOF

      vim.right
      assert_file_contents <<-EOF
        <link rel="two" href="three" type="one" />
      EOF
    end
  end

  describe "multiline" do
    let(:filename) { 'test.html' }

    before :each do
      set_file_contents <<-EOF
        <div one="two" three="four"
          five="six">
        </div>
      EOF

      vim.set 'filetype', 'html'
      vim.search('one')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        <div five="six" three="four"
          one="two">
        </div>
      EOF
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        <div three="four" one="two"
          five="six">
        </div>
      EOF
    end
  end

  describe "class attribute values" do
    describe "inside single quote class" do
      let(:filename) { 'test.html' }

      before :each do
        set_file_contents <<-EOF
          <div class='one two three'></div>
        EOF

        vim.set 'filetype', 'html'
        vim.search('one')
      end

      specify "to the left" do
        assert_file_contents <<-EOF
          <div class='one two three'></div>
        EOF

        vim.left
        assert_file_contents <<-EOF
          <div class='three two one'></div>
        EOF

        vim.left
        assert_file_contents <<-EOF
          <div class='three one two'></div>
        EOF
      end

      specify "to the right" do
        vim.right
        assert_file_contents <<-EOF
          <div class='two one three'></div>
        EOF

        vim.right
        assert_file_contents <<-EOF
          <div class='two three one'></div>
        EOF
      end
    end

    describe "inside double quote class" do
      let(:filename) { 'test.html' }

      before :each do
        set_file_contents <<-EOF
          <div class="one two three"></div>
        EOF

        vim.set 'filetype', 'html'
        vim.search('one')
      end

      specify "to the left" do
        assert_file_contents <<-EOF
          <div class="one two three"></div>
        EOF

        vim.left
        assert_file_contents <<-EOF
          <div class="three two one"></div>
        EOF

        vim.left
        assert_file_contents <<-EOF
          <div class="three one two"></div>
        EOF
      end

      specify "to the right" do
        vim.right
        assert_file_contents <<-EOF
          <div class="two one three"></div>
        EOF

        vim.right
        assert_file_contents <<-EOF
          <div class="two three one"></div>
        EOF
      end
    end
  end

  describe "style attribute values" do
    describe "inside single quote style" do
      let(:filename) { 'test.html' }

      before :each do
        set_file_contents <<-EOF
          <div style='width: 100px; height: 50px;'></div>
        EOF

        vim.set 'filetype', 'html'
        vim.search('width')
      end

      specify "to the left" do
        vim.left
        assert_file_contents <<-EOF
          <div style='height: 50px; width: 100px;'></div>
        EOF

        vim.left
        assert_file_contents <<-EOF
          <div style='width: 100px; height: 50px;'></div>
        EOF
      end

      specify "to the right" do
        vim.right
        assert_file_contents <<-EOF
          <div style='height: 50px; width: 100px;'></div>
        EOF

        vim.right
        assert_file_contents <<-EOF
          <div style='width: 100px; height: 50px;'></div>
        EOF
      end
    end

    describe "inside double quote style" do
      let(:filename) { 'test.html' }

      before :each do
        set_file_contents <<-EOF
          <div style="width: 100px; height: 50px"></div>
        EOF

        vim.set 'filetype', 'html'
        vim.search('width')
      end

      specify "to the left" do
        vim.left
        assert_file_contents <<-EOF
          <div style="height: 50px; width: 100px"></div>
        EOF

        vim.left
        assert_file_contents <<-EOF
          <div style="width: 100px; height: 50px"></div>
        EOF
      end

      specify "to the right" do
        vim.right
        assert_file_contents <<-EOF
          <div style="height: 50px; width: 100px"></div>
        EOF

        vim.right
        assert_file_contents <<-EOF
          <div style="width: 100px; height: 50px"></div>
        EOF
      end
    end
  end
end
