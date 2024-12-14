-- Plugins: Tree-sitter and Syntax
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Vimscript syntax/indent plugins
	{ 'iloginow/vim-stylus', ft = 'stylus' },
	{ 'mustache/vim-mustache-handlebars', ft = { 'mustache', 'handlebars' } },
	{ 'lifepillar/pgsql.vim', ft = 'pgsql' },
	{ 'MTDL9/vim-log-highlighting', ft = 'log' },
	{ 'reasonml-editor/vim-reason-plus', ft = { 'reason', 'merlin' } },

	{
		'folke/which-key.nvim',
		opts = {
			spec = {
				{ '<C-Space>', desc = 'Increment Selection' },
				{ 'v', desc = 'Increment Selection', mode = 'x' },
				{ 'V', desc = 'Decrement Selection', mode = 'x' },
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Treesitter configurations and abstraction layer for faster and more
	-- accurate syntax highlighting.
	{
		'nvim-treesitter/nvim-treesitter',
		version = false,
		build = ':TSUpdate',
		event = { 'LazyFile', 'VeryLazy' },
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
		keys = {
			{ '<C-Space>', desc = 'Increment Selection' },
			{ 'v', desc = 'Increment Selection', mode = 'x' },
			{ 'V', desc = 'Decrement Selection', mode = 'x' },
		},
		init = function(plugin)
			-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
			-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
			-- no longer trigger the **nvim-treesitter** module to be loaded in time.
			-- Luckily, the only things that those plugins need are the custom queries, which we make available
			-- during startup.
			require('lazy.core.loader').add_to_rtp(plugin)
			require('nvim-treesitter.query_predicates')
		end,
		dependencies = {
			-- Modern matchit and matchparen
			{
				'andymass/vim-matchup',
				init = function()
					vim.g.matchup_matchparen_offscreen = {}
				end,
			},
		},
		opts_extend = { 'ensure_installed' },
		---@type TSConfig
		---@diagnostic disable: missing-fields
		opts = {
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max_filesize = 1024 * 1024 -- 1MB
					local ok, stats =
						pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},
			indent = { enable = true },
			refactor = {
				highlight_definitions = { enable = true },
				highlight_current_scope = { enable = true },
			},

			-- See: https://github.com/andymass/vim-matchup
			matchup = {
				enable = true,
				include_match_words = true,
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<C-Space>',
					node_incremental = 'v',
					scope_incremental = false,
					node_decremental = 'V',
				},
			},

			-- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['ac'] = '@class.outer',
						['ic'] = '@class.inner',
						['a,'] = '@parameter.outer',
						['i,'] = '@parameter.inner',
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						[']f'] = '@function.outer',
						[']c'] = '@class.outer',
						['],'] = '@parameter.inner',
					},
					goto_next_end = {
						[']F'] = '@function.outer',
						[']C'] = '@class.outer',
					},
					goto_previous_start = {
						['[f'] = '@function.outer',
						['[c'] = '@class.outer',
						['[,'] = '@parameter.inner',
					},
					goto_previous_end = {
						['[F'] = '@function.outer',
						['[C'] = '@class.outer',
					},
				},
				swap = {
					enable = true,
					swap_next = { ['>,'] = '@parameter.inner' },
					swap_previous = { ['<,'] = '@parameter.inner' },
				},
			},

			-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
			ensure_installed = {
				'bash',
				'c',
				'comment',
				'css',
				'csv',
				'cue',
				'diff',
				'dtd',
				'editorconfig',
				'fish',
				'git_config',
				'git_rebase',
				'gitattributes',
				'gitcommit',
				'gitignore',
				'graphql',
				'html',
				'http',
				'javascript',
				'jsdoc',
				'json5',
				'just',
				'lua',
				'luadoc',
				'luap',
				'make',
				'markdown',
				'markdown_inline',
				'printf',
				'python',
				'query',
				'readline',
				'regex',
				'scss',
				'sql',
				'ssh_config',
				'svelte',
				'toml',
				'vim',
				'vimdoc',
				'xml',
				'yaml',
				'zig',
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				---@diagnostic disable-next-line: param-type-mismatch
				opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
			end
			require('nvim-treesitter.configs').setup(opts)
		end,
	},

	-----------------------------------------------------------------------------
	-- Textobjects using treesitter queries
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
		event = 'VeryLazy',
		config = function()
			-- If treesitter is already loaded, we need to run config again for textobjects
			if LazyVim.is_loaded('nvim-treesitter') then
				local opts = LazyVim.opts('nvim-treesitter')
				require('nvim-treesitter.configs').setup({
					textobjects = opts.textobjects,
				})
			end

			-- When in diff mode, we want to use the default
			-- vim text objects c & C instead of the treesitter ones.
			local move = require('nvim-treesitter.textobjects.move') ---@type table<string,fun(...)>
			local configs = require('nvim-treesitter.configs')
			for name, fn in pairs(move) do
				if name:find('goto') == 1 then
					move[name] = function(q, ...)
						if vim.wo.diff then
							local config = configs.get_module('textobjects.move')[name] ---@type table<string,string>
							for key, query in pairs(config or {}) do
								if q == query and key:find('[%]%[][cC]') then
									vim.cmd('normal! ' .. key)
									return
								end
							end
						end
						return fn(q, ...)
					end
				end
			end
		end,
	},

	-----------------------------------------------------------------------------
	-- Automatically add closing tags for HTML and JSX
	{
		'windwp/nvim-ts-autotag',
		event = 'InsertEnter',
		opts = {},
	},
}
