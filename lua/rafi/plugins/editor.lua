-- Plugins: Editor
-- https://github.com/rafi/vim-config

local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'

return {

	-----------------------------------------------------------------------------
	{ 'nmac427/guess-indent.nvim', lazy = false, priority = 50, config = true },
	{ 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion' },
	{ 'lambdalisue/suda.vim', event = 'BufRead' },

	-----------------------------------------------------------------------------
	{
		'christoomey/vim-tmux-navigator',
		lazy = false,
		cond = not is_windows,
		-- stylua: ignore
		keys = {
			{ '<C-h>', '<cmd>TmuxNavigateLeft<CR>', mode = { 'n', 't' }, silent = true, desc = 'Jump to left pane' },
			{ '<C-j>', '<cmd>TmuxNavigateDown<CR>', mode = { 'n', 't' }, silent = true, desc = 'Jump to lower pane' },
			{ '<C-k>', '<cmd>TmuxNavigateUp<CR>', mode = { 'n', 't' }, silent = true, desc = 'Jump to upper pane' },
			{ '<C-l>', '<cmd>TmuxNavigateRight<CR>', mode = { 'n', 't' }, silent = true, desc = 'Jump to right pane' },
		},
		init = function()
			vim.g.tmux_navigator_no_mappings = true
		end,
	},

	-----------------------------------------------------------------------------
	{
		'olimorris/persisted.nvim',
		event = 'VimEnter',
		priority = 1000,
		opts = {
			autoload = true,
			follow_cwd = false,
			ignored_dirs = { '/usr', '/opt', '~/.cache', vim.env.TMPDIR or '/tmp' },
			should_autosave = function()
				-- Do not autosave if git commit/rebase session.
				return vim.env.GIT_EXEC_PATH == nil
			end,
		},
		config = function(_, opts)
			if vim.g.in_pager_mode or vim.env.GIT_EXEC_PATH ~= nil then
				-- Do not autoload if stdin has been provided, or git commit session.
				opts.autoload = false
			end
			require('persisted').setup(opts)
		end,
		init = function()
			-- Detect if stdin has been provided.
			vim.g.in_pager_mode = false
			vim.api.nvim_create_autocmd('StdinReadPre', {
				group = vim.api.nvim_create_augroup('rafi_persisted', {}),
				callback = function()
					vim.g.in_pager_mode = true
				end,
			})
			-- Close all floats before loading a session. (e.g. Lazy.nvim)
			vim.api.nvim_create_autocmd('User', {
				group = 'rafi_persisted',
				pattern = 'PersistedLoadPre',
				callback = function()
					for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
						if vim.api.nvim_win_get_config(win).zindex then
							vim.api.nvim_win_close(win, false)
						end
					end
				end,
			})
			-- Close all plugin owned buffers before saving a session.
			vim.api.nvim_create_autocmd('User', {
				pattern = 'PersistedSavePre',
				group = 'rafi_persisted',
				callback = function()
					-- Detect if window is owned by plugin by checking buftype.
					local current_buffer = vim.api.nvim_get_current_buf()
					for _, win in ipairs(vim.fn.getwininfo()) do
						local buftype = vim.bo[win.bufnr].buftype
						if buftype ~= '' and buftype ~= 'help' then
							-- Delete plugin owned window buffers.
							if win.bufnr == current_buffer then
								-- Jump to previous window if current window is not a real file
								vim.cmd.wincmd('p')
							end
							vim.api.nvim_buf_delete(win.bufnr, {})
						end
					end
				end,
			})
			-- Before switching to a different session using Telescope, save and stop
			-- current session to avoid previous session to be overwritten.
			vim.api.nvim_create_autocmd('User', {
				pattern = 'PersistedTelescopeLoadPre',
				group = 'rafi_persisted',
				callback = function()
					require('persisted').save()
					require('persisted').stop()
				end,
			})
			-- After switching to a different session using Telescope, start it so it
			-- will be auto-saved.
			vim.api.nvim_create_autocmd('User', {
				pattern = 'PersistedTelescopeLoadPost',
				group = 'rafi_persisted',
				callback = function(session)
					require('persisted').start()
					print('Started session ' .. session.data.name)
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	{
		'RRethy/vim-illuminate',
		event = { 'BufReadPost', 'BufNewFile' },
		opts = {
			delay = 200,
			under_cursor = false,
			modes_allowlist = { 'n', 'no', 'nt' },
			filetypes_denylist = { 'fugitive', 'neo-tree', 'SidebarNvim', 'git' },
		},
		keys = {
			{ ']]', desc = 'Next Reference' },
			{ '[[', desc = 'Prev Reference' },
		},
		config = function(_, opts)
			require('illuminate').configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set('n', key, function()
					require('illuminate')['goto_' .. dir .. '_reference'](false)
				end, {
					desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference',
					buffer = buffer,
				})
			end

			map(']]', 'next')
			map('[[', 'prev')

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi_illuminate', {}),
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map(']]', 'next', buffer)
					map('[[', 'prev', buffer)
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	{
		'mbbill/undotree',
		cmd = 'UndotreeToggle',
		keys = {
			{ '<Leader>gu', '<cmd>UndotreeToggle<CR>', desc = 'Undo Tree' },
		},
	},

	-----------------------------------------------------------------------------
	{
		'ggandor/flit.nvim',
		keys = function()
			---@type LazyKeys[]
			local ret = {}
			for _, key in ipairs({ 'f', 'F', 't', 'T' }) do
				ret[#ret + 1] = { key, mode = { 'n', 'x', 'o' }, desc = key }
			end
			return ret
		end,
		opts = { labeled_modes = 'nx' },
	},

	-----------------------------------------------------------------------------
	{
		'ggandor/leap.nvim',
		-- stylua: ignore
		keys = {
			{ 'ss', '<Plug>(leap-forward-to)', mode = { 'n', 'x', 'o' }, desc = 'Leap forward to' },
			{ 'sS', '<Plug>(leap-backward-to)', mode = { 'n', 'x', 'o' }, desc = 'Leap backward to' },
			{ 'SS', '<Plug>(leap-from-window)', mode = { 'n', 'x', 'o' }, desc = 'Leap from windows' },
		},
		config = true,
	},

	-----------------------------------------------------------------------------
	{
		'kana/vim-niceblock',
		-- stylua: ignore
		keys = {
			{ 'I',  '<Plug>(niceblock-I)',  silent = true, mode = 'x', desc = 'Blockwise Insert' },
			{ 'gI', '<Plug>(niceblock-gI)', silent = true, mode = 'x', desc = 'Blockwise Insert' },
			{ 'A',  '<Plug>(niceblock-A)',  silent = true, mode = 'x', desc = 'Blockwise Append' },
		},
		init = function()
			vim.g.niceblock_no_default_key_mappings = 0
		end,
	},

	-----------------------------------------------------------------------------
	{
		'haya14busa/vim-edgemotion',
		-- stylua: ignore
		keys = {
			{ 'gj', '<Plug>(edgemotion-j)', mode = { 'n', 'x' }, desc = 'Move to bottom edge' },
			{ 'gk', '<Plug>(edgemotion-k)', mode = { 'n', 'x' }, desc = 'Move to top edge' },
		},
	},

	-----------------------------------------------------------------------------
	{
		'folke/zen-mode.nvim',
		cmd = 'ZenMode',
		keys = {
			{ '<Leader>zz', '<cmd>ZenMode<CR>', noremap = true, desc = 'Zen Mode' },
		},
		opts = {
			plugins = {
				gitsigns = { enabled = true },
				tmux = { enabled = vim.env.TMUX ~= nil },
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'folke/which-key.nvim',
		cmd = 'WhichKey',
		opts = {
			plugins = { marks = false, registers = false },
			icons = { separator = '  ' },
		}
	},

	-----------------------------------------------------------------------------
	{
		'tversteeg/registers.nvim',
		cmd = 'Registers',
		keys = {
			{ '<C-r>', mode = 'i', desc = 'Reveal registers' },
			{ '"', mode = 'n', desc = 'Reveal registers' },
			{ '"', mode = 'x', desc = 'Reveal registers' },
		},
		opts = { window = { border = 'rounded' } },
	},

	-----------------------------------------------------------------------------
	{
		'folke/todo-comments.nvim',
		dependencies = 'nvim-telescope/telescope.nvim',
		-- stylua: ignore
		keys = {
			{ ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
			{ '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
			{ '<LocalLeader>dt', '<cmd>TodoTelescope<CR>', desc = 'todo' },
			{ '<leader>xt', '<cmd>TodoTrouble<CR>', desc = 'Todo (Trouble)' },
			{ '<leader>xT', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
			{ '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
			{ '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme' },
		},
		opts = { signs = false },
	},

	-----------------------------------------------------------------------------
	{
		'folke/trouble.nvim',
		cmd = { 'Trouble', 'TroubleToggle' },
		opts = { use_diagnostic_signs = true },
		-- stylua: ignore
		keys = {
			{ '<leader>e', '<cmd>TroubleToggle document_diagnostics<CR>', noremap = true, desc = 'Document Diagnostics' },
			{ '<leader>r', '<cmd>TroubleToggle workspace_diagnostics<CR>', noremap = true, desc = 'Workspace Diagnostics' },
			{ '<leader>xq', '<cmd>TroubleToggle quickfix<CR>', noremap = true, desc = 'Trouble Quickfix' },
			{ '<leader>xl', '<cmd>TroubleToggle loclist<CR>', noremap = true, desc = 'Trouble Loclist' },
		},
	},

	-----------------------------------------------------------------------------
	{
		'sindrets/diffview.nvim',
		cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
		keys = {
			{ '<Leader>gv', '<cmd>DiffviewOpen<CR>', desc = 'Diff View' },
		},
		opts = function()
			local actions = require('diffview.actions')
			vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
				group = vim.api.nvim_create_augroup('rafi_diffview', {}),
				pattern = 'diffview:///panels/*',
				callback = function()
					vim.wo.winhighlight = 'CursorLine:WildMenu'
				end,
			})

			return {
				enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
				keymaps = {
					view = {
						{ 'n', 'q', '<cmd>DiffviewClose<CR>' },
						{ 'n', '<Tab>', actions.select_next_entry },
						{ 'n', '<S-Tab>', actions.select_prev_entry },
						{ 'n', '<LocalLeader>a', actions.focus_files },
						{ 'n', '<LocalLeader>e', actions.toggle_files },
					},
					file_panel = {
						{ 'n', 'q', '<cmd>DiffviewClose<CR>' },
						{ 'n', 'h', actions.prev_entry },
						{ 'n', 'o', actions.focus_entry },
						{ 'n', 'gf', actions.goto_file },
						{ 'n', 'sg', actions.goto_file_split },
						{ 'n', 'st', actions.goto_file_tab },
						{ 'n', '<C-r>', actions.refresh_files },
						{ 'n', ';e', actions.toggle_files },
					},
					file_history_panel = {
						{ 'n', 'q', '<cmd>DiffviewClose<CR>' },
						{ 'n', 'o', actions.focus_entry },
						{ 'n', 'O', actions.options },
					},
				},
			}
		end,
	},

	-----------------------------------------------------------------------------
	{
		'akinsho/toggleterm.nvim',
		cmd = 'ToggleTerm',
		keys = {
			{
				'<C-\\>',
				mode = { 'n', 't' },
				silent = true,
				function()
					local venv = vim.b['virtual_env']
					local term = require('toggleterm.terminal').Terminal:new({
						env = venv and { VIRTUAL_ENV = venv } or nil,
						count = vim.v.count > 0 and vim.v.count or 1,
					})
					term:toggle()
				end,
				desc = 'Toggle terminal',
			},
		},
		opts = {
			open_mapping = false,
			float_opts = {
				border = 'curved',
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'simrat39/symbols-outline.nvim',
		cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen' },
		keys = {
			{ '<Leader>o', '<cmd>SymbolsOutline<CR>', desc = 'Symbols Outline' },
		},
		opts = {
			width = 30,
			autofold_depth = 0,
			keymaps = {
				hover_symbol = 'K',
				toggle_preview = 'p',
			},
		},
		init = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi_outline', {}),
				pattern = 'Outline',
				callback = function()
					vim.wo.winhighlight = 'CursorLine:WildMenu'
					vim.wo.signcolumn = 'auto'
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	{
		's1n7ax/nvim-window-picker',
		keys = {
			{
				'sp',
				function()
					local picked_window_id = require('window-picker').pick_window()
					if picked_window_id ~= nil then
						vim.api.nvim_set_current_win(picked_window_id)
					end
				end,
				desc = 'Pick window',
			},
			{
				'sw',
				function()
					local picked_window_id = require('window-picker').pick_window()
					if picked_window_id ~= nil then
						local current_winnr = vim.api.nvim_get_current_win()
						local current_bufnr = vim.api.nvim_get_current_buf()
						local other_bufnr = vim.api.nvim_win_get_buf(picked_window_id)
						vim.api.nvim_win_set_buf(current_winnr, other_bufnr)
						vim.api.nvim_win_set_buf(picked_window_id, current_bufnr)
					end
				end,
				desc = 'Swap picked window',
			},
		},
		opts = {
			use_winbar = 'smart',
			fg_color = '#ededed',
			current_win_hl_color = '#e35e4f',
			other_win_hl_color = '#44cc41',
		},
	},

	-----------------------------------------------------------------------------
	{
		'rest-nvim/rest.nvim',
		ft = 'http',
		keys = {
			{ ',ht', '<Plug>RestNvim', desc = 'Execute HTTP request' },
		},
		opts = { skip_ssl_verification = true },
	},

	-----------------------------------------------------------------------------
	{
		'mickael-menu/zk-nvim',
		name = 'zk',
		ft = 'markdown',
		cmd = { 'ZkNew', 'ZkNotes', 'ZkTags', 'ZkMatch' },
		-- stylua: ignore
		keys = {
			{ '<leader>zn', "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = 'Zk New' },
			{ '<leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", desc = 'Zk Notes' },
			{ '<leader>zt', '<Cmd>ZkTags<CR>', desc = 'Zk Tags' },
			{ '<leader>zf', "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>", desc = 'Zk Search' },
			{ '<leader>zf', ":'<,'>ZkMatch<CR>", mode = 'x', desc = 'Zk Match' },
			{ '<leader>zb', '<Cmd>ZkBacklinks<CR>', desc = 'Zk Backlinks' },
			{ '<leader>zl', '<Cmd>ZkLinks<CR>', desc = 'Zk Links' },
		},
		opts = { picker = 'telescope' },
	},

	-----------------------------------------------------------------------------
	{
		'nvim-pack/nvim-spectre',
		keys = {
			{
				'<Leader>sp',
				function()
					require('spectre').open()
				end,
				desc = 'Spectre',
			},
			{
				'<Leader>sp',
				function()
					require('spectre').open_visual({ select_word = true })
				end,
				mode = 'x',
				desc = 'Spectre Word',
			},
		},
		opts = {
			mapping = {
				['toggle_gitignore'] = {
					map = 'tg',
					cmd = "<cmd>lua require('spectre').change_options('gitignore')<CR>",
					desc = 'toggle gitignore',
				},
			},
			find_engine = {
				['rg'] = {
					cmd = 'rg',
					args = {
						'--color=never',
						'--no-heading',
						'--with-filename',
						'--line-number',
						'--column',
						'--max-columns=0',
						'--case-sensitive',
						'--hidden',
						'--no-ignore',
					},
					options = {
						['ignore-case'] = {
							value = '--ignore-case',
							icon = '[I]',
							desc = 'ignore case',
						},
						['hidden'] = {
							value = '--no-hidden',
							icon = '[H]',
							desc = 'hidden file',
						},
						['gitignore'] = {
							value = '--ignore',
							icon = '[G]',
							desc = 'gitignore',
						},
					},
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'echasnovski/mini.bufremove',
		main = 'mini.bufremove',
		config = true,
		keys = {
			{
				'<leader>bd', function()
					require('mini.bufremove').delete(0, false)
				end,
				desc = 'Delete Buffer'
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'mzlogin/vim-markdown-toc',
		cmd = { 'GenTocGFM', 'GenTocRedcarpet', 'GenTocGitLab', 'UpdateToc' },
		ft = 'markdown',
		init = function()
			vim.g.vmt_auto_update_on_save = 0
		end,
	},
}
