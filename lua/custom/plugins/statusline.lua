return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      theme = {
        normal = {
          a = { bg = '#BD93F9', fg = '#282A36' },
          b = { bg = '#2B2B2B', fg = '#F8F8F2' },
          c = { bg = '#303030', fg = '#F8F8F2' },
        },
        insert = {
          a = { bg = '#FFB86C', fg = '#282A36' },
          b = { bg = '#2B2B2B', fg = '#F8F8F2' },
          c = { bg = '#303030', fg = '#F8F8F2' },
        },
        visual = {
          a = { bg = '#61AFEF', fg = '#282A36' },
          b = { bg = '#2B2B2B', fg = '#F8F8F2' },
          c = { bg = '#303030', fg = '#F8F8F2' },
        },
        replace = {
          a = { bg = '#FF5555', fg = '#282A36' },
          b = { bg = '#2B2B2B', fg = '#F8F8F2' },
          c = { bg = '#303030', fg = '#F8F8F2' },
        },
        command = {
          a = { bg = '#FF79C6', fg = '#282A36' },

          b = { bg = '#2B2B2B', fg = '#F8F8F2' },
          c = { bg = '#303030', fg = '#F8F8F2' },
        },
        inactive = {
          a = { bg = '#44475A', fg = '#F8F8F2' },
          b = { bg = '#2B2B2B', fg = '#F8F8F2' },
          c = { bg = '#303030', fg = '#F8F8F2' },
        },
      },
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        'branch',
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          sections = { 'error', 'warn', 'info', 'hint' },
          symbols = {
            error = ' ',
            warn = ' ',
            info = ' ',
            hint = '󰠠 ',
          },
          colored = true,
        },
      },
      lualine_c = {
        {
          'filename',
          path = 1,
          file_status = true,
        },
      },
      lualine_x = {
        {
          'diff',
          symbols = {
            added = '+',
            modified = '➜',
            removed = '-',
          },
          colored = true,
        },
      },
      lualine_y = { 'filetype' },
      lualine_z = { 'location' },
    },
    extensions = {
      'quickfix',
      'fugitive',
      'lazy',
      'man',
      'mason',
      {
        filetypes = { 'CompetiTest' },
        sections = {
          lualine_b = {
            function()
              return vim.b.competitest_title or 'CompetiTest'
            end,
          },
          lualine_y = { 'searchcount' },
          lualine_z = { 'change this sometime' },
        },
        inactive_sections = {
          lualine_b = {
            function()
              return vim.b.competitest_title or 'CompetiTest'
            end,
          },
        },
      },
    },
  },
}
