-- Hint and fix deviating indentation

-- Eager: setup only registers BufReadPost/BufNewFile autocmds, and must run
-- before files passed on the command-line are read.
vim.pack.add({ 'https://github.com/nmac427/guess-indent.nvim' })
require('guess-indent').setup({})
