-- rafi.plugins.extras.lang.go
--

return {
	desc = 'Imports Go lang extras and adds more tools.',
	recommended = function()
		return LazyVim.extras.wants({
			ft = { 'go', 'gomod', 'gowork', 'gotmpl' },
			root = { 'go.work', 'go.mod' },
		})
	end,

	{ import = 'lazyvim.plugins.extras.lang.go' },

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			opts = opts or {}
			opts.ensure_installed = {
				'go',
				'gomod',
				'gosum',
				'gotmpl',
				'gowork',
			}

			-- Convert a JSON string to a Go struct.
			vim.api.nvim_buf_create_user_command(
				0,
				'JsonToStruct',
				---@param args table
				function(args)
					local range = args.line1 .. ',' .. args.line2
					local fname = vim.api.nvim_buf_get_name(0)
					local cmd = { '!json-to-struct' }
					table.insert(cmd, '-name ' .. vim.fn.fnamemodify(fname, ':t:r'))
					table.insert(cmd, '-pkg ' .. vim.fn.fnamemodify(fname, ':h:t:r'))
					vim.cmd(range .. ' ' .. table.concat(cmd, ' '))
				end,
				{ bar = true, nargs = 0, range = true }
			)
		end,
	},

	{
		'williamboman/mason.nvim',
		opts = {
			ensure_installed = {
				'gofumpt',
				'goimports-reviser',
				'gomodifytags',
				'impl',
				'json-to-struct',
			},
		},
	},

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				gopls = {
					settings = {
						-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
						gopls = {
							-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
							analyses = {
								fieldalignment = false,
								unusedvariable = true,
								-- shadow = true,
								-- ST1000 = false,
								-- ST1005 = false,
							},
						},
					},
				},
			},
		},
	},
}
