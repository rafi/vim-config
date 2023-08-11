-- Plugins: UI
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	{ 'nvim-tree/nvim-web-devicons', lazy = false },
	{ 'MunifTanjim/nui.nvim', lazy = false },
	{ 'rafi/tabstrip.nvim', lazy = false, priority = 98, opts = true },

	-----------------------------------------------------------------------------
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		dependencies = {
			'MunifTanjim/nui.nvim',
			'rcarriga/nvim-notify',
			'nvim-treesitter/nvim-treesitter',
		},
		-- stylua: ignore
		keys = {
			{ '<S-Enter>', function() require('noice').redirect(tostring(vim.fn.getcmdline())) end, mode = 'c', desc = 'Redirect Cmdline' },
			{ '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
			{ '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
			{ '<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All' },
			{ '<c-f>', function() if not require('noice.lsp').scroll(4) then return '<c-f>' end end, silent = true, expr = true, desc = 'Scroll forward', mode = {'i', 'n', 's'} },
			{ '<c-b>', function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end, silent = true, expr = true, desc = 'Scroll backward', mode = {'i', 'n', 's'}},
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
			messages = {
				view_search = false,
			},
			routes = {
				-- See :h ui-messages
				{
					filter = { event = 'msg_show', find = '%d+L, %d+B$' },
					view = 'mini',
				},
				{
					filter = { event = 'msg_show', find = '^Hunk %d+ of %d+$' },
					view = 'mini',
				},
				{
					filter = { event = 'notify', find = '^No code actions available$' },
					view = 'mini',
				},
				{
					filter = { event = 'notify', find = '^No information available$' },
					opts = { skip = true },
				},
				{
					filter = { event = 'msg_show', find = '^%d+ change;' },
					opts = { skip = true },
				},
				{
					filter = { event = 'msg_show', find = '^%d+ %a+ lines' },
					opts = { skip = true },
				},
				{
					filter = { event = 'msg_show', find = '^%d+ lines yanked$' },
					opts = { skip = true },
				},
				{
					filter = { event = 'msg_show', kind = 'emsg', find = 'E490' },
					opts = { skip = true },
				},
				{
					filter = { event = 'msg_show', kind = 'quickfix' },
					view = 'mini',
				},
				{
					filter = { event = 'msg_show', kind = 'search_count' },
					view = 'mini',
				},
				{
					filter = { event = 'msg_show', kind = 'wmsg' },
					view = 'mini',
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
			commands = {
				all = {
					view = 'split',
					opts = { enter = true, format = 'details' },
					filter = {},
				},
			},
			---@type NoiceConfigViews
			views = {
				mini = {
					zindex = 100,
					win_options = { winblend = 0 },
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'stevearc/dressing.nvim',
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require('lazy').load({ plugins = { 'dressing.nvim' } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require('lazy').load({ plugins = { 'dressing.nvim' } })
				return vim.ui.input(...)
			end
		end,
	},

	-----------------------------------------------------------------------------
	{
		'SmiteshP/nvim-navic',
		keys = {
			{
				'<Leader>tf',
				function()
					if vim.b.navic_winbar then
						vim.b.navic_winbar = false
						vim.opt_local.winbar = ''
					else
						vim.b.navic_winbar = true
						vim.opt_local.winbar = '%#NavicIconsFile# %t %* '
							.. "%{%v:lua.require'nvim-navic'.get_location()%}"
					end
				end,
				desc = 'Toggle structure panel',
			},
		},
		init = function()
			vim.g.navic_silence = true

			---@param client lsp.Client
			---@param buffer integer
			require('rafi.lib.utils').on_attach(function(client, buffer)
				if client.server_capabilities.documentSymbolProvider then
					require('nvim-navic').attach(client, buffer)
				end
			end)
		end,
		opts = function()
			return {
				separator = '  ',
				highlight = true,
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
				desc = 'Dismiss all Notifications',
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
			local Util = require('rafi.lib.utils')
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
		keys = {
			{ 'm/', '<cmd>MarksListAll<CR>', desc = 'Marks from all opened buffers' },
		},
		opts = {
			sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
			bookmark_1 = { sign = '󰈼' }, -- ⚐ ⚑ 󰈻 󰈼 󰈽 󰈾 󰈿 󰉀
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
			{ '<Leader>ue', '<cmd>IndentBlanklineToggle<CR>' },
		},
		opts = {
			show_trailing_blankline_indent = false,
			disable_with_nolist = true,
			show_foldtext = false,
			char_priority = 100,
			show_current_context = true,
			show_current_context_start = false,
			filetype_exclude = {
				'lspinfo',
				'checkhealth',
				'git',
				'gitcommit',
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
		'tenxsoydev/tabs-vs-spaces.nvim',
		event = { 'BufReadPost', 'BufNewFile' },
		config = true,
	},

	-----------------------------------------------------------------------------
	{
		't9md/vim-quickhl',
		keys = {
			{
				'<Leader>mt',
				'<Plug>(quickhl-manual-this)',
				mode = { 'n', 'x' },
				desc = 'Highlight word',
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
		'uga-rosa/ccc.nvim',
		event = 'FileType',
		keys = {
			{ '<Leader>cp', '<cmd>CccPick<CR>', desc = 'Color-picker' },
		},
		opts = {
			highlighter = {
				auto_enable = true,
				lsp = true,
				excludes = { 'lazy', 'mason', 'help', 'neo-tree' },
			},
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
