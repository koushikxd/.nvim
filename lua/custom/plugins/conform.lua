return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format({ async = true }, function(err, did_edit)
          if not err and did_edit then
            vim.notify('Code formatted', vim.log.levels.INFO, { title = 'Conform' })
          end
        end)
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer',
    },
  },
  opts = {
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      lua = { 'stylua' },

      javascript = { 'biome', 'prettier' },
      typescript = { 'biome', 'prettier' },
      javascriptreact = { 'biome', 'prettier' },
      typescriptreact = { 'biome', 'prettier' },
      json = { 'biome', 'prettier' },
      jsonc = { 'biome', 'prettier' },

      css = { 'prettier' },
      html = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier', 'injected' },

      python = { 'ruff_organize_imports', 'ruff_format' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      toml = { 'taplo' },
    },
    formatters = {
      biome = {
        command = 'biome',
        args = { 'format', '--stdin-file-path', '$FILENAME' },
        stdin = true,
      },
      shfmt = {
        prepend_args = { '-i', '2', '-ci' },
      },
      prettier = {
        prepend_args = { '--tab-width', '2' },
      },
    },
  },
}
