-- Rafael Bodill's Neovim entry-point
-- https://github.com/rafi/vim-config

local stdconfig = vim.fn.stdpath('config')
local lazy_override = stdconfig .. '/lua/config/lazy.lua'
--local lazy_override = vim.fs.joinpath(stdconfig, 'lua', 'config', 'lazy.lua')

if vim.loop.fs_stat(lazy_override) then
	-- Override RafiVim default config.
	require('config.lazy')
else
	-- Bootstrap lazy.nvim, RafiVim, LazyVim and your plugins.
	require('rafi.config.lazy')
end
