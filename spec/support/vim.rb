module Support
  module Vim
    def set_file_contents(string)
      write_file(filename, string)
      vim.edit filename
    end

    def assert_file_contents(string)
      string = normalize_string_indent(string)
      IO.read(filename).strip.should eq string
    end
  end
end
