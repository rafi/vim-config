-- Plugins: UI
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Lua fork of vim-devicons
	{ 'nvim-tree/nvim-web-devicons', lazy = false },

	-----------------------------------------------------------------------------
	-- UI Component Library
	{ 'MunifTanjim/nui.nvim', lazy = false },

	-----------------------------------------------------------------------------
	-- Fancy notification manager for NeoVim
	{
		'rcarriga/nvim-notify',
		priority = 9000,
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
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
		init = function()
			-- When noice is not enabled, install notify on VeryLazy
			local Util = require('lazyvim.util')
			if not Util.has('noice.nvim') then
				Util.on_very_lazy(function()
					vim.notify = require('notify')
				end)
			end
		end,
	},

	-----------------------------------------------------------------------------
	-- Improve the default vim-ui interfaces
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
	-- Snazzy tab/bufferline
	{
		'akinsho/bufferline.nvim',
		event = 'VeryLazy',
		enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
		keys = {
			{ '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle pin' },
			{ '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete non-pinned buffers' },
			{ '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete other buffers' },
			{ '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete buffers to the right' },
			{ '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete buffers to the left' },
			{ '<leader>tp', '<Cmd>BufferLinePick<CR>', desc = 'Tab Pick' },
			{ '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
			{ ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
		},
		opts = {
			options = {
				mode = 'tabs',
				separator_style = 'slant',
				show_close_icon = false,
				show_buffer_close_icons = false,
				diagnostics = 'nvim_lsp',
				-- show_tab_indicators = true,
				-- enforce_regular_tabs = true,
				always_show_bufferline = true,
				-- indicator = {
				-- 	style = 'underline',
				-- },
				diagnostics_indicator = function(_, _, diag)
					local icons = require('lazyvim.config').icons.diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
						.. (diag.warning and icons.Warn .. diag.warning or '')
					return vim.trim(ret)
				end,
				custom_areas = {
					right = function()
						local result = {}
						local root = require('lazyvim.util').root()
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
						filetype = 'neo-tree',
						text = 'Neo-tree',
						highlight = 'Directory',
						text_align = 'center',
					},
				},
			},
		},
		config = function(_, opts)
			require('bufferline').setup(opts)
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd('BufAdd', {
				callback = function()
					vim.schedule(function()
						---@diagnostic disable-next-line: undefined-global
						pcall(nvim_bufferline)
					end)
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- Replaces the UI for messages, cmdline and the popupmenu
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
		keys = {
			{ '<S-Enter>', function() require('noice').redirect(tostring(vim.fn.getcmdline())) end, mode = 'c', desc = 'Redirect Cmdline' },
			{ '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
			{ '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
			{ '<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All' },
			{ '<C-f>', function() if not require('noice.lsp').scroll(4) then return '<C-f>' end end, silent = true, expr = true, desc = 'Scroll forward', mode = {'i', 'n', 's'} },
			{ '<C-b>', function() if not require('noice.lsp').scroll(-4) then return '<C-b>' end end, silent = true, expr = true, desc = 'Scroll backward', mode = {'i', 'n', 's'}},
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
					filter = {
						event = 'msg_show',
						any = {
							{ find = '%d+L, %d+B' },
							{ find = '^%d+ changes?; after #%d+' },
							{ find = '^%d+ changes?; before #%d+' },
							{ find = '^Hunk %d+ of %d+$' },
							{ find = '^%d+ fewer lines;?' },
							{ find = '^%d+ more lines?;?' },
							{ find = '^%d+ line less;?' },
							{ find = '^Already at newest change' },
							{ kind = 'wmsg' },
							{ kind = 'emsg', find = 'E486' },
							{ kind = 'quickfix' },
						},
					},
					view = 'mini',
				},
				{
					filter = {
						event = 'msg_show',
						any = {
							{ find = '^%d+ lines .ed %d+ times?$' },
							{ find = '^%d+ lines yanked$' },
							{ kind = 'emsg', find = 'E490' },
							{ kind = 'search_count' },
						},
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = 'notify',
						any = {
							{ find = '^No code actions available$' },
							{ find = '^No information available$' },
						},
					},
					view = 'mini',
				},
			},
			presets = {
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Shows your current code context in winbar/statusline
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
			require('lazyvim.util').lsp.on_attach(function(client, buffer)
				if client.supports_method('textDocument/documentSymbol') then
					require('nvim-navic').attach(client, buffer)
				end
			end)
		end,
		opts = function()
			return {
				separator = '  ',
				highlight = true,
				icons = require('lazyvim.config').icons.kinds,
			}
		end,
	},

	-----------------------------------------------------------------------------
	-- Interacting with and manipulating marks
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
	-- Visually display indent levels
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		event = 'LazyFile',
		keys = {
			{ '<Leader>ue', '<cmd>IBLToggle<CR>', desc = 'Toggle indent-lines' },
		},
		opts = {
			indent = {
				-- See more characters at :h ibl.config.indent.char
				char = '│', -- ▏│
				tab_char = '│',
				-- priority = 100, -- Display over folded lines
			},
			scope = { enabled = false },
			-- whitespace = {
			-- 	remove_blankline_trail = false,
			-- },
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
					'TelescopePrompt',
					'TelescopeResults',
					'terminal',
					'toggleterm',
					'Trouble',
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Active indent guide and indent text objects. When you're browsing
	-- code, this highlights the current level of indentation, and animates
	-- the highlighting.
	{
		'echasnovski/mini.indentscope',
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = 'LazyFile',
		opts = {
			symbol = '│', -- ▏│
			options = { try_as_border = true },
			draw = { delay = 200 },
		},
		init = function()
			vim.api.nvim_create_autocmd('FileType', {
				pattern = {
					'alpha',
					'dashboard',
					'help',
					'lazy',
					'lazyterm',
					'man',
					'mason',
					'neo-tree',
					'notify',
					'Outline',
					'toggleterm',
					'Trouble',
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- Create key bindings that stick
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		opts = {
			icons = { separator = ' 󰁔 ' },
			plugins = { spelling = true },
			defaults = {
				mode = { 'n', 'v' },
				-- [';'] = { name = '+telescope' },
				-- [';d'] = { name = '+lsp/todo' },
				-- ['g'] = { name = '+goto' },
				-- ['gz'] = { name = '+surround' },
				-- [']'] = { name = '+next' },
				-- ['['] = { name = '+prev' },

				['<leader>b'] = { name = '+buffer' },
				['<leader>c'] = { name = '+code' },
				['<leader>f'] = { name = '+file/find' },
				['<leader>g'] = { name = '+git' },
				['<leader>h'] = { name = '+hunks' },
				['<leader>m'] = { name = '+tools' },
				['<leader>s'] = { name = '+search' },
				['<leader>t'] = { name = '+toggle/tools' },
				['<leader>u'] = { name = '+ui' },
				['<leader>x'] = { name = '+diagnostics/quickfix' },
				['<leader>z'] = { name = '+notes' },
			},
		},
		config = function(_, opts)
			local wk = require('which-key')
			wk.setup(opts)
			wk.register(opts.defaults)
		end,
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
	-- Better quickfix window in Neovim
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
	-- Super powerful color picker/colorizer plugin
	{
		'uga-rosa/ccc.nvim',
		event = 'FileType',
		keys = {
			{ '<Leader>mc', '<cmd>CccPick<CR>', desc = 'Color-picker' },
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
	-- Calendar application
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
