-- vim.pack plugin manager picker (snacks.nvim)

-- Eager: the plugin/ file only defines :Packman and <Plug> maps. The picker
-- loads on first use.
require('rafi.pack').dev('packman.nvim', 'https://github.com/rafi/packman.nvim')

vim.keymap.set('n', '<leader>l', '<Plug>(Packman)', { desc = 'Plugin Updates' })
