return {
  --[[ {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            accept = '<Tab>',
            refresh = 'r',
            open = '<M-CR>',
          },
          layout = {
            position = 'bottom',
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = '<c-a>',
            accept_word = false,
            accept_line = false,
            next = '<c-j>',
            prev = '<c-k>',
            dismiss = '<C-e>',
          },
        },
      }
    end,
  }, ]]
}
