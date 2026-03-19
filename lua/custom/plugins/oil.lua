return {
  'stevearc/oil.nvim',
  lazy = false,
  opts = {
    default_file_explorer = true,
    keymaps = {
      ['<leader><tab>'] = {
        callback = function()
          require('custom.picker').files()
        end,
        desc = 'Find Files',
        mode = 'n',
      },
      ['<C-p>'] = false,
    },
    view_options = {
      show_hidden = true,
    },
    skip_confirm_for_simple_edits = true,
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
    { '<leader>pv', '<CMD>Oil<CR>', desc = 'Open Oil' },
  },
}
