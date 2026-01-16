return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
    },
    config = function(_, opts)
      local function set_hl()
        vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#2C2C2C' })
        vim.api.nvim_set_hl(0, 'IblScope', { fg = '#707070' })
      end
      set_hl()
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = set_hl,
      })
      require('ibl').setup(opts)
    end,
  },
}
