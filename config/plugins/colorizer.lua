-- Attach to certain Filetypes, add special configuration for `html`
-- Use `background` for everything else.
require 'colorizer'.setup {
  'css';
  'scss';
  'sass';
  'stylus';
  'vim';
  'javascript';
  'javascriptreact';
  html = {
    mode = 'foreground';
  }
}
