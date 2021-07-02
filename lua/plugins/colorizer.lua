-- plugin: nvim-colorizer.lua
-- see: https://github.com/norcalli/nvim-colorizer.lua
-- rafi settings

require 'colorizer'.setup {
  html = { mode = 'foreground' },
  css = { rgb_fn = true },
  scss = { rgb_fn = true },
  sass = { rgb_fn = true },
  stylus = { rgb_fn = true },
  svelte = { rgb_fn = true },
  vim = { names = false },
  tmux = { names = false },
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'lua',
}
