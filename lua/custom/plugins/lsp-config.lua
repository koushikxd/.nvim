return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'williamboman/mason.nvim' },
    'williamboman/mason-lspconfig.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    { 'b0o/schemastore.nvim' },
  },
  config = function()
    local servers = {
      'bashls',
      'clangd',
      'gopls',
      'lua_ls',
      'pyright',
      'cssls',
      'html',
      'tailwindcss',
      'ts_ls',
      'jsonls',
      'yamlls',
      'marksman',
      'biome',
    }

    vim.lsp.config('*', {
      capabilities = require('blink.cmp').get_lsp_capabilities(nil, true),
      root_markers = { '.git' },
    })

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          workspace = {
            checkThirdParty = false,
            library = {
              '${3rd}/luv/library',
              unpack(vim.api.nvim_get_runtime_file('', true)),
            },
          },
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    })

    vim.lsp.config('jsonls', {
      settings = {
        json = {
          schema = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    vim.lsp.config('biome', {
      settings = {
        biome = {
          lint = {
            rules = {
              nursery = {
                useSortedClasses = 'off',
              },
            },
          },
        },
      },
    })

    vim.lsp.config('ts_ls', {
      single_file_support = true,
      settings = {
        javascript = {
          suggest = {
            names = false,
            autoImports = false,
          },
        },
      },
    })

    vim.lsp.config('tailwindcss', {
      settings = {
        tailwindCSS = {
          filetypes_exclude = { 'markdown' },
          filetypes_include = {},
        },
      },
    })

    vim.lsp.enable(servers)

    require('mason-lspconfig').setup {
      ensure_installed = servers,
      automatic_enable = true,
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', function()
          require('snacks').picker.lsp_definitions()
        end, 'Goto Definition')
        map('gr', function()
          require('snacks').picker.lsp_references()
        end, 'Goto References')
        map('gi', function()
          require('snacks').picker.lsp_implementations()
        end, 'Goto Implementation')
        map('go', function()
          require('snacks').picker.lsp_type_definitions()
        end, 'Type Definition')
        map('<leader>ws', function()
          require('snacks').picker.lsp_workspace_symbols()
        end, 'Workspace Symbols')

        map('gl', vim.diagnostic.open_float, 'Open Diagnostic Float')
        map('K', function()
          vim.lsp.buf.hover()
          vim.cmd 'stopinsert'
        end, 'Hover Documentation')
        map('gs', vim.lsp.buf.signature_help, 'Signature Documentation')
        map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

        map('<leader>v', '<cmd>vsplit | lua vim.lsp.buf.definition()<cr>', 'Goto Definition in Vertical Split')

        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map('<leader>cs', vim.lsp.buf.signature_help, 'Display Signature Information')
        --[[         map('<leader>ra', vim.lsp.buf.rename, 'Rename all references') ]]
        map('<leader>cf', vim.lsp.buf.format, 'Format')
        map('<leader>ci', function()
          require('snacks').picker.lsp_implementations()
        end, 'Implementation')

        map('<leader>Wa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
        map('<leader>Wr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
        map('<leader>Wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, 'Workspace List Folders')
      end,
    })

    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = ' ',
          [vim.diagnostic.severity.WARN] = ' ',
          [vim.diagnostic.severity.HINT] = '󰠠 ',
          [vim.diagnostic.severity.INFO] = ' ',
        },
      },
    }
  end,
}
