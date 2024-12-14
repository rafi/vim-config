return {

	-----------------------------------------------------------------------------
	-- Disable snacks indent when indent-blankline is enabled
	{
		'snacks.nvim',
		opts = {
			indent = { enabled = false },
		},
	},

	-----------------------------------------------------------------------------
	-- Visually display indent levels
	{
		'lukas-reineke/indent-blankline.nvim',
		enabled = false,
		main = 'ibl',
		event = 'LazyFile',
		opts = function()
			---@diagnostic disable-next-line: missing-fields
			Snacks.toggle({
				name = 'Indention Guides',
				get = function()
					return require('ibl.config').get_config(0).enabled
				end,
				set = function(state)
					require('ibl').setup_buffer(0, { enabled = state })
				end,
			}):map('<Leader>ug')

			return {
				indent = {
					-- See more characters at :h ibl.config.indent.char
					char = '│', -- ▏│
					tab_char = '│',
				},
				scope = { enabled = false, show_start = false, show_end = false },
				exclude = {
					filetypes = {
						'alpha',
						'checkhealth',
						'dashboard',
						'git',
						'gitcommit',
						'help',
						'lazy',
						'lazyterm',
						'lspinfo',
						'man',
						'mason',
						'neo-tree',
						'notify',
						'Outline',
						'snacks_dashboard',
						'snacks_notif',
						'snacks_terminal',
						'snacks_win',
						'TelescopePrompt',
						'TelescopeResults',
						'terminal',
						'toggleterm',
						'trouble',
						'Trouble',
					},
				},
			}
		end,
	},
}
