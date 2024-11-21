-- Plugins: UI
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Icon provider
	{
		'echasnovski/mini.icons',
		lazy = true,
		opts = {
			file = {
				['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
				['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
			},
			filetype = {
				dotenv = { glyph = '', hl = 'MiniIconsYellow' },
			},
		},
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			package.preload['nvim-web-devicons'] = function()
				require('mini.icons').mock_nvim_web_devicons()
				return package.loaded['nvim-web-devicons']
			end
		end,
	},

	-----------------------------------------------------------------------------
	-- UI Component Library
	{ 'MunifTanjim/nui.nvim', lazy = false },

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
				-- stylua: ignore
				close_command = function(n) Snacks.bufdelete(n) end,
				-- stylua: ignore
				right_mouse_command = function(n) Snacks.bufdelete(n) end,
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
			{ '<leader>snd', function() require('noice').cmd('dismiss') end, desc = 'Dismiss All' },
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
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
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
	-- Visually display indent levels
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		event = 'LazyFile',
		opts = function()
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
		cmd = 'WhichKey',
		keys = {
			{
				'<leader>bk',
				function()
					require('which-key').show({ global = false })
				end,
				desc = 'Buffer Keymaps (which-key)',
			},
			{
				'<C-w><Space>',
				function()
					require('which-key').show({ keys = '<c-w>', loop = true })
				end,
				desc = 'Window Hydra Mode (which-key)',
			},
		},
		opts_extend = { 'spec' },
		-- stylua: ignore
		opts = {
			defaults = {},
			icons = {
				breadcrumb = '»',
				separator = '󰁔  ', -- ➜
			},
			delay = function(ctx)
				return ctx.plugin and 0 or 400
			end,
			spec = {
				{
					mode = { 'n', 'v' },
					{ '[', group = 'prev' },
					{ ']', group = 'next' },
					{ 'g', group = 'goto' },
					{ 'gz', group = 'surround' },
					{ 'z', group = 'fold' },
					{ ';', group = '+telescope' },
					{ ';d', group = '+lsp' },
					{
						'<leader>b',
						group = 'buffer',
						expand = function()
							return require('which-key.extras').expand.buf()
						end,
					},
					{ '<leader>c', group = 'code' },
					{ '<leader>ch', group = 'calls' },
					{ '<leader>f', group = 'file/find' },
					{ '<leader>fw', group = 'workspace' },
					{ '<leader>g', group = 'git' },
					{ '<leader>h', group = 'hunks', icon = { icon = ' ', color = 'red' } },
					{ '<leader>ht', group = 'toggle' },
					{ '<leader>m', group = 'tools' },
					{ '<leader>md', group = 'diff' },
					{ '<leader>q', group = 'quit/session' },
					{ '<leader>s', group = 'search' },
					{ '<leader>sn', group = 'noice' },
					{ '<leader>t', group = 'toggle/tools' },
					{ '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
					{ '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
					{ '<leader>z', group = 'notes' },

					-- Better descriptions
					{ 'gx', desc = 'Open with system app' },
				},
			},
		},
		config = function(_, opts)
			local wk = require('which-key')
			wk.setup(opts)
			if not vim.tbl_isempty(opts.defaults) then
				LazyVim.warn(
					'which-key: opts.defaults is deprecated. Please use opts.spec instead.'
				)
				wk.register(opts.defaults)
			end
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
		-- stylua: ignore
		keys = {
			{ '<Leader>mt', '<Plug>(quickhl-manual-this)', mode = { 'n', 'x' }, desc = 'Highlight word' },
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
