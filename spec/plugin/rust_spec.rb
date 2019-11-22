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

  describe "lambdas in structs" do
    before :each do
      set_file_contents <<-EOF
        let processor = Processor {
            before,
            lambda: |x, y| { x + 1 },
            after,
        };
      EOF

      vim.set 'filetype', 'rust'
    end

    specify "before lambda" do
      vim.search('before')
      vim.right

      assert_file_contents <<-EOF
        let processor = Processor {
            lambda: |x, y| { x + 1 },
            before,
            after,
        };
      EOF
    end

    specify "after lambda" do
      vim.search('after')
      vim.left

      assert_file_contents <<-EOF
        let processor = Processor {
            before,
            after,
            lambda: |x, y| { x + 1 },
        };
      EOF
    end

    specify "in lambda args" do
      vim.search('x,')
      vim.left

      assert_file_contents <<-EOF
        let processor = Processor {
            before,
            lambda: |y, x| { x + 1 },
            after,
        };
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

  describe "template args in struct definitions" do
    before :each do
      set_file_contents <<-EOF
        pub struct Forth {
            stack: Vec<Value>,
            environment: HashMap<String, String>,
        }
      EOF

      vim.set 'filetype', 'rust'
      vim.search('stack:')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        pub struct Forth {
            environment: HashMap<String, String>,
            stack: Vec<Value>,
        }
      EOF
    end
  end

  describe "template args in tuple struct definitions" do
    before :each do
      set_file_contents <<-EOF
        pub struct Forth(Vec<Value>, HashMap<String, String>)
      EOF

      vim.set 'filetype', 'rust'
      vim.search('Vec')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        pub struct Forth(HashMap<String, String>, Vec<Value>)
      EOF
    end
  end

  describe "template args in a newtype declaration" do
    before :each do
      set_file_contents <<-EOF
        type Foo = (First<Foo, Bar>, Second<Foo, Bar>)
      EOF

      vim.set 'filetype', 'rust'
      vim.search('First')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        type Foo = (Second<Foo, Bar>, First<Foo, Bar>)
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

  describe "correct cursor position in nested template args" do
    before :each do
      set_file_contents <<-EOF
        Result<Box<Error>, ()>
      EOF

      vim.set 'filetype', 'rust'
      vim.search('Box')
    end

    specify "to the left" do
      vim.left
      expect(vim.echo('expand("<cword>")')).to eq 'Box'

      vim.left
      expect(vim.echo('expand("<cword>")')).to eq 'Box'
    end

    specify "to the right" do
      vim.right
      expect(vim.echo('expand("<cword>")')).to eq 'Box'

      vim.right
      expect(vim.echo('expand("<cword>")')).to eq 'Box'
    end
  end

  describe "lifetimes in a function declaration" do
    before :each do
      set_file_contents <<-EOF
        fn define_custom<'a, 'b>(&mut self, mut i: S<'a>) -> Result<S<'a>, Error> { }
      EOF

      vim.set 'filetype', 'rust'
      vim.search('mut i')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        fn define_custom<'a, 'b>(mut i: S<'a>, &mut self) -> Result<S<'a>, Error> { }
      EOF
    end
  end

  describe "lifetimes in a struct (regression)" do
    before :each do
      set_file_contents <<-EOF
        pub struct Iter<'a, T: 'a> {
            next: Option<&'a Node<T>>,
            foo: bar,
        }
      EOF

      vim.set 'filetype', 'rust'
      vim.search('T:')
    end

    specify "to the left" do
      vim.left
      assert_file_contents <<-EOF
        pub struct Iter<T: 'a, 'a> {
            next: Option<&'a Node<T>>,
            foo: bar,
        }
      EOF
    end
  end

  describe "comparison in a function invocation" do
    before :each do
      set_file_contents <<-EOF
        foo(a < b, b > c);
      EOF

      vim.set 'filetype', 'rust'
      vim.search('a < b')
    end

    specify "to the right" do
      vim.right
      assert_file_contents <<-EOF
        foo(b > c, a < b);
      EOF
    end
  end

  describe "arrays of chars" do
    before :each do
      set_file_contents <<-EOF
        let v = vec!['a', ',', 'c'];
      EOF

      vim.set 'filetype', 'rust'
      vim.search('a')
    end

    specify "to the right" do
      pending "No rust syntax on TravisCI's Vim 7.4" if ENV['CI']

      vim.right
      assert_file_contents <<-EOF
        let v = vec![',', 'a', 'c'];
      EOF
    end
  end

  describe "static references" do
    before :each do
      set_file_contents <<-EOF
        struct Picture {
            bitmap: &'static [&'static str],
            color_table: &'static [(&'static str, u8, u8, u8)],
        }
      EOF

      vim.set 'filetype', 'rust'
    end

    specify "in the struct" do
      vim.search('color_table')
      vim.left
      assert_file_contents <<-EOF
        struct Picture {
            color_table: &'static [(&'static str, u8, u8, u8)],
            bitmap: &'static [&'static str],
        }
      EOF
    end

    specify "in the tuple" do
      vim.search('(\zs&\'static str')
      vim.right
      assert_file_contents <<-EOF
        struct Picture {
            bitmap: &'static [&'static str],
            color_table: &'static [(u8, &'static str, u8, u8)],
        }
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
