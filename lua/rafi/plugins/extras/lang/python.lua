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
					{ 'ninja', 'python', 'requirements', 'rst', 'toml' }
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
		'rafi/neoconf-venom.nvim',
		main = 'venom',
		opts = {},
		-- stylua: ignore
		keys = {
			{ '<leader>cv', '<cmd>Telescope venom virtualenvs<cr>', desc = 'Select VirtualEnv' },
		},
	},

	{
		'nvim-neotest/neotest',
		optional = true,
		dependencies = { 'nvim-neotest/neotest-python' },
		opts = {
			adapters = {
				['neotest-python'] = {
					-- Here you can specify the settings for the adapter, i.e.
					-- runner = "pytest",
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
				{ '<leader>dPt', function() require('dap-python').test_method() end, desc = 'Debug Method' },
				{ '<leader>dPc', function() require('dap-python').test_class() end, desc = 'Debug Class' },
			},
			config = function()
				local path =
					require('mason-registry').get_package('debugpy'):get_install_path()
				require('dap-python').setup(path .. '/venv/bin/python')
			end,
		},
	},
}
