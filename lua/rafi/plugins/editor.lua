-- Plugins: Editor
-- https://github.com/rafi/vim-config

local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'

return {

	-----------------------------------------------------------------------------
	{ 'christoomey/vim-tmux-navigator', lazy = false, cond = not is_windows },
	{ 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion' },
	{ 'lambdalisue/suda.vim', event = 'BufRead' },

	-----------------------------------------------------------------------------
	{
		'tpope/vim-sleuth',
		lazy = false,
		priority = 500,
		init = function ()
			vim.g.sleuth_no_filetype_indent_on = 1
			vim.g.sleuth_gitcommit_heuristics = 0
		end
	},

	-----------------------------------------------------------------------------
	{
		'olimorris/persisted.nvim',
		event = 'VimEnter',
		priority = 10000,
		init = function()
			vim.g.in_pager_mode = false
			vim.api.nvim_create_autocmd('StdinReadPre', {
				group = vim.api.nvim_create_augroup('rafi_persisted', {}),
				callback = function()
					vim.g.in_pager_mode = true
				end
			})
		end,
		opts = {
			autoload = true,
			follow_cwd = false,
			ignored_dirs = { '~/.cache', vim.env.TMPDIR or '/tmp' },
			should_autosave = function()
				-- Do not autosave if git commit/rebase session. Causes a race-condition
				return vim.env.GIT_EXEC_PATH == nil
			end,
		},
		config = function(_, opts)
			-- Do not autoload if stdin has been provided, or git commit session.
			if vim.g.in_pager_mode or vim.env.GIT_EXEC_PATH ~= nil then
				opts.autoload = false
			end
			require('persisted').setup(opts)

			vim.api.nvim_create_autocmd('User', {
				pattern = 'PersistedSavePre',
				group = 'rafi_persisted',
				callback = function()
					-- Detect if window is owned by plugin by checking buftype.
					local current_buffer = vim.api.nvim_get_current_buf()
					for _, win in ipairs(vim.fn.getwininfo()) do
						local buftype = vim.api.nvim_buf_get_option(win.bufnr, 'buftype')
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

			-- When switching to a different session using Telescope, save and stop
			-- current session to avoid previous session to be overwritten.
			vim.api.nvim_create_autocmd('User', {
				pattern = 'PersistedTelescopeLoadPre',
				group = 'rafi_persisted',
				callback = function()
					require('persisted').save()
					require('persisted').stop()
				end
			})

			-- When switching to a different session using Telescope, after new
			-- session has been loaded, start it - so it will be auto-saved.
			vim.api.nvim_create_autocmd('User', {
				pattern = 'PersistedTelescopeLoadPost',
				group = 'rafi_persisted',
				callback = function(session)
					require('persisted').start()
					print('Started session ' .. session.data.name)
				end
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
			filetypes_denylist = { 'dirvish', 'fugitive', 'neo-tree', },
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
					buffer = buffer
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
			{ '<Leader>gu', '<cmd>UndotreeToggle<CR>', desc = 'Undo Tree' }
		}
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
		keys = {
			{ 'ss', '<Plug>(leap-forward-to)', mode = { 'n', 'x', 'o' }, desc = 'Leap forward to' },
			{ 'SS', '<Plug>(leap-backward-to)', mode = { 'n', 'x', 'o' }, desc = 'Leap backward to' },
		},
		config = true,
	},

	-----------------------------------------------------------------------------
	{
		'kana/vim-niceblock',
		keys = {
			{ 'I',  '<Plug>(niceblock-I)',  silent = true, mode = 'x', desc = 'Blockwise Insert' },
			{ 'gI', '<Plug>(niceblock-gI)', silent = true, mode = 'x', desc = 'Blockwise Insert' },
			{ 'A',  '<Plug>(niceblock-A)',  silent = true, mode = 'x', desc = 'Blockwise Append' },
		},
		init = function()
			vim.g.niceblock_no_default_key_mappings = 0
		end
	},

	-----------------------------------------------------------------------------
	{
		'haya14busa/vim-edgemotion',
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
			},
		}
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
		opts = { window = { border = 'rounded' }},
	},

	-----------------------------------------------------------------------------
	{
		'folke/todo-comments.nvim',
		dependencies = 'nvim-telescope/telescope.nvim',
		keys = {
			{ '<LocalLeader>dt', '<cmd>TodoTelescope<CR>', desc = 'todo' },
			{ '<leader>xt', '<cmd>TodoTrouble<CR>', desc = 'Todo (Trouble)' },
			{ '<leader>xT', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
		},
		opts = { signs = false },
	},

	-----------------------------------------------------------------------------
	{
		'folke/trouble.nvim',
		cmd = { 'Trouble', 'TroubleToggle' },
		opts = { use_diagnostic_signs = true },
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
			{ '<Leader>gv', '<cmd>DiffviewOpen<CR>', desc = 'Diff View' }
		},
		config = function()
			local actions = require('diffview.actions')
			vim.cmd [[
				augroup rafi_diffview
					autocmd!
					autocmd WinEnter,BufEnter diffview://* setlocal cursorline
					autocmd WinEnter,BufEnter diffview:///panels/* setlocal winhighlight=CursorLine:WildMenu
				augroup END
			]]

			require('diffview').setup({
				enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
				keymaps = {
					view = {
						{'n', 'q',       '<cmd>DiffviewClose<CR>' },
						{'n', '<tab>',   actions.select_next_entry },
						{'n', '<s-tab>', actions.select_prev_entry },
						{'n', ';a',      actions.focus_files },
						{'n', ';e',      actions.toggle_files },
					},
					file_panel = {
						{'n', 'q',       '<cmd>DiffviewClose<CR>' },
						{'n', 'j',       actions.next_entry },
						{'n', '<down>',  actions.next_entry },
						{'n', 'k',       actions.prev_entry },
						{'n', '<up>',    actions.prev_entry },
						{'n', 'h',       actions.prev_entry },
						{'n', 'l',       actions.select_entry },
						{'n', '<cr>',    actions.select_entry },
						{'n', 'o',       actions.focus_entry },
						{'n', 'gf',      actions.goto_file },
						{'n', 'sg',      actions.goto_file_split },
						{'n', 'st',      actions.goto_file_tab },
						{'n', 'r',       actions.refresh_files },
						{'n', 'R',       actions.refresh_files },
						{'n', '<c-r>',   actions.refresh_files },
						{'n', '<tab>',   actions.select_next_entry },
						{'n', '<s-tab>', actions.select_prev_entry },
						{'n', ';a',      actions.focus_files },
						{'n', ';e',      actions.toggle_files },
					},
					file_history_panel = {
						{'n', 'o',    actions.focus_entry },
						{'n', 'l',    actions.select_entry },
						{'n', '<cr>', actions.select_entry },
						{'n', 'O',    actions.options },
					},
					option_panel = {
						{'n', '<tab>', actions.select },
						{'n', 'q',     actions.close },
					},
				}
			})
		end
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
					vim.opt_local.winhighlight = 'CursorLine:WildMenu'
				end
			})
		end
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
				desc = 'Jump to window with selection',
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
				desc = 'Swap window with selection',
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
			{ ',ht', '<Plug>RestNvim', desc = 'Execute HTTP request' }
		},
		opts = { skip_ssl_verification = true },
		init = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi_rest', {}),
				pattern = 'httpResult',
				callback = function(event)
					vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = event.buf })
				end
			})
		end
	},

	-----------------------------------------------------------------------------
	{
		'mickael-menu/zk-nvim',
		name = 'zk',
		ft = 'markdown',
		cmd = {
			'ZkIndex', 'ZkNew', 'ZkNotes', 'ZkTags',
			'ZkNewFromTitleSelection', 'ZkNewFromContentSelection',
		},
		keys = {
			{ '<leader>zn', "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = 'Zk New' },
			{ '<leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", desc = 'Zk Notes' },
			{ '<leader>zt', '<Cmd>ZkTags<CR>', desc = 'Zk Tags' },
			{ '<leader>zf', "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>", desc = 'Zk Search' },
			{ '<leader>zf', ":'<,'>ZkMatch<CR>", mode = 'x', desc = 'Zk Match' },
			{ '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', desc = 'Zk references' },
			{ '<leader>zl', '<Cmd>ZkLinks<CR>', desc = 'Zk Links' },
		},
		opts = { picker = 'telescope' }
	},

	-----------------------------------------------------------------------------
	{
		'windwp/nvim-spectre',
		keys = {
			{ '<Leader>so', function() require('spectre').open() end, desc = 'Spectre' },
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
