-- Rafael Bodill's Neovim entry-point
-- https://github.com/rafi/vim-config
--
-- since 2014.

local stdconfig = vim.fn.stdpath('config') --[[@as string]]
local lazy_override = stdconfig .. '/lua/config/lazy.lua'

vim.uv = vim.uv or vim.loop

if vim.uv.fs_stat(lazy_override) then
	-- Override RafiVim default config.
	require('config.lazy')
else
	-- Bootstrap lazy.nvim, RafiVim, LazyVim and your plugins.
	require('rafi.config.lazy')
end
