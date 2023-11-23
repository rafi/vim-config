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
		event = { 'BufReadPost', 'BufNewFile' },
		main = 'nvim-treesitter.configs',
		build = ':TSUpdate',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
			{ 'nvim-treesitter/nvim-treesitter-context', opts = { enable = false } },
			'JoosepAlviste/nvim-ts-context-commentstring',
			'RRethy/nvim-treesitter-endwise',
			'windwp/nvim-ts-autotag',
			'andymass/vim-matchup',
		},
		cmd = {
			'TSUpdate',
			'TSInstall',
			'TSInstallInfo',
			'TSModuleInfo',
			'TSConfigInfo',
			'TSUpdateSync',
		},
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

			-- See: https://github.com/windwp/nvim-ts-autotag
			autotag = {
				enable = true,
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

			-- See: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
			context_commentstring = { enable = true, enable_autocmd = false },

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = false,
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
						['],'] = '@parameter.inner',
					},
					goto_previous_start = {
						['[,'] = '@parameter.inner',
					},
				},
				swap = {
					enable = true,
					swap_next = {
						['>,'] = '@parameter.inner',
					},
					swap_previous = {
						['<,'] = '@parameter.inner',
					},
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
				'ruby',
				'rust',
				'scala',
				'scss',
				'sql',
				'svelte',
				'terraform',
				'todotxt',
				'toml',
				'tsx',
				'typescript',
				'vim',
				'vimdoc',
				'vue',
				'zig',
			},
		},
	},
}
