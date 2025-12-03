vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.autoformat = false
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.nu = true
vim.opt.updatetime = 50
vim.opt.colorcolumn = '100'
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.wrap = false

vim.opt.mouse = 'a'

vim.opt.laststatus = 3

vim.opt.showmode = false

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'
vim.opt.isfname:append '@-@'

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true

vim.opt.scrolloff = 10

vim.opt.guicursor = ''

vim.diagnostic.config {
  signs = { priority = 9999 },
  underline = true,
  update_in_insert = false, -- false so diags are updated on InsertLeave
  virtual_text = { current_line = true, severity = { min = 'INFO', max = 'WARN' } },
  virtual_lines = { current_line = true, severity = { min = 'ERROR' } },
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
  },
}

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'zh', '8zh')
vim.keymap.set('n', 'zl', '8zl')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])
vim.keymap.set('n', 'x', '"_x')

vim.keymap.set('n', '<Leader>rw', function()
  local word = vim.fn.expand '<cword>'
  local escaped_word = vim.fn.escape(word, '/\\')
  vim.api.nvim_feedkeys(':%s/\\C' .. escaped_word .. '/', 'n', false)
end, { desc = 'Replace word under cursor (case-sensitive)' })

vim.keymap.set('n', '<Leader>rC', function()
  local word = vim.fn.expand '<cword>'
  local escaped_word = vim.fn.escape(word, '/\\')
  vim.api.nvim_feedkeys(':%s/\\c\\(' .. escaped_word .. "\\)/\\=substitute(submatch(0), '" .. escaped_word .. "', '", 'n', false)
end, { desc = 'Replace word under cursor (case-preserving)' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>')
vim.keymap.set('n', '<space>x', ':.lua<CR>')
vim.keymap.set('v', '<space>x', ':lua<CR>')
vim.keymap.set('n', '<leader>fw', '*', { desc = 'Search for word under cursor' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>rc', function()
  require('utils').remove_comments()
end, { desc = '[R]emove [C]omments' })

vim.keymap.set('v', '<leader>ay', function()
  local utils = require 'utils'
  utils.yank_visual_with_path(utils.get_buffer_absolute(), 'absolute')
end, { desc = '[A]bsolute path [Y]ank with selection' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- vim.keymap.set('n', '<C-\\>', '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-w>]', '<C-w>v<C-]>', { desc = 'Open vertical split and go to definiton' })

vim.filetype.add {
  extension = {
    env = 'dotenv',
  },
  filename = {
    ['.env'] = 'dotenv',
    ['env'] = 'dotenv',
  },
  pattern = {
    ['[jt]sconfig.*.json'] = 'jsonc',
    ['%.env%.[%w_.-]+'] = 'dotenv',
  },
}

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Jump to last position when reopening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  group = vim.api.nvim_create_augroup('kickstart-position', { clear = true }),
  command = 'silent! normal! g`"zv',
})

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('kickstart-help', { clear = true }),
  pattern = { '*.txt' },
  callback = function()
    if vim.o.filetype == 'help' then
      vim.cmd.wincmd 'L'
    end
  end,
})

vim.api.nvim_create_augroup('insert-relativenumber', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
  group = 'insert-relativenumber',
  pattern = '*',
  callback = function()
    vim.wo.relativenumber = false
  end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = 'insert-relativenumber',
  pattern = '*',
  callback = function()
    vim.wo.relativenumber = true
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)
local format_group = vim.api.nvim_create_augroup('FormatAutogroup', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  group = format_group,
  callback = function()
    vim.lsp.buf.format()
  end,
})

require('lazy').setup({
  'tpope/vim-sleuth',
  'ThePrimeagen/vim-be-good',
  'vuciv/golf',
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup {
        duration_multiplier = 0,
        mappings = { '<C-u>', '<C-d>' },
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      local npairs = require 'nvim-autopairs'
      npairs.setup {
        disable_in_macro = true, -- disable when recording or executing a macro
        disable_in_visualblock = true, -- disable when insert after visual block mode
        ignored_next_char = '[%w%.%)]', -- don't add pair if next char is alphanumeric
        enable_moveright = true,
        enable_afterquote = false, -- don't add pair after quote
        enable_check_bracket_line = true, -- check bracket in same line
        map_bs = false, -- don't map the <BS> key
        map_c_h = false, -- don't map the <C-h> key
        map_c_w = false, -- don't map <C-w> key
      }
    end,
  },
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require('Comment').setup {
        pre_hook = function(ctx)
          local U = require 'Comment.utils'
          local location = nil
          if ctx.ctype == U.ctype.blockwise then
            location = require('ts_context_commentstring.utils').get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require('ts_context_commentstring.utils').get_visual_start_location()
          end

          return require('ts_context_commentstring.internal').calculate_commentstring {
            key = ctx.ctype == U.ctype.linewise and '__default' or '__multiline',
            location = location,
          }
        end,
      }
    end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false,
    opts = {},

    build = 'make',

    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',

      'nvim-tree/nvim-web-devicons',
      'zbirenbaum/copilot.lua',
      {

        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {

          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },

            use_absolute_path = true,
          },
        },
      },
      {

        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },

  { 'tzachar/highlight-undo.nvim' },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }

      require('mini.surround').setup()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',

    opts = {
      ensure_installed = {
        'bash',
        'c',
        'go',
        'javascript',
        'html',
        'lua',
        'markdown',
        'vim',
        'typescript',
        'tsx',
        'css',
      },

      auto_install = true,
      highlight = {
        enable = true,

        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  { import = 'default.plugins' },
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
