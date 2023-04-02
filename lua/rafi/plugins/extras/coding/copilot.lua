return {

	-----------------------------------------------------------------------------
	{
		'zbirenbaum/copilot.lua',
		cmd = 'Copilot',
		build = ':Copilot auth',
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
		},
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
					require('rafi.config').on_attach(function(client)
						if client.name == 'copilot' then
							copilot_cmp._on_insert_enter()
						end
					end)
				end,
			},
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local cmp = require('cmp')

			table.insert(opts.sources, 1, { name = 'copilot', group_index = 2 })

			local fallback = opts.mapping['<CR>'].i
			local confirm_copilot = cmp.mapping.confirm({
				select = true,
				behavior = cmp.ConfirmBehavior.Replace,
			})

			opts.mapping = vim.tbl_extend('force', opts.mapping, {
				['<CR>'] = function(...)
					local entry = cmp.get_selected_entry()
					if entry and entry.source.name == 'copilot' then
						return confirm_copilot(...)
					end
					return fallback(...)
				end,
			})
			opts.sorting = {
				priority_weight = 2,
				comparators = {
					require('copilot_cmp.comparators').prioritize,

					-- Below is the default comparitor list and order for nvim-cmp
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					-- cmp.config.compare.scopes, -- this is commented in nvim-cmp too
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.locality,
					cmp.config.compare.kind,
					-- cmp.config.compare.sort_text, -- this is commented in nvim-cmp too
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			}
		end,
	},
}
