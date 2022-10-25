require 'vimrunner'
require 'vimrunner/rspec'
require_relative './support/vim'

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  plugin_path = Pathname.new(File.expand_path('.'))

  config.start_vim do
    vim = Vimrunner.start_gvim
    vim.add_plugin(plugin_path, 'plugin/sideways.vim')

    # bootstrap filetypes
    vim.command 'autocmd BufNewFile,BufRead *.ts set filetype=typescript'
    vim.command 'autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact'

    # Up-to-date filetype support:
    vim.prepend_runtimepath(plugin_path.join('spec/support/rust.vim'))

    # Ensure we don't rely on selection=inclusive
    vim.command('set selection=exclusive')

    vim.command('omap aa <Plug>SidewaysArgumentTextobjA')
    vim.command('xmap aa <Plug>SidewaysArgumentTextobjA')
    vim.command('omap ia <Plug>SidewaysArgumentTextobjI')
    vim.command('xmap ia <Plug>SidewaysArgumentTextobjI')

    # Use consistent indentation:
    vim.command('autocmd FileType * set expandtab')
    vim.command('autocmd FileType * set shiftwidth=2')

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

  config.before :each do
    # restore defaults
    vim.command('let g:sideways_add_item_cursor_restore = 0')
  end
end
