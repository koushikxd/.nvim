return {
  'catgoose/nvim-colorizer.lua',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    filetypes = { '*' },
    user_default_options = {
      css = true,
      css_fn = true,
      tailwind = true,
      mode = 'background',
    },
  },
}
