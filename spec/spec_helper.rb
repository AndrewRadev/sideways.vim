require 'vimrunner'
require 'vimrunner/rspec'
require_relative './support/vim'

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  plugin_path = File.expand_path('.')

  config.start_vim do
    vim = Vimrunner.start
    plugin_path = File.expand_path('../..', __FILE__)
    vim.add_plugin(plugin_path, 'plugin/sideways.vim')

    def vim.left
      command 'SidewaysLeft'
      write
      self
    end

    def vim.right
      command 'SidewaysRight'
      write
      self
    end

    vim
  end
end

RSpec.configure do |config|
  config.include Support::Vim
end

