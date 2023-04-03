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
		event = { 'BufReadPost', 'BufNewFile' },
		main = 'nvim-treesitter.configs',
		build = ':TSUpdate',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
			{ 'nvim-treesitter/nvim-treesitter-context', opts = { enable = false }},
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
		},
		keys = {
			{ 'v', desc = 'Increment selection', mode = 'x' },
			{ 'V', desc = 'Shrink selection', mode = 'x' },
		},
		---@type TSConfig
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
					'html', 'xml', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
					'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
					'glimmer', 'handlebars', 'hbs',
				},
			},

			-- See: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
			context_commentstring = { enable = true, enable_autocmd = false },

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<Nop>',
					node_incremental = 'v',
					scope_incremental = '<Nop>',
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
				'diff',
				'dockerfile',
				'fish',
				'fennel',
				'git_config',
				'git_rebase',
				'gitcommit',
				'gitignore',
				'gitattributes',
				'go',
				'gomod',
				'gosum',
				'gowork',
				'graphql',
				'hcl',
				'html',
				'http',
				'java',
				'javascript',
				'jsdoc',
				'json',
				'json5',
				'jsonc',
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
				'python',
				'regex',
				'rst',
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
				'yaml',
				'zig',
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'andymass/vim-matchup',
		config = function()
			-- vim.g.matchup_transmute_enabled = 1
			vim.g.matchup_matchparen_offscreen = {
				method = 'popup',
				border = 'shadow',
				highlight = 'NormalFloat',
				fullwidth = true,
			}
			vim.api.nvim_create_autocmd('User', {
				group = vim.api.nvim_create_augroup('rafi_matchup', {}),
				pattern = 'MatchupOffscreenEnter',
				callback = function()
					vim.api.nvim_win_set_option(0, 'colorcolumn', '')
					vim.api.nvim_win_set_option(0, 'number', false)
				end,
			})
			end
	},

	-----------------------------------------------------------------------------
	{
		'kevinhwang91/nvim-ufo',
		event = { 'BufReadPost', 'BufNewFile' },
		keys = {
			{ 'zR', "<cmd>lua require'ufo'.openAllFolds()<CR>", noremap = true },
			{ 'zM', "<cmd>lua require'ufo'.closeAllFolds()<CR>", noremap = true },
		},
		dependencies = {
			'kevinhwang91/promise-async',
			'nvim-treesitter/nvim-treesitter',
		},
		opts = {
			provider_selector = function()
				return { 'treesitter', 'indent' }
			end
		},
	},

}
