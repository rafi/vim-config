-- Plugins initialization
-- https://github.com/rafi/vim-config

if vim.fn.has('nvim-0.9.0') == 0 then
	vim.api.nvim_echo({
		{ 'Upgrade to Neovim >= 0.10.0 for the best experience.\n', 'ErrorMsg' },
		{ 'Press any key to exit', 'MoreMsg' },
	}, true, {})
	vim.fn.getchar()
	vim.cmd([[quit]])
	return {}
end

require('rafi.config').init()

-- Terminal Mappings
local function term_nav(dir)
	---@param self snacks.terminal
	return function(self)
		return self:is_floating() and '<C-' .. dir .. '>' or vim.schedule(function()
			vim.cmd.wincmd(dir)
		end)
	end
end

return {

	-- Modern plugin manager for Neovim
	{ 'folke/lazy.nvim', version = '*' },

	-- Lua functions library
	{ 'nvim-lua/plenary.nvim', lazy = false },

	{
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,
		opts = function()
			---@type snacks.Config
			return {
				toggle = { map = LazyVim.safe_keymap_set },
				statuscolumn = { enabled = false }, -- We set this in options.lua
				terminal = {
					win = {
						keys = {
							nav_h = { '<C-h>', term_nav('h'), desc = 'Go to Left Window', expr = true, mode = 't' },
							nav_j = { '<C-j>', term_nav('j'), desc = 'Go to Lower Window', expr = true, mode = 't' },
							nav_k = { '<C-k>', term_nav('k'), desc = 'Go to Upper Window', expr = true, mode = 't' },
							nav_l = { '<C-l>', term_nav('l'), desc = 'Go to Right Window', expr = true, mode = 't' },
						},
					},
				},
			}
		end,
		keys = {
			{ '<leader>gm', function() Snacks.git.blame_line() end, { desc = 'Git Blame Line' }},
			{ '<leader>go', function() Snacks.gitbrowse() end, { desc = 'Git Browse' }},
			{
				'<leader>un',
				function()
					Snacks.notifier.hide()
				end,
				desc = 'Dismiss All Notifications',
			},
			{
				'<leader>N',
				desc = 'Neovim News',
				function()
					Snacks.win({
						file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
						width = 0.6,
						height = 0.6,
						wo = {
							spell = false,
							wrap = false,
							signcolumn = 'yes',
							statuscolumn = ' ',
							conceallevel = 3,
						},
					})
				end,
			}
		},
	},
}
