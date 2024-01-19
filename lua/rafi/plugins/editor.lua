-- Plugins: Editor
-- https://github.com/rafi/vim-config

local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'

return {

	-----------------------------------------------------------------------------
	-- Automatic indentation style detection
	{ 'nmac427/guess-indent.nvim', lazy = false, priority = 50, config = true },

	-- Display vim version numbers in docs
	{ 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion' },

	-- An alternative sudo for Vim and Neovim
	{ 'lambdalisue/suda.vim', event = 'BufRead' },

	-----------------------------------------------------------------------------
	-- Seamless navigation between tmux panes and vim splits
	{
		'christoomey/vim-tmux-navigator',
		lazy = false,
		cond = vim.env.TMUX and not is_windows,
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
	-- Simple lua plugin for automated session management
	{
		'folke/persistence.nvim',
		event = 'VimEnter',
		opts = {
			options = vim.opt_global.sessionoptions:get(),
			-- Enable to autoload session on startup, unless:
			-- * neovim was started with files as arguments
			-- * stdin has been provided
			-- * git commit/rebase session
			autoload = true,
		},
		init = function()
			-- Detect if stdin has been provided.
			vim.g.started_with_stdin = false
			vim.api.nvim_create_autocmd('StdinReadPre', {
				group = vim.api.nvim_create_augroup('rafi_persistence', {}),
				callback = function()
					vim.g.started_with_stdin = true
				end,
			})
			-- Autoload session on startup.
			local disabled_dirs = {
				vim.env.TMPDIR or '/tmp',
				'/private/tmp',
			}
			vim.api.nvim_create_autocmd('VimEnter', {
				group = 'rafi_persistence',
				once = true,
				nested = true,
				callback = function()
					local opts = require('lazyvim.util').opts('persistence.nvim')
					if not opts.autoload then
						return
					end
					local cwd = vim.loop.cwd() or vim.fn.getcwd()
					if
						cwd == nil
						or vim.fn.argc() > 0
						or vim.g.started_with_stdin
						or vim.env.GIT_EXEC_PATH ~= nil
					then
						require('persistence').stop()
						return
					end
					for _, path in pairs(disabled_dirs) do
						if cwd:sub(1, #path) == path then
							require('persistence').stop()
							return
						end
					end
					-- Close all floats before loading a session. (e.g. Lazy.nvim)
					for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
						if vim.api.nvim_win_get_config(win).zindex then
							vim.api.nvim_win_close(win, false)
						end
					end
					require('persistence').load()
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- Highlights other uses of the word under the cursor
	{
		'RRethy/vim-illuminate',
		event = { 'BufReadPost', 'BufNewFile' },
		opts = {
			delay = 200,
			under_cursor = false,
			modes_allowlist = { 'n', 'no', 'nt' },
			filetypes_denylist = {
				'DiffviewFileHistory',
				'DiffviewFiles',
				'fugitive',
				'git',
				'minifiles',
				'neo-tree',
				'Outline',
				'SidebarNvim',
			},
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
	-- Ultimate undo history visualizer
	{
		'mbbill/undotree',
		cmd = 'UndotreeToggle',
		keys = {
			{ '<Leader>gu', '<cmd>UndotreeToggle<CR>', desc = 'Undo Tree' },
		},
	},

	-----------------------------------------------------------------------------
	-- Search labels, enhanced character motions
	{
		'folke/flash.nvim',
		event = 'VeryLazy',
		vscode = true,
		opts = {},
		-- stylua: ignore
		keys = {
			{ 'ss', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
			{ 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
			{ 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
			{ 'R', mode = { 'x', 'o' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
			{ '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
		},
	},

	-----------------------------------------------------------------------------
	-- Jump to the edge of block
	{
		'haya14busa/vim-edgemotion',
		-- stylua: ignore
		keys = {
			{ 'gj', '<Plug>(edgemotion-j)', mode = { 'n', 'x' }, desc = 'Move to bottom edge' },
			{ 'gk', '<Plug>(edgemotion-k)', mode = { 'n', 'x' }, desc = 'Move to top edge' },
		},
	},

	-----------------------------------------------------------------------------
	-- Distraction-free coding for Neovim
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
	-- Highlight, list and search todo comments in your projects
	{
		'folke/todo-comments.nvim',
		event = 'LazyFile',
		dependencies = 'nvim-telescope/telescope.nvim',
		-- stylua: ignore
		keys = {
			{ ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
			{ '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
			{ '<leader>xt', '<cmd>TodoTrouble<CR>', desc = 'Todo (Trouble)' },
			{ '<leader>xT', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
			{ '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
			{ '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme' },
		},
		opts = { signs = false },
	},

	-----------------------------------------------------------------------------
	-- Pretty lists to help you solve all code diagnostics
	{
		'folke/trouble.nvim',
		cmd = { 'Trouble', 'TroubleToggle' },
		opts = { use_diagnostic_signs = true },
		-- stylua: ignore
		keys = {
			{ '<leader>xx', function() require('trouble').toggle() end, desc = 'Document Diagnostics (Trouble)' },
			{ '<leader>xd', function() require('trouble').toggle('document_diagnostics') end, desc = 'Document Diagnostics (Trouble)' },
			{ '<leader>xw', function() require('trouble').toggle('workspace_diagnostics') end, desc = 'Workspace Diagnostics (Trouble)' },
			{ '<leader>xq', function() require('trouble').toggle('quickfix') end, desc = 'Quickfix List (Trouble)' },
			{ '<leader>xl', function() require('trouble').toggle('loclist') end, desc = 'Location List (Trouble)' },
			{ 'gR', function() require('trouble').open('lsp_references') end, desc = 'LSP References (Trouble)' },
			{
				'[q',
				function()
					if require('trouble').is_open() then
						require('trouble').previous({ skip_groups = true, jump = true })
					else
						vim.cmd.cprev()
					end
				end,
				desc = 'Previous trouble/quickfix item',
			},
			{
				']q',
				function()
					if require('trouble').is_open() then
						require('trouble').next({ skip_groups = true, jump = true })
					else
						vim.cmd.cnext()
					end
				end,
				desc = 'Next trouble/quickfix item',
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Persist and toggle multiple terminals
	{
		'akinsho/toggleterm.nvim',
		cmd = 'ToggleTerm',
		keys = function(_, keys)
			local function toggleterm()
				local venv = vim.b['virtual_env']
				local term = require('toggleterm.terminal').Terminal:new({
					env = venv and { VIRTUAL_ENV = venv } or nil,
					count = vim.v.count > 0 and vim.v.count or 1,
				})
				term:toggle()
			end
			local mappings = {
				{ '<C-/>', mode = { 'n', 't' }, toggleterm, desc = 'Toggle terminal' },
				{ '<C-_>', mode = { 'n', 't' }, toggleterm, desc = 'which_key_ignore' },
			}
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			open_mapping = false,
			float_opts = {
				border = 'curved',
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Code outline sidebar powered by LSP
	{
		'hedyhli/outline.nvim',
		opts = {},
		cmd = { 'Outline', 'OutlineOpen' },
		keys = {
			{ '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
		},
	},

	-----------------------------------------------------------------------------
	-- Fancy window picker
	{
		's1n7ax/nvim-window-picker',
		event = 'VeryLazy',
		keys = function(_, keys)
			local pick_window = function()
				local picked_window_id = require('window-picker').pick_window()
				if picked_window_id ~= nil then
					vim.api.nvim_set_current_win(picked_window_id)
				end
			end

			local swap_window = function()
				local picked_window_id = require('window-picker').pick_window()
				if picked_window_id ~= nil then
					local current_winnr = vim.api.nvim_get_current_win()
					local current_bufnr = vim.api.nvim_get_current_buf()
					local other_bufnr = vim.api.nvim_win_get_buf(picked_window_id)
					vim.api.nvim_win_set_buf(current_winnr, other_bufnr)
					vim.api.nvim_win_set_buf(picked_window_id, current_bufnr)
				end
			end

			local mappings = {
				{ 'sp', pick_window, desc = 'Pick window' },
				{ 'sw', swap_window, desc = 'Swap picked window' },
			}
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			hint = 'floating-big-letter',
			show_prompt = false,
			filter_rules = {
				include_current_win = true,
				bo = {
					filetype = { 'notify', 'noice' },
					buftype = { 'prompt', 'nofile' },
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Fast Neovim http client written in Lua
	{
		'rest-nvim/rest.nvim',
		ft = 'http',
		keys = {
			{ '<Leader>mh', '<Plug>RestNvim', desc = 'Execute HTTP request' },
		},
		opts = { skip_ssl_verification = true },
	},

	-----------------------------------------------------------------------------
	-- Pretty window for navigating LSP locations
	{
		'dnlhc/glance.nvim',
		cmd = 'Glance',
		keys = {
			{ 'gpd', '<cmd>Glance definitions<CR>' },
			{ 'gpr', '<cmd>Glance references<CR>' },
			{ 'gpy', '<cmd>Glance type_definitions<CR>' },
			{ 'gpi', '<cmd>Glance implementations<CR>' },
		},
		opts = function()
			local actions = require('glance').actions
			return {
				folds = {
					fold_closed = '󰅂', -- 󰅂 
					fold_open = '󰅀', -- 󰅀 
					folded = true,
				},
				mappings = {
					list = {
						['<C-u>'] = actions.preview_scroll_win(5),
						['<C-d>'] = actions.preview_scroll_win(-5),
						['sg'] = actions.jump_vsplit,
						['sv'] = actions.jump_split,
						['st'] = actions.jump_tab,
						['p'] = actions.enter_win('preview'),
					},
					preview = {
						['q'] = actions.close,
						['p'] = actions.enter_win('list'),
					},
				},
			}
		end,
	},

	-----------------------------------------------------------------------------
	-- Find the enemy and replace them with dark power
	{
		'nvim-pack/nvim-spectre',
		-- stylua: ignore
		keys = {
			{ '<Leader>sp', function() require('spectre').toggle() end, desc = 'Spectre', },
			{ '<Leader>sp', function() require('spectre').open_visual({ select_word = true }) end, mode = 'x', desc = 'Spectre Word' },
		},
		opts = {
			open_cmd = 'noswapfile vnew',
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
						'--ignore',
					},
					options = {
						['gitignore'] = {
							value = '--no-ignore',
							icon = '[G]',
							desc = 'gitignore',
						},
					},
				},
			},
			default = {
				find = {
					cmd = 'rg',
					options = { 'ignore-case', 'hidden', 'gitignore' },
				},
			},
		},
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
	-- Generate table of contents for Markdown files
	{
		'mzlogin/vim-markdown-toc',
		cmd = { 'GenTocGFM', 'GenTocRedcarpet', 'GenTocGitLab', 'UpdateToc' },
		ft = 'markdown',
		keys = {
			{ '<leader>mo', '<cmd>UpdateToc<CR>', desc = 'Update table of contents' },
		},
		init = function()
			vim.g.vmt_auto_update_on_save = 0
		end,
	},
}
