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
			local original_cr = opts.mapping['<CR>'].i or opts.mapping['<CR>']
			local confirm_copilot = cmp.mapping.confirm({
				select = true,
				behavior = cmp.ConfirmBehavior.Replace,
			})

			-- Add copilot nvim-cmp source.
			table.insert(opts.sources, 1, {
				name = 'copilot',
				group_index = 2,
			})

			-- Add copilot <CR> confirm behavior.
			opts.mapping = vim.tbl_extend('force', opts.mapping, {
				['<CR>'] = function(...)
					local entry = cmp.get_selected_entry()
					if entry and entry.source.name == 'copilot' then
						return confirm_copilot(...)
					end
					return original_cr(...)
				end,
			})

			-- Prepend Copilot's cmp comparator prioritization.
			if opts.sorting == nil then
				opts.sorting = { priority_weight = 2 }
			end
			if opts.sorting.comparators == nil then
				-- These are the default comparators in original order for nvim-cmp.
				opts.sorting.comparators = {
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
				}
			end
			table.insert(opts.sorting.comparators, 1,
				require('copilot_cmp.comparators').prioritize)
		end,
	},
}
