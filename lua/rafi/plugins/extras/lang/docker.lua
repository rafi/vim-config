-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/docker.lua

return {

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'dockerfile' })
			end
		end,
	},

	{
		'mason.nvim',
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { 'hadolint' })
		end,
	},

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				dockerls = {},
				docker_compose_language_service = {
					autostart = false,
					-- filetypes = { 'yaml' },
					-- on_new_config = function(new_config, _)
					-- 	local name = vim.fs.basename(vim.api.nvim_buf_get_name(0))
					-- 	vim.notify(name)
					-- 	if name == nil or not name:find('docker-compose', 1, true) then
					-- 		new_config.enabled = false
					-- 	end
					-- end,
				},
			},
		},
	},

	{
		'nvimtools/none-ls.nvim',
		optional = true,
		opts = function(_, opts)
			local nls = require('null-ls')
			opts.sources = vim.list_extend(opts.sources or {}, {
				nls.builtins.diagnostics.hadolint,
			})
		end,
	},

	{
		'mfussenegger/nvim-lint',
		optional = true,
		opts = {
			linters_by_ft = {
				dockerfile = { 'hadolint' },
			},
		},
	},
}
