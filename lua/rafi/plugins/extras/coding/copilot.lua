-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/copilot.lua

return {

	-----------------------------------------------------------------------------
	{
		'zbirenbaum/copilot.lua',
		cmd = 'Copilot',
		build = ':Copilot auth',
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'nvim-lualine/lualine.nvim',
		optional = true,
		event = 'VeryLazy',
		opts = function(_, opts)
			local get_color = require('rafi.lib.color').get_color
			local fg = function(...)
				return { fg = get_color('fg', ...) }
			end

			local colors = {
				[''] = fg({ 'Comment' }),
				['Normal'] = fg({ 'Comment' }),
				['Warning'] = fg({ 'DiagnosticError' }),
				['InProgress'] = fg({ 'DiagnosticWarn' }),
			}
			-- Add copilot icon to lualine statusline
			table.insert(opts.sections.lualine_x, {
				function()
					local icon = require('rafi.config').icons.kinds.Copilot
					local status = require('copilot.api').status.data
					return icon .. (status.message or '')
				end,
				cond = function()
					local clients
					if vim.lsp.get_clients ~= nil then
						clients = vim.lsp.get_clients({ name = 'copilot', bufnr = 0 })
					else
						---@diagnostic disable-next-line: deprecated
						clients = vim.lsp.get_active_clients({
							name = 'copilot',
							bufnr = 0,
						})
					end
					return #clients > 0
				end,
				color = function()
					if not package.loaded["copilot"] then
						return
					end
					local status = require('copilot.api').status.data
					return colors[status.status] or colors['']
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	{
		'nvim-cmp',
		dependencies = {
			{
				'zbirenbaum/copilot-cmp',
				dependencies = 'zbirenbaum/copilot.lua',
				opts = {},
				config = function(_, opts)
					local copilot_cmp = require('copilot_cmp')
					copilot_cmp.setup(opts)
					-- attach cmp source whenever copilot attaches
					-- fixes lazy-loading issues with the copilot cmp source
					---@param client lsp.Client
					require('rafi.lib.utils').on_attach(function(client)
						if client.name == 'copilot' then
							copilot_cmp._on_insert_enter({})
						end
					end)
				end,
			},
		},
		---@param opts cmp.ConfigSchema|{sources: table[]}
		opts = function(_, opts)
			-- Add copilot nvim-cmp source.
			table.insert(opts.sources, 1, {
				name = 'copilot',
				group_index = 2,
				priority = 60,
			})
			opts.sorting = opts.sorting or require('cmp.config.default')().sorting
			table.insert(
				opts.sorting.comparators,
				1,
				require('copilot_cmp.comparators').prioritize
			)
		end,
	},
}
