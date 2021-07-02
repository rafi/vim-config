-- Forked from: https://github.com/nvim-telescope/telescope-z.nvim
--

local zoxide_builtin = require'telescope._extensions.zoxide_builtin'

return require'telescope'.register_extension{
  exports = {
    list = zoxide_builtin.list,
  },
}
