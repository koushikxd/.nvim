return {
  'koushikxd/resu.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
  },
  config = function()
    require('resu').setup {}
  end,
}
