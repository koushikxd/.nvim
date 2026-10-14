return {
  'koushikxd/resu.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
  },
  cmd = { 'ResuOpen', 'ResuClose', 'ResuToggle', 'ResuRefresh', 'ResuAccept', 'ResuDecline', 'ResuAcceptAll', 'ResuDeclineAll', 'ResuReset' },
  keys = { { '<leader>rt', desc = 'Resu: Toggle diff view' } },
  config = function()
    require('resu').setup {
      hot_reload = false,
    }

    pcall(vim.api.nvim_del_augroup_by_name, 'resu_hot_reload')
  end,
}
