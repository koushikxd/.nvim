return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.nvim',
  },
  opts = {
    file_types = { 'markdown' },
  },
  keys = {
    {
      '<leader>mt',
      '<cmd>RenderMarkdown toggle<CR>',
      ft = 'markdown',
      desc = '[M]arkdown [T]oggle render',
    },
    {
      '<leader>mp',
      '<cmd>RenderMarkdown preview<CR>',
      ft = 'markdown',
      desc = '[M]arkdown [P]review side-by-side',
    },
  },
}
