-- Plugins: Editor
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Automatic indentation style detection
	{ 'nmac427/guess-indent.nvim', lazy = false, priority = 50, opts = {} },

	-- Display vim version numbers in docs
	{ 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion' },

	-- An alternative sudo for Vim and Neovim
	{ 'lambdalisue/suda.vim', event = 'BufRead' },

	-----------------------------------------------------------------------------
	-- FZF picker
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/editor/fzf.lua
	{
		'fzf-lua',
		optional = true,
		opts = {
			defaults = {
				git_icons = vim.fn.executable('git') == 1,
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Simple lua plugin for automated session management
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/util.lua
	{
		'persistence.nvim',
		event = 'VimEnter',
		-- stylua: ignore
		keys = {
			{ '<localleader>s', "<cmd>lua require'persistence'.select()<CR>", desc = 'Sessions' },
		},
		opts = {
			branch = false,
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
				group = vim.api.nvim_create_augroup('rafi.persistence', {}),
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
				group = 'rafi.persistence',
				once = true,
				nested = true,
				callback = function()
					local opts = LazyVim.opts('persistence.nvim')
					if not opts.autoload then
						return
					end
					local cwd = vim.uv.cwd() or vim.fn.getcwd()
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
	-- Search labels, enhanced character motions
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
	{
		'flash.nvim',
		event = 'VeryLazy',
		vscode = true,
		---@type Flash.Config
		opts = {
			modes = {
				search = {
					enabled = false,
				},
			},
		},
		-- stylua: ignore
		keys = {
			-- Disable LazyVim default 's' keymap, switch to 'ss'
			{ 's', mode = { 'n', 'x', 'o' }, false },
			{ 'ss', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
		},
	},

	-----------------------------------------------------------------------------
	-- Create key bindings that stick
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
	{
		'which-key.nvim',
		keys = {
			-- Replace <leader>? with <leader>bk
			{ '<leader>?', false },
			{
				'<leader>bk',
				function()
					require('which-key').show({ global = false })
				end,
				desc = 'Buffer Keymaps (which-key)',
			},
		},
		-- stylua: ignore
		opts = {
			icons = {
				breadcrumb = '»',
				separator = '󰁔  ', -- ➜
			},
			delay = function(ctx)
				return ctx.plugin and 0 or 400
			end,
			spec = {
				{
					{ 'gs', group = nil },
					{ 'gz', group = 'surround', icon = { icon = '󱞹 ', color = 'cyan' } },
					{ ';d', group = 'lsp' },
					{ ';',  group = 'picker' },
					{ '<leader>cl', group = 'calls' },
					{ '<leader>ci', group = 'info' },
					{ '<leader>fw', group = 'workspace' },
					{ '<leader>ght', group = 'toggle' },
					{ '<leader>ht', group = 'toggle' },
					{ '<leader>m',  group = 'tools', icon = { icon = '󱁤 ', color = 'blue' } },
					{ '<leader>md', group = 'diff', icon = { icon = ' ', color = 'green' } },
					{ '<leader>z', group = 'notes' },
					{ '<leader>w', group = nil },
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Pretty lists to help you solve all code diagnostics
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
	{
		'trouble.nvim',
		-- stylua: ignore
		keys = {
			{ '<leader>cs', false },
			{ '<leader>cS', false },

			{ 'gR', function() require('trouble').open('lsp_references') end, desc = 'LSP References (Trouble)' },
			{ '<leader>xs', '<cmd>Trouble symbols toggle<CR>', desc = 'Symbols (Trouble)' },
			{ '<leader>xS', '<cmd>Trouble lsp toggle<CR>', desc = 'LSP references/definitions/... (Trouble)' },
		},
	},

	-----------------------------------------------------------------------------
	-- Highlight, list and search todo comments in your projects
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
	{
		'todo-comments.nvim',
		opts = { signs = false },
	},

	-----------------------------------------------------------------------------
	-- Code outline sidebar powered by LSP
	{
		'hedyhli/outline.nvim',
		cmd = { 'Outline', 'OutlineOpen' },
		keys = {
			{ '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
		},
		opts = function()
			local defaults = require('outline.config').defaults
			local opts = {
				symbols = {
					icons = {},
					filter = vim.deepcopy(LazyVim.config.kind_filter),
				},
				keymaps = {
					up_and_jump = '<up>',
					down_and_jump = '<down>',
				},
			}

			for kind, symbol in pairs(defaults.symbols.icons) do
				opts.symbols.icons[kind] = {
					icon = LazyVim.config.icons.kinds[kind] or symbol.icon,
					hl = symbol.hl,
				}
			end
			return opts
		end,
	},

	-----------------------------------------------------------------------------
	-- Ultimate undo history visualizer
	{
		'mbbill/undotree',
		cmd = 'UndotreeToggle',
		keys = {
			{ '<leader>gu', '<cmd>UndotreeToggle<CR>', desc = 'Undo Tree' },
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
				autoselect_one = true,
				bo = {
					filetype = { 'notify', 'noice', 'neo-tree-popup' },
					buftype = { 'prompt', 'nofile', 'quickfix' },
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Pretty window for navigating LSP locations
	{
		'dnlhc/glance.nvim',
		cmd = 'Glance',
		-- stylua: ignore
		keys = {
			{ '<leader>cg', '', desc = '+glance' },
			{ '<leader>cgd', '<cmd>Glance definitions<CR>', desc = 'Glance Definitions' },
			{ '<leader>cgr', '<cmd>Glance references<CR>', desc = 'Glance References' },
			{ '<leader>cgy', '<cmd>Glance type_definitions<CR>', desc = 'Glance Type Definitions' },
			{ '<leader>cgi', '<cmd>Glance implementations<CR>', desc = 'Glance implementations' },
			{ '<leader>cgu', '<cmd>Glance resume<CR>', desc = 'Glance Resume' },
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
}
