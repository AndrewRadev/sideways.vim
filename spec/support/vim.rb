module Support
  module Vim
    def set_file_contents(string)
      write_file(filename, string)
      vim.edit filename
    end

    def assert_file_contents(string)
      string = normalize_string_indent(string)
      expect(IO.read(filename).strip).to eq string
    end
  end
end
