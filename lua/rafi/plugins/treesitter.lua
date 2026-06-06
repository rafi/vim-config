-- Plugins: Tree-sitter and Syntax
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/treesitter.lua
	{ 'nvim-treesitter', enabled = false },

	-----------------------------------------------------------------------------
	-- Vimscript syntax/indent plugins
	{ 'iloginow/vim-stylus', ft = 'stylus' },
	{ 'mustache/vim-mustache-handlebars', ft = { 'mustache', 'handlebars' } },
	{ 'lifepillar/pgsql.vim', ft = 'pgsql' },
	{ 'MTDL9/vim-log-highlighting', ft = 'log' },
	{ 'reasonml-editor/vim-reason-plus', ft = { 'reason', 'merlin' } },

	-----------------------------------------------------------------------------
	-- Automatically add closing tags for HTML and JSX
	{
		'windwp/nvim-ts-autotag',
		event = 'InsertEnter',
	},

	-----------------------------------------------------------------------------
	-- Modern matchit and matchparen
	-- See: https://github.com/andymass/vim-matchup
	{
		'andymass/vim-matchup',
		event = { 'LazyFile', 'VeryLazy' },
		opts = {
			enable = true,
			include_match_words = true,
			matchparen = {
				offscreen = {},
			},
		},
	},

	-----------------------------------------------------------------------------
	-- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
		branch = 'main',
		event = { 'LazyFile', 'VeryLazy' },
		opts = {
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
					[']K'] = '@parameter.inner',
				},
				goto_previous_start = {
					['[f'] = '@function.outer',
					['[c'] = '@class.outer',
					['[,'] = '@parameter.inner',
				},
				goto_previous_end = {
					['[F'] = '@function.outer',
					['[C'] = '@class.outer',
					['[K'] = '@parameter.inner',
				},
			},
			swap = {
				enable = true,
				swap_next = { ['>,'] = '@parameter.inner' },
				swap_previous = { ['<,'] = '@parameter.inner' },
			},
		},
	},

	{
		'romus204/tree-sitter-manager.nvim',
		event = { 'LazyFile', 'VeryLazy' },
		cmd = { 'TSManager' },
		opts_extend = { 'ensure_installed' },
		opts = {
			auto_install = true,
			ensure_installed = {
				'bash',
				'c',
				'comment',
				'css',
				'csv',
				'cue',
				'diff',
				'dockerfile',
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
				'jinja',
				'jsdoc',
				'json',
				'json5',
				'just',
				'lua',
				'luadoc',
				'luap',
				'make',
				'markdown',
				'mermaid',
				'printf',
				'proto',
				'python',
				'query',
				'readline',
				'regex',
				'scss',
				'sql',
				'ssh_config',
				'svelte',
				'toml',
				'tsx',
				'typescript',
				'typst',
				'vhs',
				'vim',
				'vimdoc',
				'xml',
				'yaml',
				'zig',
				'zsh',
			},
		},
	},
}
