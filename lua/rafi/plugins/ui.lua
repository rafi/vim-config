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
	-- Fancy notification manager
	{
		'rcarriga/nvim-notify',
		priority = 9000,
		keys = {
			{
				'<leader>un',
				function()
					require('notify').dismiss({ silent = true, pending = true })
				end,
				desc = 'Dismiss All Notifications',
			},
		},
		opts = {
			stages = 'static',
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
			if not LazyVim.has('noice.nvim') then
				LazyVim.on_very_lazy(function()
					vim.notify = require('notify')
				end)
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
			{ '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
			{ '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
			{ '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
			{ '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
			{ '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
			{ '<leader>tp', '<Cmd>BufferLinePick<CR>', desc = 'Tab Pick' },
			{ '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
			{ ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
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
				close_command = function(n)
					LazyVim.ui.bufremove(n)
				end,
				right_mouse_command = function(n)
					LazyVim.ui.bufremove(n)
				end,
				diagnostics_indicator = function(_, _, diag)
					local icons = LazyVim.config.icons.diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
						.. (diag.warning and icons.Warn .. diag.warning or '')
					return vim.trim(ret)
				end,
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
						filetype = 'neo-tree',
						text = 'Neo-tree',
						highlight = 'Directory',
						text_align = 'center',
					},
				},
				---@param opts bufferline.IconFetcherOpts
				get_element_icon = function(opts)
					return LazyVim.config.icons.ft[opts.filetype]
				end,
			},
		},
		config = function(_, opts)
			require('bufferline').setup(opts)
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
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
	-- Helper for removing buffers
	{
		'echasnovski/mini.bufremove',
		opts = {},
		-- stylua: ignore
		keys = {
			{ '<leader>bd', function() require('mini.bufremove').delete(0, false) end, desc = 'Delete Buffer', },
		},
	},

	-----------------------------------------------------------------------------
	-- Replaces the UI for messages, cmdline and the popupmenu
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
		keys = {
			{ '<leader>sn', '', desc = '+noice' },
			{ '<S-Enter>', function() require('noice').redirect(tostring(vim.fn.getcmdline())) end, mode = 'c', desc = 'Redirect Cmdline' },
			{ '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
			{ '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
			{ '<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All' },
			{ '<leader>snt', function() require('noice').cmd('pick') end, desc = 'Noice Picker (Telescope/FzfLua)' },
			{ '<C-f>', function() if not require('noice.lsp').scroll(4) then return '<C-f>' end end, silent = true, expr = true, desc = 'Scroll Forward', mode = {'i', 'n', 's'} },
			{ '<C-b>', function() if not require('noice.lsp').scroll(-4) then return '<C-b>' end end, silent = true, expr = true, desc = 'Scroll Backward', mode = {'i', 'n', 's'}},
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
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
		config = function(_, opts)
			-- HACK: noice shows messages from before it was enabled,
			-- but this is not ideal when Lazy is installing plugins,
			-- so clear the messages in this case.
			if vim.o.filetype == 'lazy' then
				vim.cmd([[messages clear]])
			end
			require('noice').setup(opts)
		end,
	},

	-----------------------------------------------------------------------------
	-- Shows your current code context in winbar/statusline
	{
		'SmiteshP/nvim-navic',
		keys = {
			{
				'<Leader>uB',
				function()
					if vim.b.navic_winbar then
						vim.b['navic_winbar'] = false
						vim.opt_local.winbar = ''
					else
						vim.b['navic_winbar'] = true
						vim.opt_local.winbar = '%#NavicIconsFile# %t %* '
							.. "%{%v:lua.require'nvim-navic'.get_location()%}"
					end
				end,
				desc = 'Breadcrumbs toggle',
			},
		},
		init = function()
			vim.g.navic_silence = true
			LazyVim.lsp.on_attach(function(client, buffer)
				if client.supports_method('textDocument/documentSymbol') then
					require('nvim-navic').attach(client, buffer)
				end
			end)
		end,
		opts = function()
			return {
				separator = '  ',
				highlight = true,
				depth_limit = 5,
				icons = require('lazyvim.config').icons.kinds,
				lazy_update_context = true,
			}
		end,
	},

	-----------------------------------------------------------------------------
	-- Interacting with and manipulating marks
	{
		'chentoast/marks.nvim',
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
			},
			scope = { enabled = false },
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
	-- Visualize and operate on indent scope
	{
		'echasnovski/mini.indentscope',
		event = 'LazyFile',
		opts = function(_, opts)
			opts.symbol = '│' -- ▏│
			opts.options = { try_as_border = true }
			opts.draw = {
				delay = 0,
				animation = require('mini.indentscope').gen_animation.none(),
			}
		end,
		init = function()
			vim.api.nvim_create_autocmd('FileType', {
				pattern = {
					'alpha',
					'dashboard',
					'fzf',
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
					'trouble',
				},
				callback = function()
					vim.b['miniindentscope_disable'] = true
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- Create key bindings that stick
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		-- stylua: ignore
		opts = {
			icons = {
				separator = ' 󰁔 ',
			},
			defaults = {
				mode = { 'n', 'v' },
				[';'] = { name = '+telescope' },
				[';d'] = { name = '+lsp' },
				['g'] = { name = '+goto' },
				['gz'] = { name = '+surround' },
				[']'] = { name = '+next' },
				['['] = { name = '+prev' },

				['<leader>b']  = { name = '+buffer' },
				['<leader>c']  = { name = '+code' },
				['<leader>ch'] = { name = '+calls' },
				['<leader>f']  = { name = '+file/find' },
				['<leader>fw'] = { name = '+workspace' },
				['<leader>g']  = { name = '+git' },
				['<leader>h']  = { name = '+hunks', ['_'] = 'which_key_ignore' },
				['<leader>ht'] = { name = '+toggle' },
				['<leader>m']  = { name = '+tools' },
				['<leader>md'] = { name = '+diff' },
				['<leader>s']  = { name = '+search' },
				['<leader>sn'] = { name = '+noice' },
				['<leader>t']  = { name = '+toggle/tools' },
				['<leader>u']  = { name = '+ui' },
				['<leader>x']  = { name = '+diagnostics/quickfix' },
				['<leader>z']  = { name = '+notes' },
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
	-- Better quickfix window
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
}
