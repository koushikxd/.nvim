local function harpoon()
  return require 'harpoon'
end

return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      harpoon():setup()
    end,
    keys = {
      {
        '<leader>A',
        function()
          harpoon():list():prepend()
        end,
        desc = 'Harpoon Prepend File',
      },
      {
        '<leader>a',
        function()
          harpoon():list():add()
        end,
        desc = 'Harpoon Add File',
      },
      {
        '<C-e>',
        function()
          harpoon().ui:toggle_quick_menu(harpoon():list())
        end,
        desc = 'Harpoon Quick Menu',
      },

      {
        '<C-h>',
        function()
          harpoon():list():select(1)
        end,
        desc = 'Harpoon Select File 1',
      },
      {
        '<C-j>',
        function()
          harpoon():list():select(2)
        end,
        desc = 'Harpoon Select File 2',
      },
      {
        '<C-k>',
        function()
          harpoon():list():select(3)
        end,
        desc = 'Harpoon Select File 3',
      },
      {
        '<C-l>',
        function()
          harpoon():list():select(4)
        end,
        desc = 'Harpoon Select File 4',
      },

      {
        '<leader><C-h>',
        function()
          harpoon():list():replace_at(1)
        end,
        desc = 'Harpoon Replace File 1',
      },
      {
        '<leader><C-j>',
        function()
          harpoon():list():replace_at(2)
        end,
        desc = 'Harpoon Replace File 2',
      },
      {
        '<leader><C-k>',
        function()
          harpoon():list():replace_at(3)
        end,
        desc = 'Harpoon Replace File 3',
      },
      {
        '<leader><C-l>',
        function()
          harpoon():list():replace_at(4)
        end,
        desc = 'Harpoon Replace File 4',
      },
    },
  },
}
