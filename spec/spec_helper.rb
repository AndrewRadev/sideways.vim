require 'tmpdir'
require 'vimrunner'
require_relative './support/vim'

RSpec.configure do |config|
  config.include Support::Vim

  # cd into a temporary directory for every example.
  config.around do |example|
    @vim = Vimrunner.start
    @vim.add_plugin(File.expand_path('.'), 'plugin/sideways.vim')

    def @vim.left
      command 'SidewaysLeft'
      write
      self
    end

    def @vim.right
      command 'SidewaysRight'
      write
      self
    end

    def vim
      @vim
    end

    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        @vim.command("cd #{dir}")
        example.call
      end
    end

    @vim.kill
  end
end
