require 'tmpdir'
require 'vimrunner'
require_relative './support/vim'

RSpec.configure do |config|
  config.include Support::Vim

  # cd into a temporary directory for every example.
  config.around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        VIM.command("cd #{dir}")
        example.call
      end
    end
  end

  config.before(:suite) do
    VIM = Vimrunner.start
    VIM.add_plugin(File.expand_path('.'), 'plugin/sideways.vim')

    def VIM.left
      command 'SidewaysLeft'
      write
      self
    end

    def VIM.right
      command 'SidewaysRight'
      write
      self
    end
  end

  config.after(:suite) do
    VIM.kill
  end
end
