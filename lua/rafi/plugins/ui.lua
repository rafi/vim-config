-- Plugins: UI
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Replaces the UI for messages, cmdline and the popupmenu
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/ui.lua
	{ 'noice.nvim', enabled = false },

	-----------------------------------------------------------------------------
	-- Snazzy tab/bufferline
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/ui.lua
	{
		'bufferline.nvim',
		enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
		keys = {
			{ '<S-h>', false },
			{ '<S-l>', false },
		},
		opts = {
			options = {
				mode = 'tabs',
				separator_style = 'slant',
				show_close_icon = false,
				show_buffer_close_icons = false,
				always_show_bufferline = true,
				custom_areas = {
					right = function()
						local result = {}
						local root = LazyVim.root()
						table.insert(result, {
							text = '%#BufferLineTab# ' .. vim.fn.fnamemodify(root, ':t'),
						})

						-- Session indicator
						if vim.v.this_session ~= '' then
							table.insert(result, { text = '%#BufferLineTab#  ' })
						end
						return result
					end,
				},
				offsets = {
					{
						filetype = 'snacks_layout_box',
						text = '󰙅  File Explorer',
						separator = true,
					},
					{
						filetype = 'neo-tree',
						text = 'Neo-tree',
						separator = true,
						highlight = 'Directory',
						text_align = 'center',
					},
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Collection of small QoL plugins
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/ui.lua
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/util.lua
	{
		'folke/snacks.nvim',
		opts = {
			dashboard = { enabled = false },
			scroll = { enabled = false },
			terminal = {
				win = { style = 'terminal', wo = { winbar = '' } },
			},
			zen = {
				toggles = { git_signs = true },
				zoom = {
					show = { tabline = false },
					win = { backdrop = true },
				},
			},
		},
		keys = {
			{
				'<leader>N',
				desc = 'Neovim News',
				function()
					---@diagnostic disable-next-line: missing-fields
					Snacks.win({
						file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
						border = 'rounded',
						width = 0.6,
						height = 0.6,
						wo = {
							spell = false,
							wrap = false,
							statuscolumn = ' ',
							conceallevel = 3,
						},
					})
				end,
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Hint and fix deviating indentation
	{
		'tenxsoydev/tabs-vs-spaces.nvim',
		event = { 'BufReadPost', 'BufNewFile' },
		opts = {},
	},

	-----------------------------------------------------------------------------
	-- Highlight words quickly
	{
		't9md/vim-quickhl',
		-- stylua: ignore
		keys = {
			{ '<leader>mt', '<Plug>(quickhl-manual-this)', mode = { 'n', 'x' }, desc = 'Highlight word' },
		},
	},
}
