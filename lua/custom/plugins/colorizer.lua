local filetypes = { 'css', 'scss', 'html', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'lua' }

return {
  'catgoose/nvim-colorizer.lua',
  ft = filetypes,
  opts = {
    filetypes = filetypes,
    user_default_options = {
      css = true,
      css_fn = true,
      tailwind = true,
      mode = 'background',
    },
  },
}
