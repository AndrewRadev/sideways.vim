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

    vim.command('nmap _h <Plug>SidewaysJumpLeft')
    vim.command('omap _h <Plug>SidewaysJumpLeft')
    vim.command('xmap _h <Plug>SidewaysJumpLeft')
    vim.command('nmap _l <Plug>SidewaysJumpRight')
    vim.command('omap _l <Plug>SidewaysJumpRight')
    vim.command('xmap _l <Plug>SidewaysJumpRight')

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

    def vim.jump_left(count = nil)
      mapping = '_h'
      mapping = count.to_s + mapping if count
      feedkeys(mapping)
      self
    end

    def vim.jump_right(count = nil)
      mapping = '_l'
      mapping = count.to_s + mapping if count
      feedkeys(mapping)
      self
    end

    vim
  end
end

RSpec.configure do |config|
  config.include Support::Vim
end

