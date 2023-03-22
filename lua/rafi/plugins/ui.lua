-- Plugins: UI
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	{ 'nvim-tree/nvim-web-devicons', lazy = false },
	{ 'MunifTanjim/nui.nvim', lazy = false },
	{ 'rafi/tabstrip.nvim', lazy = false, opts = true },
	{ 'rafi/theme-loader.nvim', lazy = false, priority = 999, opts = true },

	-----------------------------------------------------------------------------
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		dependencies = {
			'MunifTanjim/nui.nvim',
			'rcarriga/nvim-notify',
			'nvim-treesitter/nvim-treesitter',
		},
		---@type NoiceConfig
		opts = {
			lsp = {
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
		keys = {
			{ '<S-Enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, mode = 'c', desc = 'Redirect Cmdline' },
			{ '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
			{ '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
			{ '<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All' },
			{ '<c-f>', function() if not require('noice.lsp').scroll(4) then return '<c-f>' end end, silent = true, expr = true, desc = 'Scroll forward', mode = {'i', 'n', 's'} },
			{ '<c-b>', function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end, silent = true, expr = true, desc = 'Scroll backward', mode = {'i', 'n', 's'}},
		},
	},

	-----------------------------------------------------------------------------
	{
		'SmiteshP/nvim-navic',
		keys = {
			{
				'<Leader>f',
				function()
					if vim.b.navic_winbar then
						vim.b.navic_winbar = false
						vim.wo.winbar = ''
					else
						vim.b.navic_winbar = true
						vim.wo.winbar =
							"%#TabLineSel#%#Special#%{%v:lua.require'nvim-navic'.get_location()%}"
					end
				end,
				desc = 'Toggle structure panel',
			},
		},
		init = function()
			vim.g.navic_silence = true
			require('rafi.config').on_attach(function(client, buffer)
				if client.server_capabilities.documentSymbolProvider then
					require('nvim-navic').attach(client, buffer)
				end
			end)
		end,
		opts = function()
			return {
				separator = ' ',
				highlight = true,
				depth_limit = 5,
				icons = require('rafi.config').icons.kinds,
			}
		end,
	},

	-----------------------------------------------------------------------------
	{
		'rcarriga/nvim-notify',
		event = 'VeryLazy',
		keys = {
			{
				'<leader>un',
				function()
					require('notify').dismiss({ silent = true, pending = true })
				end,
				desc = 'Delete all Notifications',
			},
		},
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
		},
		init = function()
			-- When noice is not enabled, install notify on VeryLazy
			local Util = require('rafi.config')
			if not Util.has('noice.nvim') then
				Util.on_very_lazy(function()
					vim.notify = require('notify')
				end)
			end
		end,
	},

	-----------------------------------------------------------------------------
	{
		'chentoast/marks.nvim',
		dependencies = 'lewis6991/gitsigns.nvim',
		event = 'FileType',
		opts = {
			default_mappings = true,
			cyclic = true,
			force_write_shada = false,
			refresh_interval = 250,
			sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
			bookmark_1 = {
				sign = '',  -- ⚐ ⚑      
				virt_text = '─────────────────────────────────',
			},
			mappings = {
				annotate = 'm<Space>',
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'lukas-reineke/indent-blankline.nvim',
		event = 'FileType',
		keys = {
			{ '<Leader>ti', '<cmd>IndentBlanklineToggle<CR>' },
		},
		opts = {
			show_trailing_blankline_indent = false,
			disable_with_nolist = true,
			filetype_exclude = {
				'lspinfo',
				'checkhealth',
				'help',
				'man',
				'lazy',
				'alpha',
				'dashboard',
				'terminal',
				'TelescopePrompt',
				'TelescopeResults',
				'neo-tree',
				'Outline',
				'mason',
				'Trouble',
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		't9md/vim-quickhl',
		keys = {
			{
				'<Leader>mt',
				'<Plug>(quickhl-manual-this)',
				mode = { 'n', 'x' },
				desc = 'Highlight word'
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'kevinhwang91/nvim-bqf',
		ft = 'qf',
		cmd = 'BqfAutoToggle',
		event = 'QuickFixCmdPost',
		opts = {
			auto_resize_height = false,
			func_map = {
				tab = 'st',
				split = 'sv',
				vsplit = 'sg',

				stoggleup = 'K',
				stoggledown = 'J',
				stogglevm = '<Space>',

				ptoggleitem = 'p',
				ptoggleauto = 'P',
				ptogglemode = 'zp',

				pscrollup = '<C-b>',
				pscrolldown = '<C-f>',

				prevfile = 'gk',
				nextfile = 'gj',

				prevhist = '<S-Tab>',
				nexthist = '<Tab>',
			},
			preview = {
				auto_preview = true,
				should_preview_cb = function(bufnr)
					-- file size greater than 100kb can't be previewed automatically
					local filename = vim.api.nvim_buf_get_name(bufnr)
					local fsize = vim.fn.getfsize(filename)
					if fsize > 100 * 1024 then
						return false
					end
					return true
				end,
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'NvChad/nvim-colorizer.lua',
		event = 'FileType',
		opts = {
			filetypes = { '*', '!lazy' },
			buftype = { '*', '!prompt', '!nofile' },
			user_default_options = {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = false, -- "Name" codes like Blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				AARRGGBB = false, -- 0xAARRGGBB hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				-- Available modes: foreground, background
				-- Available modes for `mode`: foreground, background,  virtualtext
				mode = 'background', -- Set the display mode.
				virtualtext = '■',
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'rmagatti/goto-preview',
		dependencies = 'nvim-telescope/telescope.nvim',
		keys = {
			{
				'gpd',
				function()
					require('goto-preview').goto_preview_definition({})
				end,
				{ noremap = true },
			},
			{
				'gpi',
				function()
					require('goto-preview').goto_preview_implementation({})
				end,
				{ noremap = true },
			},
			{
				'gpc',
				function()
					require('goto-preview').close_all_win()
				end,
				{ noremap = true },
			},
			{
				'gpr',
				function()
					require('goto-preview').goto_preview_references({})
				end,
				{ noremap = true },
			},
		},
		opts = {
			width = 78,
			height = 15,
			default_mappings = false,
			opacity = 10,
			post_open_hook = function(_, win)
				vim.api.nvim_win_set_config(win, {
					border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
				})
				vim.api.nvim_win_set_option(win, 'spell', false)
				vim.api.nvim_win_set_option(win, 'signcolumn', 'no')
			end,
		},
	},

	-----------------------------------------------------------------------------
	{
		'itchyny/calendar.vim',
		cmd = 'Calendar',
		init = function()
			vim.g.calendar_google_calendar = 1
			vim.g.calendar_google_task = 1
			vim.g.calendar_cache_directory = vim.fn.stdpath('data') .. '/calendar'
		end,
	},

}
