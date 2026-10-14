return {
  {
    'mason-org/mason.nvim',
    cmd = 'Mason',
    keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
    opts = {
      ui = {
        border = 'rounded',
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    cmd = { 'MasonToolsInstall', 'MasonToolsUpdate' },
    opts = {
      ensure_installed = {
        'stylua',
        'prettier',
        'biome',
        'ruff',
        'shfmt',
        'taplo',
      },
      run_on_start = false, -- run `:MasonToolsInstall` manually to install tools
    },
  },
}
