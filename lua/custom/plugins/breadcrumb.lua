return {
  'utilyre/barbecue.nvim',
  name = 'barbecue',
  version = '*',
  dependencies = {
    'SmiteshP/nvim-navic',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    attach_navic = false,
  },
  config = function()
    local navic = require 'nvim-navic'

    require('barbecue').setup {
      create_autocmd = false,
      attach_navic = false,
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('navic_attach', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buf = args.buf
        if vim.b[buf].navic_attached then
          return
        end
        if client and client.name == 'graphql' then
          return
        end
        if client and client.server_capabilities.documentSymbolProvider then
          navic.attach(client, buf)
          vim.b[buf].navic_attached = true
        end
      end,
    })

    vim.api.nvim_create_autocmd({
      'WinScrolled',
      'BufWinEnter',
      'CursorHold',
      'InsertLeave',
    }, {
      group = vim.api.nvim_create_augroup('barbecue.updater', {}),
      callback = function()
        require('barbecue.ui').update()
      end,
    })
  end,
}
