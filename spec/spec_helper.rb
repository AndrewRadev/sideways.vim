require 'vimrunner'
require 'vimrunner/rspec'
require_relative './support/vim'

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  plugin_path = File.expand_path('.')

  config.start_vim do
    vim = Vimrunner.start_gvim
    plugin_path = File.expand_path('../..', __FILE__)
    vim.add_plugin(plugin_path, 'plugin/sideways.vim')

    # Ensure we don't rely on selection=inclusive
    vim.command('set selection=exclusive')

    vim.command('omap aa <Plug>SidewaysArgumentTextobjA')
    vim.command('xmap aa <Plug>SidewaysArgumentTextobjA')
    vim.command('omap ia <Plug>SidewaysArgumentTextobjI')
    vim.command('xmap ia <Plug>SidewaysArgumentTextobjI')

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

    def vim.jump_left
      command 'SidewaysJumpLeft'
      self
    end

    def vim.jump_right
      command 'SidewaysJumpRight'
      self
    end

    vim
  end
end

RSpec.configure do |config|
  config.include Support::Vim
end

