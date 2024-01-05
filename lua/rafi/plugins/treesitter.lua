-- Plugins: Tree-sitter and Syntax
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Vimscript syntax/indent plugins
	{ 'iloginow/vim-stylus', ft = 'stylus' },
	{ 'chrisbra/csv.vim', ft = 'csv' },
	{ 'mustache/vim-mustache-handlebars', ft = { 'mustache', 'handlebars' } },
	{ 'lifepillar/pgsql.vim', ft = 'pgsql' },
	{ 'MTDL9/vim-log-highlighting', ft = 'log' },
	{ 'reasonml-editor/vim-reason-plus', ft = { 'reason', 'merlin' } },
	{ 'vmchale/just-vim', ft = 'just' },

	-----------------------------------------------------------------------------
	{
		'andymass/vim-matchup',
		init = function()
			vim.g.matchup_matchparen_offscreen = {}
		end,
	},

	-----------------------------------------------------------------------------
	{
		'nvim-treesitter/nvim-treesitter',
		version = false,
		build = ':TSUpdate',
		event = { 'LazyFile', 'VeryLazy' },
		dependencies = {
			{
				'nvim-treesitter/nvim-treesitter-textobjects',
				config = function()
					-- When in diff mode, we want to use the default
					-- vim text objects c & C instead of the treesitter ones.
					require'nvim-treesitter.install'.compilers = {'gcc-11'}
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
			'RRethy/nvim-treesitter-endwise',
			'andymass/vim-matchup',
		},
		cmd = { 'TSInstall', 'TSUpdate', 'TSUpdateSync' },
		keys = {
			{ 'v', desc = 'Increment selection', mode = 'x' },
			{ 'V', desc = 'Shrink selection', mode = 'x' },
		},
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			refactor = {
				highlight_definitions = { enable = true },
				highlight_current_scope = { enable = true },
			},

			-- See: https://github.com/RRethy/nvim-treesitter-endwise
			endwise = { enable = true },

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
				'comment',
				'css',
				'cue',
				'diff',
				'fish',
				'fennel',
				'git_config',
				'git_rebase',
				'gitcommit',
				'gitignore',
				'gitattributes',
				'graphql',
				'hcl',
				'html',
				'http',
				'java',
				'javascript',
				'jsdoc',
				'kotlin',
				'lua',
				'luadoc',
				'luap',
				'make',
				'markdown',
				'markdown_inline',
				'nix',
				'perl',
				'php',
				'pug',
				'regex',
				'scala',
				'scss',
				'sql',
				'svelte',
				'todotxt',
				'toml',
				'vim',
				'vimdoc',
				'vue',
				'zig',
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				---@type table<string, boolean>
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed)
			end
			require('nvim-treesitter.configs').setup(opts)
		end,
	},

	-- Show context of the current function
	{
		'nvim-treesitter/nvim-treesitter-context',
		-- event = 'LazyFile',
		opts = {
			mode = 'cursor',
			max_lines = 3,
		},
		keys = {
			{
				'<leader>ut',
				function()
					local Util = require('lazyvim.util')
					local tsc = require('treesitter-context')
					tsc.toggle()
					if Util.inject.get_upvalue(tsc.toggle, 'enabled') then
						Util.info('Enabled Treesitter Context', { title = 'Option' })
					else
						Util.warn('Disabled Treesitter Context', { title = 'Option' })
					end
				end,
				desc = 'Toggle Treesitter Context',
			},
		},
	},

	-- Automatically add closing tags for HTML and JSX
	{
		'windwp/nvim-ts-autotag',
		event = 'LazyFile',
		opts = {
			-- Removed markdown due to errors
			filetypes = {
				'glimmer',
				'handlebars',
				'hbs',
				'html',
				'javascript',
				'javascriptreact',
				'jsx',
				'rescript',
				'svelte',
				'tsx',
				'typescript',
				'typescriptreact',
				'vue',
				'xml',
			},
		},
	},
}
