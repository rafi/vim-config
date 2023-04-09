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
		init = function()
			vim.g.matchup_matchparen_offscreen = {}
		end
	},

	-----------------------------------------------------------------------------
	{
		'kevinhwang91/nvim-ufo',
		event = { 'BufReadPost', 'BufNewFile' },
		keys = {
			{ 'zR', function() require('ufo').openAllFolds() end },
			{ 'zM', function() require('ufo').closeAllFolds() end },
			{ 'zr', function() require('ufo').openFoldsExceptKinds() end },
			{ 'zm', function() require('ufo').closeFoldsWith() end },
		},
		dependencies = {
			'kevinhwang91/promise-async',
			'nvim-treesitter/nvim-treesitter',
		},
		opts = function()
			-- lsp->treesitter->indent
			---@param bufnr number
			local function customizeSelector(bufnr)
				local function handleFallbackException(err, providerName)
					if type(err) == 'string' and err:match('UfoFallbackException') then
						return require('ufo').getFolds(bufnr, providerName)
					else
						return require('promise').reject(err)
					end
				end

				return require('ufo').getFolds(bufnr, 'lsp'):catch(function(err)
					return handleFallbackException(err, 'treesitter')
				end):catch(function(err)
					return handleFallbackException(err, 'indent')
				end)
			end

			local ft_providers = {
				vim = 'indent',
				python = { 'indent' },
				git = '',
				help = '',
				qf = '',
				fugitive = '',
				fugitiveblame = '',
				['neo-tree'] = '',
			}

			return {
				open_fold_hl_timeout = 0,
				close_fold_kinds = { 'imports', 'comment' },
				preview = {
					win_config = {
						border = { '', '─', '', '', '', '─', '', '' },
						winhighlight = 'Normal:Folded',
						winblend = 10
					},
					mappings = {
						scrollU = '<C-u>',
						scrollD = '<C-d>',
						jumpTop = '[',
						jumpBot = ']'
					}
				},

				-- Select the fold provider.
				provider_selector = function(_, filetype, _)
					return ft_providers[filetype] or customizeSelector
				end,

				-- Display text for folded lines.
				---@param text table
				---@param lnum integer
				---@param endLnum integer
				---@param width integer
				fold_virt_text_handler = function(text, lnum, endLnum, width)
					local suffix = "  "
					local lines  = ('  %d '):format(endLnum - lnum)

					local cur_width = 0
					for _, section in ipairs(text) do
						cur_width = cur_width + vim.fn.strdisplaywidth(section[1])
					end

					suffix = suffix
						.. (' '):rep(width - cur_width - vim.fn.strdisplaywidth(lines) - 3)

					table.insert(text, { suffix, 'UfoFoldedEllipsis' })
					table.insert(text, { lines, 'UfoCursorFoldedLine' })
					return text
				end,
			}
		end,
	},

}
