-- rafi.plugins.extras.lang.python
--

-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/python.lua
return {

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(
					opts.ensure_installed,
					{ 'ninja', 'python', 'pymanifest', 'requirements', 'rst', 'toml' }
				)
			end
		end,
	},

	{
		'neovim/nvim-lspconfig',
		dependencies = 'rafi/neoconf-venom.nvim',
		opts = {
			servers = {
				pyright = {},
			},
		},
	},

	{
		'mhartington/formatter.nvim',
		optional = true,
		opts = function(_, opts)
			opts = opts or {}
			local fmts = require('formatter.filetypes.python')
			local filetypes = {
				python = {
					fmts.black,
					fmts.yapf,
					fmts.pyment,
					fmts.isort,
					fmts.docformatter,
				},
			}
			opts.filetype = vim.tbl_extend('keep', opts.filetype or {}, filetypes)
		end,
	},

	{
		'rafi/neoconf-venom.nvim',
		main = 'venom',
		opts = {},
		-- stylua: ignore
		keys = {
			{ '<leader>cv', '<cmd>Telescope venom virtualenvs<cr>', ft = 'python', desc = 'Select VirtualEnv' },
		},
	},

	{
		'nvim-neotest/neotest',
		optional = true,
		dependencies = {
			'nvim-neotest/neotest-python',
		},
		opts = {
			adapters = {
				['neotest-python'] = {
					-- Here you can specify the settings for the adapter, i.e.
					-- runner = 'pytest',
					-- python = '.venv/bin/python',
				},
			},
		},
	},

	{
		'mfussenegger/nvim-dap',
		optional = true,
		dependencies = {
			'mfussenegger/nvim-dap-python',
			-- stylua: ignore
			keys = {
				{ '<leader>dPt', function() require('dap-python').test_method() end, desc = 'Debug Method', ft = 'python' },
				{ '<leader>dPc', function() require('dap-python').test_class() end, desc = 'Debug Class', ft = 'python' },
			},
			config = function()
				local path =
					require('mason-registry').get_package('debugpy'):get_install_path()
				require('dap-python').setup(path .. '/venv/bin/python')
			end,
		},
	},
}
