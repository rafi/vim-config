-- Plugins: Tree-sitter and Syntax
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Vimscript syntax/indent plugins
	{ 'iloginow/vim-stylus', ft = 'stylus' },
	{ 'chrisbra/csv.vim', ft = 'csv' },
	{ 'towolf/vim-helm', ft = 'helm' },
	{ 'mustache/vim-mustache-handlebars', ft = {'html', 'mustache', 'handlebars'}},
	{ 'lifepillar/pgsql.vim', ft = 'pgsql' },
	{ 'MTDL9/vim-log-highlighting', ft = 'log' },
	{ 'tmux-plugins/vim-tmux', ft = 'tmux' },
	{ 'reasonml-editor/vim-reason-plus', ft = { 'reason', 'merlin' }},
	{ 'vmchale/just-vim', ft = 'just' },

	-----------------------------------------------------------------------------
	{
		'pearofducks/ansible-vim',
		ft = { 'ansible', 'ansible_hosts', 'jinja2' },
		init = function()
			vim.g.ansible_extra_keywords_highlight = 1
			vim.g.ansible_template_syntaxes = {
				['*.json.j2'] = 'json',
				['*.(ba)?sh.j2'] = 'sh',
				['*.ya?ml.j2'] = 'yaml',
				['*.xml.j2'] = 'xml',
				['*.conf.j2'] = 'conf',
				['*.ini.j2'] = 'ini',
			}
		end,
	},

	-----------------------------------------------------------------------------
	{
		'nvim-treesitter/nvim-treesitter',
		version = false,
		event = { 'BufReadPost', 'BufNewFile' },
		build = ':TSUpdate',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
			{ 'nvim-treesitter/nvim-treesitter-context', opts = { enable = false }},
			'JoosepAlviste/nvim-ts-context-commentstring',
			'RRethy/nvim-treesitter-endwise',
			'windwp/nvim-ts-autotag',
			{ 'monkoose/matchparen.nvim', config = true },
		},
		cmd = {
			'TSUpdate',
			'TSInstall',
			'TSInstallInfo',
			'TSModuleInfo',
			'TSConfigInfo',
		},
		keys = {
			{ 'v', desc = 'Increment selection', mode = 'x' },
			{ 'V', desc = 'Shrink selection', mode = 'x' },
		},
		---@type TSConfig
		opts = {
			-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
			ensure_installed = {
				'bash', 'comment', 'css', 'diff', 'dockerfile', 'fish', 'gitcommit',
				'gitignore', 'gitattributes', 'git_rebase', 'go', 'gomod', 'gosum',
				'gowork', 'graphql', 'hcl', 'help', 'html', 'http', 'java',
				'javascript', 'jsdoc', 'json', 'json5', 'jsonc', 'kotlin', 'lua',
				'luap', 'make', 'markdown', 'markdown_inline', 'nix', 'perl', 'php',
				'pug', 'python', 'regex', 'rst', 'ruby', 'rust', 'scala', 'scss',
				'sql', 'svelte', 'terraform', 'todotxt', 'toml', 'tsx', 'typescript',
				'vim', 'vue', 'yaml', 'zig',
			},

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			indent = {
				enable = true,
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<Nop>',
					node_incremental = 'v',
					scope_incremental = '<Nop>',
					node_decremental = 'V',
				},
			},

			refactor = {
				highlight_definitions = { enable = true },
				highlight_current_scope = { enable = true },
			},

			-- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			textobjects = {
				select = {
					enable = true,
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['ac'] = '@class.outer',
						['ic'] = '@class.inner',
						-- disabled: sideways.vim is better
						-- ['a,'] = '@parameter.outer',
						-- ['i,'] = '@parameter.inner',
					},
				},
				move = {
					enable = true,
					set_jumps = true,

					goto_next_start = {
						-- ['],'] = '@parameter.inner',
						[']m'] = '@function.outer',
						[']]'] = '@class.outer',
					},
					-- goto_next_end = {
					-- 	[']M'] = '@function.outer',
					-- 	[']['] = '@class.outer',
					-- },
					goto_previous_start = {
						-- ['[,'] = '@parameter.inner',
						['[m'] = '@function.outer',
						['[['] = '@class.outer',
					},
					-- goto_previous_end = {
					-- 	['[M'] = '@function.outer',
					-- 	['[]'] = '@class.outer',
					-- },
				},
				-- swap = {
				-- 	enable = true,
				-- 	swap_next = {
				-- 		['>,'] = '@parameter.inner',
				-- 		['>m'] = '@function.outer',
				-- 		['>e'] = '@element',
				-- 	},
				-- 	swap_previous = {
				-- 		['<,'] = '@parameter.inner',
				-- 		['<m'] = '@function.outer',
				-- 		['<e'] = '@element',
				-- 	},
				-- },
			},

			-- See: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
			-- Let the comment plugin call 'update_commentstring()' on-demand.
			context_commentstring = { enable = true, enable_autocmd = false },

			-- See: https://github.com/windwp/nvim-ts-autotag
			autotag = {
				enable = true,
				-- Removed markdown due to errors
				filetypes = {
					'html', 'xml', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
					'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
					'glimmer', 'handlebars', 'hbs',
				},
			},

			-- See: https://github.com/RRethy/nvim-treesitter-endwise
			endwise = { enable = true },

		},
		---@param opts TSConfig
		config = function(_, opts)
			require('nvim-treesitter.configs').setup(opts)
		end,
	},

}
