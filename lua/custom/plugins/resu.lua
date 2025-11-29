return {
  'koushikxd/resu.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('resu').setup {}
  end,
}
