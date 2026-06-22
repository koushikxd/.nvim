return {
  {
    'mason-org/mason.nvim',
    lazy = false,
    cmd = 'Mason',
    keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
    config = function()
      require('mason').setup {
        ui = {
          border = 'rounded',
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      }
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup {
        ensure_installed = {
          'stylua',
          'prettier',
          'black',
          'isort',
          'goimports',
          'shfmt',
          'buf',
          'taplo',
          'biome',
          'markdownlint-cli2',
          'shellcheck',
          'yamllint',
        },
        auto_update = false,
        run_on_start = false, -- run `:MasonToolsInstall` manually to install tools

        debounce_hours = 5,
      }
    end,
  },
}
