-- Plugins: Tree-sitter and Syntax
-- https://github.com/rafi/vim-config

local has_git = vim.fn.executable('git') == 1

return {

	-----------------------------------------------------------------------------
	-- Vimscript syntax/indent plugins
	{ 'iloginow/vim-stylus', ft = 'stylus' },
	{ 'mustache/vim-mustache-handlebars', ft = { 'mustache', 'handlebars' } },
	{ 'lifepillar/pgsql.vim', ft = 'pgsql' },
	{ 'MTDL9/vim-log-highlighting', ft = 'log' },
	{ 'reasonml-editor/vim-reason-plus', ft = { 'reason', 'merlin' } },

	-----------------------------------------------------------------------------
	{
		'which-key.nvim',
		opts = {
			spec = {
				{ 'V', desc = 'Decrement Selection', mode = 'x' },
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Automatically add closing tags for HTML and JSX
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/treesitter.lua
	{
		'nvim-ts-autotag',
		event = 'InsertEnter',
	},

	-----------------------------------------------------------------------------
	-- Treesitter configurations and abstraction layer for faster and more
	-- accurate syntax highlighting.
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/treesitter.lua
	{
		'nvim-treesitter',
		keys = {
			{ '<bs>', false, mode = 'x' },
			{ 'V', desc = 'Decrement Selection', mode = 'x' },
		},
		dependencies = {
			-- Modern matchit and matchparen
			{
				'andymass/vim-matchup',
				init = function()
					vim.g.matchup_matchparen_offscreen = {}
				end,
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
			end
			if not has_git then
				require('nvim-treesitter.install').ensure_installed = function() end
			end
			require('nvim-treesitter.configs').setup(opts)
		end,
		---@type TSConfig
		---@diagnostic disable: missing-fields
		opts = {
			sync_install = has_git,
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
					init_selection = '<c-space>',
					node_incremental = '<c-space>',
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
				'comment',
				'css',
				'csv',
				'cue',
				'dtd',
				'editorconfig',
				'fish',
				'git_config',
				'git_rebase',
				'gitattributes',
				'gitcommit',
				'gitignore',
				'graphql',
				'http',
				'json5',
				'just',
				'make',
				'readline',
				'scss',
				'sql',
				'ssh_config',
				'svelte',
				'vhs',
				'zig',
			},
		},
	},
}
